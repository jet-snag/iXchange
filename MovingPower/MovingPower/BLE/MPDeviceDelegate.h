//
//  MPDeviceDelegate.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#ifndef MPDeviceDelegate_h
#define MPDeviceDelegate_h

@class MPDevice;

@protocol MPBLEManagerDelegate <NSObject>

-(void)didDiscoverDevices;

@end

@protocol MPDeviceDelegate <NSObject>

@required
-(void) deviceDidConnect:(MPDevice*) device;
-(void) deviceDidDisconnect:(MPDevice*) device;

@optional
// Battery Control Service
-(void) device:(MPDevice*)device didDischargeUSB1Read : (NSNumber*) voltage current : (NSNumber*) current;
-(void) device:(MPDevice*)device didDischargeUSB2Read : (NSNumber*) voltage current : (NSNumber*) current;
-(void) device:(MPDevice*)device didBatteryChargeRead : (NSNumber*) voltage current : (NSNumber*) current;
-(void) device:(MPDevice*)device didQualityRead : (UInt16) quality;

@end

@protocol MPServiceDelegate <NSObject>

@required
-(void) didDiscovereCharacteristic;

-(void) service:(id)service character : (id)character didRead : (NSData*) data error : (NSError*) error;

@end

#endif /* MPDeviceDelegate_h */
