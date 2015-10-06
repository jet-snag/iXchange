//
//  MPUtils.m
//  MovingPower
//
//  Created by Marko Markov on 05/10/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPUtils.h"
#import <GBDeviceInfo/GBDeviceInfo.h>

@implementation MPUtils

+ (NSString*) GetDeviceType {
    
    GBDeviceInfo* info = [GBDeviceInfo deviceInfo];
    NSString* deviceDesc = nil;
    
    switch (info.model) {
        case GBDeviceModeliPhone4:
            deviceDesc = @"iPhone4";
            break;
        case GBDeviceModeliPhone4S:
            deviceDesc = @"iPhone 4s";
            break;
        case GBDeviceModeliPhone5:
            deviceDesc = @"iPhone 5";
            break;
        case GBDeviceModeliPhone5S:
            deviceDesc = @"iPhone 5";
            break;
        case GBDeviceModeliPhone6:
            deviceDesc = @"iPhone 5";
            break;
        case GBDeviceModeliPhone6S:
            deviceDesc = @"iPhone 5";
            break;
        case GBDeviceModeliPhone6SPlus:
            deviceDesc = @"iPhone 5";
            break;
        default:
            deviceDesc = @"Unknown Device";
            break;
    }
    
    return deviceDesc;
}

@end
