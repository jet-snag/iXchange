//
//  MPDevice.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPeripheral.h"
#import "MPDeviceDelegate.h"

#import "MPControlService.h"
#import "MPOTAService.h"
#import "MPSerialService.h"
#import "MPBatteryService.h"

@interface MPDevice : NSObject {
    
    // Property of Power Bank Device
    NSNumber*   batteryCellCount; // N
    
    NSNumber*   batteryCellVoltageIn; // Va1
    NSNumber*   batteryCellVoltageOut; // Vb1
    
    NSNumber*   batteryCellVoltageConst; // Va2
    
    NSNumber*   deviceCapacityIn; // C0
    NSNumber*   deviceCapacityOut; // C0
    
    NSNumber*   batteryCellCapacityIn; // C00
    NSNumber*   batteryCellCapacityOut; // C00
    
    // BATTERY_CONTORL_BLE_SERVICE
    MPSerialService*    serialService;
    MPControlService*   batteryControlService;
    MPOTAService*       otaService;
    MPBatteryService*   batteryService;
    
    //
    BOOL                initialized;
}

-(id) initWithPeripheral : (LGPeripheral*) _peripheral delegate : (id<MPDeviceDelegate>) _delegate;

-(void) initializeDevice;
-(void) disconnectDevice;

-(void) readDischgUSB1Character;
-(void) readDischgUSB2Character;
-(void) readBatChgCharacter;

@property (nonatomic, strong) LGPeripheral* peripheral;
@property (nonatomic, strong) id<MPDeviceDelegate> delegate;
@property (nonatomic, readonly) NSString* deviceName;

@end
