//
//  PowerBankDeviceDelegate.swift
//  iXchange
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise HK. All rights reserved.
//

import UIKit

enum PowerBankDeviceState {
    case NotConnected
    case Connecting
    case Connected
    case Disconnected
}

protocol PowerBankDeviceDelegate {
    
    func device(device : PowerBankDevice, didRssiUpdated : NSNumber )
    func device(device : PowerBankDevice, didFailToDiscoverServices : String)
    func device(device : PowerBankDevice, didFailToDiscoverCharacteristic : String)
    
    func didDeviceConnected( device : PowerBankDevice )
    func didDeviceDisconnected ( device : PowerBankDevice )
}
