//
//  MPBatteryService.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "MPBatteryService.h"
#import "LGCharacteristic.h"
#import "MPUUID.h"

@implementation MPBatteryService

@synthesize batteryService, delegate, initialized;
@synthesize battery_level;

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate {
    
    self = [super init];
    
    initialized = NO;
    
    batteryService = service;
    delegate = _delegate;
    
    return self;
}

- (void) initializeService {
    
    [batteryService discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
        
        if( error == nil ) {
            
            for( LGCharacteristic* character in characteristics ) {
                
                if ( [character.cbCharacteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_LEVEL]] == YES ) {
                    
                    battery_level = character;
                }
            }
            
            if( battery_level != nil ) {
                
                initialized = YES;
            }
            
            [delegate didDiscovereCharacteristic];
        }
    }];
    
}

@end
