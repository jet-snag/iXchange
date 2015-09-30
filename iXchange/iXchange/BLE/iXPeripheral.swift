//
//  iXPeripheral.swift
//  iXchange
//
//  Created by Marko Markov on 25/09/15.
//  Copyright © 2015 Channel Enterprise HK. All rights reserved.
//

import UIKit
import CoreBluetooth

class iXPeripheral: NSObject, CBPeripheralDelegate {

    // Core Peripheral
    var mPeripheral : CBPeripheral
    var mCentralManager : CBCentralManager
    
    // Peripheral UUID
    var mUUIDString : String = ""
    
    // Peripheral Name
    var mPeripheralName : String = "iXPeripheral"
    
    // RSSI
    var mRSSI : Int = 0
    
    // AdvertisementData
    var mAdvertisementData : [NSObject : AnyObject]?
    
    // Is device connected?
    var mIsConnected : Bool = false
    
    // Is discovering service is in progress?
    var mIsDiscoveringSerivces : Bool = false
    
    // Watch dog
    var mWatchDogRaised : Bool = false
    var mWatchDogTimer : NSTimer?
    
    init(_peripheral : CBPeripheral, _centralManager : CBCentralManager) {
        mPeripheral = _peripheral
        mCentralManager = _centralManager
        
        super.init()
        
        // Register Delegate
        mPeripheral.delegate = self
        
        if let name = mPeripheral.name {
            mPeripheralName = name
        }
    }
    
    /**
    * Returns if peripheral is connectable or not
    * @params - no
    */
    func isConnectable() -> Bool {
        
        if mPeripheral.state == .Connected || mPeripheral.state == .Connecting {
            return false
        }
        
        return true
    }
    
    /**
    * Opens connection WITHOUT timeout to this peripheral
    * @param aCallback Will be called after successfull/failure connection
    */
    func connect( ) {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Connect to (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Reset watchDog
        mWatchDogRaised = false
        
        // Connect via CoreBluetooth
        mCentralManager.connectPeripheral(mPeripheral, options: nil)
    }
    
    /**
    * Opens connection WITH timeout to this peripheral
    * @param aWatchDogInterval timeout after which, connection will be closed (if it was in stage isConnecting)
    * @param aCallback Will be called after successfull/failure connection
    */
    func connectWithTimeout( watchDogInterval timeout : Int ) {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Connect to (%@) with timeout", args: mPeripheral.identifier.UUIDString)
        
        // Perform normal connection first
        connect()
        
        // Fire watchDog after delay
        mWatchDogTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval( timeout ), target: self, selector: Selector("connectionWatchDogFired"), userInfo: nil, repeats: false)
    }
    
    /**
    * Disconnects from peripheral peripheral
    * @param aCallback Will be called after successfull/failure disconnect
    */
    func disconnect( ) {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Disconnect from (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Disconnect via CoreBluetooth
        mCentralManager.cancelPeripheralConnection(mPeripheral)
    }
    
    /**
    * Discoveres All services of this peripheral
    * @param aCallback Will be called after successfull/failure discovery
    */
    func discoverServices( ) {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Discovering service from (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Pass to default member
        discoverServices(UUIDs: nil)
    }
    
    /**
    * Discoveres Input services of this peripheral
    * @param serviceUUIDs Array of CBUUID's that contain service UUIDs which
    * we need to discover
    * @param aCallback Will be called after successfull/failure ble-operation
    */
    func discoverServices( UUIDs serviceUUIDs : [CBUUID]? ) {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Discovering service with UUID from (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Discover services
        // If device is connected, then perform discover
        if mIsConnected == true {
            
            // Set as discovering is in progress
            mIsDiscoveringSerivces = true
            
            // Discover via CoreBluetooth
            mPeripheral.discoverServices(serviceUUIDs)
        }
        else { // Not yet connected, should be error
            
            // Process as error
            deviceDelegate?.didFailToDiscoverCharacteristics(self, error: connectionErrorWithCode(errorCode: kConnectionMissingErrorCode, errorMessage: kConnectionMissingErrorMessage))
        }
    }
    
    /**
    * Reads current RSSI of this peripheral, (note : requires active connection to peripheral)
    * @param aCallback Will be called after successfull/failure ble-operation
    */
    func readRSSIValue() {
        
        //
        // MoUtils.MoBLELog("CBPeripheral : [Request] Reading RSSI value from (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Read value from connected Peripheral
        if mIsConnected {
            mPeripheral.readRSSI()
        }
        else { // Process as error if disconnected
            
            deviceDelegate?.didRSSIUpdated(self, RSSI: nil, error: connectionErrorWithCode(errorCode: kConnectionMissingErrorCode, errorMessage: kConnectionMissingErrorMessage))
        }
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : Handler Method
    /*----------------------------------------------------*/
    
    // ----- Used for input events -----/
    func handleConnection(error : NSError!) {
        
        // Connection was made, canceling watchdog
        if let timer = mWatchDogTimer {
            
            timer.invalidate()
            mWatchDogTimer = nil
        }
        // NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("connectionWatchDogFired"), object: nil)
        
        // User dictionary for error notification
        var errorDict : [NSObject : AnyObject]?
        
        // BLE log if enabled
        if error != nil {
            MoUtils.MoBLELog("CBPeripheral : [Delegate] Connection to (%@) with error - %@", args: mPeripheral.identifier.UUIDString, error)
            
            errorDict = ["error" : error]
        }
        else {
            MoUtils.MoBLELog("CBPeripheral : [Delegate] Connection to (%@) success", args: mPeripheral.identifier.UUIDString)
            
            // Connection Flag
            mIsConnected = true
        }
        
        // Call connection delegate
        deviceDelegate?.deviceConnected(self)
        
        // Post notification
        NSNotificationCenter.defaultCenter().postNotificationName(kMoPeripheralDidConnect, object: self, userInfo: errorDict)
    }
    
    func handleDisconnectWithError(error : NSError!) {
        
        // User dictionary for error notification
        var errorDict : [NSObject : AnyObject]?
        
        // BLE log, if enabled
        if error != nil {
            MoUtils.MoBLELog("CBPeripheral : [Delegate] Disconnected from (%@) with error - %@", args: mPeripheral.identifier.UUIDString, error)
            
            errorDict = ["error" : error]
        }
        else {
            MoUtils.MoBLELog("CBPeripheral : [Delegate] Disconnected from (%@) success", args: mPeripheral.identifier.UUIDString)
            
            // Connection Flag
            mIsConnected = false
        }
        
        // Call disconnection callback
        deviceDelegate?.deviceDisconnected(self)
        
        // Post notification
        NSNotificationCenter.defaultCenter().postNotificationName(kMoPeripheralDidDisconnect, object: self, userInfo: errorDict)
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : Private Function
    /*----------------------------------------------------*/
    
    // Connection watchDog firing
    private func connectionWatchDogFired() {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Internal] Connection watchdog (%@) due to timeout", args: mPeripheral.identifier.UUIDString)
        
        // Set watchDog flag
        mWatchDogRaised = true
        
        // Weak reference of SELF
        weak var weakSelf = self
        
        // If BLE connection no performed until watch dog raised, disconnect it
        disconnect()
    }
    
    // Update service and Wrapper - MoService wrapper
    private func updateServiceWrappers() {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Internal] Wrapping service with (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Update serivce array
        var updatedService : [MoService] = [MoService]()
        
        // Iterate scanned service and create service wrapper
        for service in mPeripheral.services {
            updatedService.append(MoService(service: service as! CBService))
        }
        
        mDiscoveredServices = updatedService
    }
    
    // Returns CBService wrapper - MoService
    private func wrapperByService( service aService : CBService!) -> MoService? {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Internal] Wrapping one service on (%@)", args: mPeripheral.identifier.UUIDString)
        
        // Will return value
        var wrapper : MoService?
        
        // Iterate scanned service
        if let discoveredSerivces = mDiscoveredServices {
            
            for moService in discoveredSerivces {
                
                if moService.mService == aService {
                    wrapper = moService
                    break
                }
            }
        }
        
        return wrapper
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : Error Generator
    /*----------------------------------------------------*/
    
    // Generate NSError object from erroCode
    private func connectionErrorWithCode(errorCode aCode : Int, errorMessage  aMsg : String) -> NSError {
        
        return NSError(domain: kMoPeripheralConnectionErrorDomain, code: aCode, userInfo: [kMoBLEErrorMessageKey : aMsg])
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : CBPeripheral Delegate
    /*----------------------------------------------------*/
    
    // Discovered Services
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] Discovered services from peripheral(%@)", args:  mPeripheral.identifier.UUIDString)
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Discovering flag = false
            self.mIsDiscoveringSerivces = false
            
            // Create MoService wrapper
            self.updateServiceWrappers()
            
            // BLE log if enabled
            for aService in self.mDiscoveredServices! {
                MoUtils.MoBLELog("Service discovered - %@", args: aService.mService.UUID)
            }
            
            // Call discover delegate
            self.deviceDelegate?.didDiscoveredServices(self.mDiscoveredServices!, error: error)
        }
    }
    
    // Discovered Characteristics for a Service
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] Discovered chracteristics from service(%@) of peripheral(%@)", args: service.UUID, mPeripheral.identifier.UUIDString)
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Create MoService wrapper and Pass block to MoService
            if let wrapper = self.wrapperByService(service: service) {
                wrapper.handleDiscoveredCharacteristics(characteristic: service.characteristics, error: error)
            }
        }
    }
    
    // Updated value for a characteristic
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] Chracteristics(%@) VALUE updated from peripheral(%@)", args: characteristic.UUID, mPeripheral.identifier.UUIDString)
        
        // Read updated value from characteristic
        var value: NSData! = characteristic.value.copy() as! NSData
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Read characteristic value by MoCharacteristic Wrapper
            // First find out MoService wrapper
            if let aService = self.wrapperByService(service: characteristic.service) {
                
                // Second find out MoCharacteristic wrapper
                if let aChar = aService.wrapperByCharacteristic(characteristic) {
                    
                    aChar.handleReadValue(self, service: aService, data: value, error: error)
                }
            }
        }
    }
    
    // Updated Notification state for a characteristic
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] Chracteristics(%@) NOTIFICATION UPDATED from peripheral(%@)", args: characteristic.UUID, mPeripheral.identifier.UUIDString)
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // First find out MoService wrapper
            if let aService = self.wrapperByService(service: characteristic.service) {
                
                // Second find out MoCharacteristic wrapper
                if let aChar = aService.wrapperByCharacteristic(characteristic) {
                    
                    aChar.handleSetNotified(self, service: aService, error: error)
                }
            }
        }
    }
    
    // Writed a data to characteristic
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] Chracteristics(%@) VALUE WRITTEN from peripheral(%@)", args: characteristic.UUID, mPeripheral.identifier.UUIDString)
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // First find out MoService wrapper
            if let aService = self.wrapperByService(service: characteristic.service) {
                
                // Second find out MoCharacteristic wrapper
                if let aChar = aService.wrapperByCharacteristic(characteristic) {
                    
                    aChar.handWrittenValue(self, service: aService, error: error)
                }
            }
        }
    }
    
    // Updated RSSI
    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBPeripheral : [Delegate] RSSI updated peripheral(%@)", args: mPeripheral.identifier.UUIDString)
        
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Pass value to delegate
            self.deviceDelegate?.didRSSIUpdated(self, RSSI: peripheral.RSSI, error: error)
        }
    }
    
    // Get Connection State as String
    func getPeripheralState() -> String {
        
        if mIsConnected == true {
            return "Connected"
        }
        
        return "Disconnected"
    }

}
