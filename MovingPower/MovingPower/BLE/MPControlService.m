//
//  MPControlService.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPControlService.h"

#import "LGCharacteristic.h"
#import "MPUUID.h"

@implementation MPControlService

@synthesize controlService, delegate, initialized;
@synthesize discharge_usb1, discharge_usb2, battery_charge, quality;

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate {
    
    self = [super init];
    
    initialized = NO;
    
    controlService = service;
    delegate = _delegate;
    
    return self;
}

- (void) initializeService {
    
    NSLog(@"Discovering characteristic for Battery Control Service");
    
    [controlService discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
        
        if( error == nil ) {
            
            for( LGCharacteristic* character in characteristics ) {
                
                if( [character.UUIDString isEqualToString:BATTERY_CONTROL_DISCHG_USB1_UUID] == YES ) {
                
                    NSLog(@"DISCHG_USB1 characteristic found");
                    
                    discharge_usb1 = character;
                    
                    // set notify value
                    __weak typeof(self) weakSelf = self;
                    [discharge_usb1 setNotifyValue:YES completion:nil onUpdate:^(NSData *data, NSError *error) {
                        
                        [weakSelf onDischarge_USB1_Notified:data error:error];
                    }];
                }
                else if( [character.UUIDString isEqualToString:BATTERY_CONTROL_DISCHG_USB2_UUID] == YES ) {
                    
                    discharge_usb2 = character;
                    
                    // set notify value
                    __weak typeof(self) weakSelf = self;
                    [discharge_usb2 setNotifyValue:YES completion:nil onUpdate:^(NSData *data, NSError *error) {
                        
                        [weakSelf onDischarge_USB2_Notified:data error:error];
                    }];
                }
                else if( [character.UUIDString isEqualToString:BATTERY_CONTROL_BAT_CHG_UUID] == YES ) {
                    
                    battery_charge = character;
                    
                    // set notify value
                    __weak typeof(self) weakSelf = self;
                    [battery_charge setNotifyValue:YES completion:nil onUpdate:^(NSData *data, NSError *error) {
                        
                        [weakSelf onBattery_Charge_Notified:data error:error];
                    }];
                }
                else if( [character.UUIDString isEqualToString:BATTERY_CONTROL_QUALITY_UUID] == YES ) {
                    
                    quality = character;
                }
            }
            
            if( discharge_usb1 != nil && discharge_usb2 != nil && battery_charge != nil /*&& quality != nil */) {
                
                initialized = YES;
            }
            
            [delegate didDiscovereCharacteristic];
        }
    }];
}

#pragma mark ---
#pragma mark --- Notification callback

- (void) onDischarge_USB1_Notified : (NSData*) data error : (NSError*) error {
 
    if( data.length == 8 ) {
        
//        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        // Separate with Voltage and current
//        NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
//        NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
//        
//        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
//        formatter.numberStyle = NSNumberFormatterDecimalStyle;
//        
//        NSNumber* volatage = [formatter numberFromString:voltageStr];
//        NSNumber* current = [formatter numberFromString:currentStr];
//        
//
    }
    
    [delegate service:self character:discharge_usb1 didRead:data error:error];
}

- (void) onDischarge_USB2_Notified : (NSData*) data error : (NSError*) error {
    
    if( data.length == 8 ) {
        
    }
    
    [delegate service:self character:discharge_usb2 didRead:data error:error];
}

- (void) onBattery_Charge_Notified : (NSData*) data error : (NSError*) error {
    
    if( data.length == 2 ) {
        
    }
    
    [delegate service:self character:battery_charge didRead:data error:error];
}

@end
