//
//  MPBatteryService.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGService.h"
#import "MPDeviceDelegate.h"

@interface MPBatteryService : NSObject {

    LGCharacteristic*   battery_level;
    BOOL                initialized;
}

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate;
- (void) initializeService;

@property (nonatomic, strong) LGService* batteryService;
@property (nonatomic, strong) id<MPServiceDelegate> delegate;
@property (readonly) BOOL initialized;

@property (readonly) LGCharacteristic*   battery_level;

@end
