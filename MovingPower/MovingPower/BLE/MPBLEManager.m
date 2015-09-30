//
//  MPBLEManager.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPBLEManager.h"

#import "CoreBluetooth/CoreBluetooth.h"
#import "MPUUID.h"

#import "MPDevice.h"

@interface MPBLEManager(Private)<MPDeviceDelegate> {
    
}

@end

@implementation MPBLEManager

@synthesize _devices, delegate;

+(MPBLEManager*) sharedInstance {
    
    static MPBLEManager* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MPBLEManager alloc] init];
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    
    _central = [LGCentralManager sharedInstance];
    _devices = [[NSMutableArray alloc] initWithCapacity:0];
    
    return self;
}

- (void) scanDevices {
    
    [_devices removeAllObjects];
    
    if( _central.isCentralReady ) {
        
        // Adverstising service UUIDs
        CBUUID* uuid = [CBUUID UUIDWithString:ADVERTISE_SERVICE_UUID];
        
        [_central scanForPeripheralsByInterval:10 services:[NSArray arrayWithObjects:uuid, nil] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES} completion:^(NSArray *peripherals) {
            
            for( LGPeripheral* peripheral in peripherals ) {
                
                MPDevice* device = [[MPDevice alloc] initWithPeripheral:peripheral delegate:self];
                [_devices addObject:device];
            }
            
            // call delegate
            [delegate didDiscoverDevices];
        }];
    }
}

@end
