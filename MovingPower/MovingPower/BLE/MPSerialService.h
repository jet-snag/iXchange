//
//  MPSerialService.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGService.h"
#import "MPDeviceDelegate.h"

@interface MPSerialService : NSObject {
    
    LGCharacteristic*   data_tansfer;
    
    BOOL                initialized;
}

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate;
- (void) initializeService;

@property (nonatomic, strong) LGService* serialService;
@property (nonatomic, strong) id<MPServiceDelegate> delegate;
@property (readonly) BOOL initialized;

@property (readonly) LGCharacteristic*   data_tansfer;

@end
