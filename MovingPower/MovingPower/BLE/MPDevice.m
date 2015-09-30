//
//  MPDevice.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "MPDevice.h"
#import "MPUUID.h"
#import "LGService.h"
#import "LGCharacteristic.h"

@interface MPDevice(PrivateMethod)<MPServiceDelegate> {
    
}

@end

@implementation MPDevice
@synthesize peripheral, delegate, deviceName;

-(id) initWithPeripheral : (LGPeripheral*) _peripheral delegate : (id<MPDeviceDelegate>) _delegate {
    
    self = [super init];
    
    peripheral = _peripheral;
    delegate = _delegate;
    
    initialized = NO;
    
    return self;
}

-(void) initializeDevice {
    
    if( peripheral.cbPeripheral.state == CBPeripheralStateConnected || peripheral.cbPeripheral.state == CBPeripheralStateConnecting ) {
        return;
    }
    
    // Connect to Device
    [peripheral connectWithCompletion:^(NSError *error) {
        
        if( error != nil ) {
            
            return;
        }
        
        NSLog(@"Connected to device = %@", peripheral.name);
        NSLog(@"Discovering services");
        
        // Discover services
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            
            if ( error == nil ) { // Discover one or more services
                
                // Assign discovered services
                for( LGService* service in services ) {
                    
                    if( [service.UUIDString isEqualToString:BATTERY_CONTROL_SERVICE_UUID] == YES ) {
                        
                        NSLog(@"Battery Control Service Found");
                        
                        batteryControlService = [[MPControlService alloc] initWithService:service delegate:self];
                        
                        // Discover characteristic
                        [batteryControlService initializeService];
                    }
                    else if ( [service.UUIDString isEqualToString:SERIAL_SERVICE_UUID] == YES ) {
                        
                        NSLog(@"Serial Service Found");
                        
                        serialService = [[MPSerialService alloc] initWithService:service delegate:self];
                        
                        // Discover characteristic
                        [serialService initializeService];
                    }
                    else if( [service.UUIDString isEqualToString:CSR_OTA_UPDATE_SERVICE_UUID] == YES ) {
                       
                        NSLog(@"OTA update service found");
                        
                        otaService = [[MPOTAService alloc] initWithService:service delegate:self];
                        
                        // Discover characteristic
                        [otaService initializeService];
                    }
                    else if( [service.cbService.UUID isEqual:[CBUUID UUIDWithString:BATTERY_SERVICE_UUID]] == YES ) {
                        
                        NSLog(@"Battery service found");
                        
                        batteryService = [[MPBatteryService alloc] initWithService:service delegate:self];
                        
                        // Discover characteristic
                        [batteryService initializeService];
                    }
                }
            }
        }];
    }];
}

- (void) disconnectDevice {
    
    [peripheral disconnectWithCompletion:^(NSError *error) {
        
    }];
}

#pragma mark ---
#pragma makr -- MPServiceDelegate
-(void) didDiscovereCharacteristic {
    
    if( [batteryService initialized] && [otaService initialized] && [serialService initialized] && [batteryControlService initialized] ) {
        
        initialized = YES;
        
        [delegate deviceDidConnect : self];
    }
}

-(void) service:(id)service character:(id)character didRead:(NSData *)data error:(NSError *)error {
    
    // Battery control service
    if( service == batteryControlService ) {
        
        if( character == batteryControlService.discharge_usb1 ) {
            
            //
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //
            // Separate with Voltage and current
            NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
            NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
            //
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            //
            // Convert to NSNumber
            NSNumber* volatage = [formatter numberFromString:voltageStr];
            NSNumber* current = [formatter numberFromString:currentStr];
            
            //
            [delegate device:self didDischargeUSB1Read:volatage current:current];
        }
        else if( character == batteryControlService.discharge_usb2 ) {
            
            //
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //
            // Separate with Voltage and current
            NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
            NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
            //
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            //
            // Convert to NSNumber
            NSNumber* volatage = [formatter numberFromString:voltageStr];
            NSNumber* current = [formatter numberFromString:currentStr];
            
            //
            [delegate device:self didDischargeUSB2Read:volatage current:current];
        }
        else if( character == batteryControlService.battery_charge ) {
            
//            //
//            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            //
//            // Separate with Voltage and current
//            NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
//            NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
//            //
//            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = NSNumberFormatterDecimalStyle;
//            
//            //
//            // Convert to NSNumber
//            NSNumber* volatage = [formatter numberFromString:voltageStr];
//            NSNumber* current = [formatter numberFromString:currentStr];
//            
//            //
//            [delegate device:self didBatteryChargeRead:volatage current:current];
        }
        else if( character == batteryControlService.quality ) {
            
        }
    }
}

#pragma mark ---
#pragma mark --- Getter/Setter
- (NSString*) deviceName {
    
    if ( peripheral != nil ) {
        return peripheral.name;
    }
    
    return @"Unknown device";
}

-(void) readDischgUSB1Character {

    [batteryControlService.discharge_usb1 readValueWithBlock:^(NSData *data, NSError *error) {
        
        //
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //
        // Separate with Voltage and current
        NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
        NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
        //
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        //
        // Convert to NSNumber
        NSNumber* volatage = [formatter numberFromString:voltageStr];
        NSNumber* current = [formatter numberFromString:currentStr];
        
        //
        [delegate device:self didDischargeUSB1Read:volatage current:current];
    }];
}

-(void) readDischgUSB2Character {
    
    [batteryControlService.discharge_usb2 readValueWithBlock:^(NSData *data, NSError *error) {
        
        //
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //
        // Separate with Voltage and current
        NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
        NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
        //
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        //
        // Convert to NSNumber
        NSNumber* volatage = [formatter numberFromString:voltageStr];
        NSNumber* current = [formatter numberFromString:currentStr];
        
        //
        [delegate device:self didDischargeUSB2Read:volatage current:current];
    }];
}

-(void) readBatChgCharacter {
    
    [batteryControlService.battery_charge readValueWithBlock:^(NSData *data, NSError *error) {
        
        //
//        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //
//        // Separate with Voltage and current
//        NSString* voltageStr = [dataString substringWithRange:NSMakeRange(0, 4)];
//        NSString* currentStr = [dataString substringWithRange:NSMakeRange(4, 4)];
//        //
//        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
//        formatter.numberStyle = NSNumberFormatterDecimalStyle;
//        
//        //
//        // Convert to NSNumber
//        NSNumber* volatage = [formatter numberFromString:voltageStr];
//        NSNumber* current = [formatter numberFromString:currentStr];
//        
//        //
//        [delegate device:self didDischargeUSB1Read:volatage current:current];
    }];
}

@end
