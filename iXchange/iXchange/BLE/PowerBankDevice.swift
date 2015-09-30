//
//  PowerBankDevice.swift
//  iXchange
//
//  Created by Marko Markov on 24/09/15.
//  Copyright © 2015 Channel Enterprise HK. All rights reserved.
//

import UIKit
import CoreBluetooth

class PowerBankDevice : NSObject, CBPeripheralDelegate {
    
    var peripheral: CBPeripheral!
    var delegate: CBPeripheralDelegate?
    
    var queueForDelegate: NSOperationQueue!
    
    var name: String {
        get {
            if self.peripheral == nil {
                return ""
            }
            return self.peripheral.name!
        }
    }
    var RSSI: Int
    var state: PowerBankDeviceState
    var peripheralUuid: String {
        get {
            return self.peripheral.identifier.UUIDString
        }
    }
    
    init(_peripheral : CBPeripheral) {
        
        RSSI = 0
        state = .NotConnected
        
        super.init()
        
        peripheral = _peripheral
        peripheral.delegate = self
        
        self.queueForDelegate = NSOperationQueue()
        self.queueForDelegate.maxConcurrentOperationCount = 1;
        
        if (peripheral.state == CBPeripheralState.Connected) {
            // self.peripheralConnected()
        }
    }
    
    
}
