//
//  MPBLEManager.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "LGCentralManager.h"
#import "MPDeviceDelegate.h"

@interface MPBLEManager : NSObject
{
    LGCentralManager*   _central;
    NSMutableArray*     _devices;
}

+ (MPBLEManager*) sharedInstance;

- (void) scanDevices;

@property( nonatomic, readonly ) NSMutableArray* _devices;
@property( nonatomic, strong ) id<MPBLEManagerDelegate> delegate;

@end
