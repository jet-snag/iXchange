//
//  iXCentralManager.swift
//  iXchange
//
//  Created by Marko Markov on 24/09/15.
//  Copyright © 2015 Channel Enterprise HK. All rights reserved.
//

import UIKit
import CoreBluetooth

/*----------------------------------------------------*/
// MARK: - SECTION : Callback type definitions for Characteristic
/*----------------------------------------------------*/
typealias iXCentralManagerDiscoverPeripheralCallback = (peripherals : NSMutableArray) -> ()

/*----------------------------------------------------*/
// MARK: - SECTION : Class definition for CentralManager
/*----------------------------------------------------*/
class iXCentralManager: NSObject, CBCentralManagerDelegate {
    
    // CBCentralManager instance
    var mCentralQueue : dispatch_queue_t!
    var mCentralManager : CBCentralManager!
    
    // Scanned Peripherals
    var mScannedPeripherals : NSMutableArray = NSMutableArray()
    
    // Boolean variable indicates currently scanning or not
    var mScanning : Bool = false
    
    // Scan Completion Block
    var mScanBlock : iXCentralManagerDiscoverPeripheralCallback?
    
    // CBCentralManager state
    var mCBCentralMangerState : CBCentralManagerState!
    
    // Stop Scan Stack Instance
    var mStopScanRequestTimer : NSTimer?
    
    /*----------------------------------------------------*/
    // MARK: - Shared Instance
    /*----------------------------------------------------*/
    class var sharedInstance : iXCentralManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : iXCentralManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = iXCentralManager()
        }
        return Static.instance!
    }
    
    /*----------------------------------------------------*/
    // MARK: - Override init
    /*----------------------------------------------------*/
    override init() {
        
        // Super init
        super.init()
        
        // Create queue first
        mCentralQueue = dispatch_queue_create("com.channel.iXCentralManager", DISPATCH_QUEUE_SERIAL)
        // Create central manager with queue
        mCentralManager = CBCentralManager(delegate: self, queue: mCentralQueue)
        // Assign current state
        mCBCentralMangerState = mCentralManager.state
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : Getter/Setter
    /*----------------------------------------------------*/
    
    // Check if central manager is ready
    func isCentraManagerReady() -> Bool {
        
        return mCentralManager.state == .PoweredOn
    }
    
    // Get central manager error code
    func centralManagerNotReadyReason() -> String? {
        
        return stateMessage()
    }
    
    // Get all scanned peripherals
    func scannedPeripherals() -> NSArray {
        
        let sortedPeripherals = mScannedPeripherals.sortedArrayUsingComparator { (peripheral1, peripheral2) -> NSComparisonResult in
            
            let peripheral1 = peripheral1 as! PowerBankDevice
            let peripheral2 = peripheral2 as! PowerBankDevice
            
            if peripheral1.mRSSI == 0 {
                
                return .OrderedAscending
            }
            else if peripheral1.mRSSI < peripheral2.mRSSI {
                
                return .OrderedAscending
            }
            
            return .OrderedDescending
        }
        
        return sortedPeripherals
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : KVO
    /*----------------------------------------------------*/
    class func keyPathsForValuesAffectingCentralReady() -> NSSet {
        
        return NSSet(object: "cbCentralManagerState")
    }
    
    class func keyPathsForValuesAffectingCentralNotReadyReason() -> NSSet {
        
        return NSSet(object: "cbCentralManagerState")
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : Peripheral scan/stop search ( PUBLIC METHOD )
    /*----------------------------------------------------*/
    
    /**
    * Scans for nearby peripherals
    * and fills the - NSArray *peripherals
    */
    func scanForPeripherals() {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request] Scan periphral stareted")
        
        // Forwards call
        scanForPeripherals(services: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    /**
    * Stops ongoing scan proccess
    */
    func stopScanForPeripherals() {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request] Stopping periphral scan")
        
        // Set scanning flag to false
        mScanning = false
        
        // Stop CentralManager Scan
        mCentralManager.stopScan()
        
        // Stop previous scheduled stop request
        if let requestTimer = mStopScanRequestTimer {
            
            requestTimer.invalidate()
            mStopScanRequestTimer = nil
        }
        // NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "stopScanForPeripherals:", object: nil)
        
        // Call ScanBlock if exist
        if let scanBlock = mScanBlock {
            scanBlock(peripherals: mScannedPeripherals)
        }
        
        // Set ScanBlock to nil
        mScanBlock = nil
    }
    
    /**
    * Makes scan for peripherals with criterias,
    * fills - NSArray *peripherals
    * @param serviceUUIDs An array of CBUUID objects that the app is interested in.
    * In this case, each CBUUID object represents the UUID of a service that
    * a peripheral is advertising.
    * @param options An optional dictionary specifying options to customize the scan.
    */
    func scanForPeripherals( services serviceUUIDs : [AnyObject]!, options option : [NSObject : AnyObject]! ) {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request] Scanning periphrals by service UUIDs")
        
        // Copy current searched peripherals
        let mutableCopy : NSMutableArray = mScannedPeripherals.mutableCopy() as! NSMutableArray
        // Remove current scanned peripherals
        mScannedPeripherals.removeAllObjects()
        
        // Don't remove connected peripherals.  They will not appear in a scan
        for peripheral in mutableCopy {
            
            let moPeripheral = peripheral as! MoPeripheral
            switch moPeripheral.mPeripheral.state {
                
            case .Connected:
                mScannedPeripherals.addObject(moPeripheral)
                break
            case .Connecting:
                mScannedPeripherals.addObject(moPeripheral)
                break
            default:
                break
            }
        }
        
        // Scannig Flag True
        mScanning = true
        // CoreBluetooth Manager search
        mCentralManager.scanForPeripheralsWithServices(serviceUUIDs, options: option)
    }
    
    /**
    * Scans for nearby peripherals
    * and fills the - NSArray *peripherals.
    * Scan will be stoped after input interaval.
    * @param aScanInterval interval by which scan will be stoped
    * @param aCallback completion block will be called after
    * <i>aScanInterval</i> with nearby peripherals
    */
    func scanPeripherals( interval aScanInterval : Int, completion completed : MoCentralManagerDiscoverPeripheralCallback) {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request] Scan peripherals by interval")
        
        // Perform scan peripheral
        scanForPeripherals(interval: aScanInterval, sevices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true], completion: completed)
    }
    
    /**
    * Scans for nearby peripherals with criterias,
    * fills the - NSArray *peripherals.
    * Scan will be stoped after input interaval
    * @param aScanInterval interval by which scan will be stoped
    * @param serviceUUIDs An array of CBUUID objects that the app is interested in.
    * In this case, each CBUUID object represents the UUID of a service that
    * a peripheral is advertising.
    * @param options An optional dictionary specifying options to customize the scan.
    * @param aCallback completion block will be called after
    * <i>aScanInterval</i> with nearby peripherals
    */
    func scanForPeripherals( interval aScanInterval : Int, sevices serviceUUIDs : [AnyObject]!, options option : [NSObject : AnyObject]!, completion completed : MoCentralManagerDiscoverPeripheralCallback ) {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request] Scan peripherals by interval & Service UUID")
        
        // Setup complete callback
        mScanBlock = completed
        
        // Scan Peripherals
        scanForPeripherals(services: serviceUUIDs, options: option)
        
        // Cancel previous scheduled stop scan request & make new request
        performStopScan(interval: aScanInterval)
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : PRIVATE METHODS
    /*----------------------------------------------------*/
    
    // Get status message from CentralManger
    private func stateMessage() -> String? {
        
        var statusMessage : String = "Bluetooth is currently Powered On."
        
        switch mCentralManager.state {
        case .Unsupported:
            statusMessage = "The platform/hardware doesn't support Bluetooth Low Energy."
            break;
        case .Unauthorized:
            statusMessage = "The app is not authorized to use Bluetooth Low Energy."
            break;
        case .Unknown:
            statusMessage = "Central not initialized yet."
            break;
        case .PoweredOff:
            statusMessage = "Bluetooth is currently powered off."
            break
        case .PoweredOn:
            break
        default:
            break
        }
        
        return statusMessage
    }
    
    // Create new MoPeripheral instance by WRAPPING
    private func wrapByCBPeripheral(peripheral cbPeripheral : CBPeripheral ) -> MoPeripheral
    {
        //
        MoUtils.MoBLELog("CBCentralManager : [Internal] Wrapping one periphral to MoPeripheral = %@", args : cbPeripheral.identifier.UUIDString)
        
        // Check if current peripherals are already exist is SCANNED peripherals
        var wrapper : MoPeripheral?
        for scannedPeripheral in mScannedPeripherals {
            
            let moPeripheral = scannedPeripheral as! MoPeripheral
            if moPeripheral.mPeripheral == cbPeripheral {
                
                wrapper = moPeripheral
                return wrapper!
            }
        }
        
        wrapper = MoPeripheral(peripheral: cbPeripheral, manager: mCentralManager)
        mScannedPeripherals.addObject(wrapper!)
        
        return wrapper!
    }
    
    // Create MoPeripheral object from CBPeripheral array
    private func wrapByCBPeripherals( peripherals  cbPeripherals : [CBPeripheral] ) -> [MoPeripheral] {
        
        //
        MoUtils.MoLog("CBCentralManager : [Internal] Found a number of periphrals")
        
        // MoPeripheral array
        var moPeripheralArray : [MoPeripheral] = [MoPeripheral]()
        
        // Iterate all CBPeripheral object in array
        for peripheral in cbPeripherals {
            
            moPeripheralArray.append( wrapByCBPeripheral(peripheral: peripheral) )
        }
        
        return moPeripheralArray
    }
    
    // Cancel previous stopScan request and make a new request
    private func performStopScan(interval aScanInterval : Int) {
        
        //
        MoUtils.MoLog("CBCentralManager : [Request][Internal] Stopping scan by internal logic")
        
        // Cancel previous scheduled stop scan request
        if let requestTimer = mStopScanRequestTimer {
            
            requestTimer.invalidate()
            mStopScanRequestTimer = nil
        }
        // NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "stopScanForPeripherals", object: nil)
        
        // Perform stopScanPeripherals after delay
        if aScanInterval == 0 {
            
            // Call stop scan immediately
            stopScanForPeripherals()
        }
        else {
            
            // Schedule stopScan
            // NSObject.performSelector(Selector("stopScanForPeripherals"), withObject: nil, afterDelay: NSTimeInterval(aScanInterval))
            mStopScanRequestTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(aScanInterval), target: self, selector: "stopScanForPeripherals", userInfo: nil, repeats: false)
        }
    }
    
    /*----------------------------------------------------*/
    // MARK: - SECTION : CBCentralManagerDelegate
    /*----------------------------------------------------*/
    
    // Discovered Peripheral
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        //
        MoUtils.MoBLELog("CBCentralManager : [Delegate] Found one periphral = %@", args : peripheral.identifier.UUIDString)
        
        // Run all code on Main Queue
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Create moPeripheral instance
            let moPeripheral = self.wrapByCBPeripheral(peripheral: peripheral)
            
            // Update or Set RSSI
            if RSSI.integerValue != 127 {
                
                if moPeripheral.mRSSI == 0 { // First time for Setup RSSI
                    moPeripheral.mRSSI = RSSI.integerValue
                }
                else { // If it was exist, mean them
                    moPeripheral.mRSSI = ( RSSI.integerValue + moPeripheral.mRSSI ) / 2
                }
            }
            
            // Set advertising data
            moPeripheral.mAdvertisementData = advertisementData
            
            // Stop scanning if scanned device exceeds Integer Max
            if self.mScannedPeripherals.count > NSIntegerMax {
                self.performStopScan(interval: 0)
            }
        }
    }
    
    // Connected to Peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        //
        MoUtils.MoBLELog("CBCentralManager : [Delegate] Connected to (%@) periphral", args : peripheral.identifier.UUIDString)
        
        // Create new moPeripheral instance, handle connection on MoPeripheral
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Create moPeripheral instance
            let moPeripheral = self.wrapByCBPeripheral(peripheral: peripheral)
            
            // handleConnection on MoPeripheral
            moPeripheral.handleConnection(nil)
        }
    }
    
    // Disconnected from Peripheral
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBCentralManager : [Delegate] Disconnected from (%@) periphral", args : peripheral.identifier.UUIDString)
        
        // Find peripheral on array, and handle disconnect on MoPeripherals
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Create moPeripheral instance
            let moPeripheral = self.wrapByCBPeripheral(peripheral: peripheral)
            
            // handleDisconnect on MoPeripheral
            moPeripheral.handleDisconnectWithError(error)
        }
    }
    
    // Failed to Connect to Peripheral
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        //
        MoUtils.MoBLELog("CBCentralManager : [Delegate] Connection failed for (%@) periphral", args : peripheral.identifier.UUIDString)
        
        // Create new moPeripheral instance, handle connection fail on MoPeripheral
        MoUtils.runCodeBlockOnMainQueue { () -> () in
            
            // Create moPeripheral instance
            let moPeripheral = self.wrapByCBPeripheral(peripheral: peripheral)
            
            // handleConnection on MoPeripheral
            moPeripheral.handleConnection(error)
        }
    }
    
    // Did update state
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        //
        MoUtils.MoBLELog("CBCentralManager : [Delegate] Central Manger state updated!")
        
        // Update central manager state
        mCBCentralMangerState = central.state
        
        // Get error message
        if let message = stateMessage() {
            
            MoUtils.runCodeBlockOnMainQueue({ () -> () in
                
                // BLE log if enabled
                MoUtils.MoBLELog("CBCentralManager : [Status] %@", args: message)
            })
        }
    }
}