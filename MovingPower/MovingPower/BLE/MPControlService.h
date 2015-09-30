//
//  MPControlService.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "LGService.h"
#import "MPDeviceDelegate.h"

@interface MPControlService : NSObject
{
    LGCharacteristic*   discharge_usb1;
    LGCharacteristic*   discharge_usb2;
    LGCharacteristic*   battery_charge;
    LGCharacteristic*   quality;
    
    BOOL                initialized;
}

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate;
- (void) initializeService;

@property (nonatomic, strong) LGService* controlService;
@property (nonatomic, strong) id<MPServiceDelegate> delegate;
@property (readonly) BOOL initialized;

@property (readonly) LGCharacteristic* discharge_usb1;
@property (readonly) LGCharacteristic* discharge_usb2;
@property (readonly) LGCharacteristic* battery_charge;
@property (readonly) LGCharacteristic* quality;

@end
