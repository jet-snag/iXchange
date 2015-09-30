//
//  MPOTAService.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGService.h"
#import "MPDeviceDelegate.h"

@interface MPOTAService : NSObject {
    
    LGCharacteristic*   current_app;
    LGCharacteristic*   read_cs_block;
    LGCharacteristic*   data_transfer;
    LGCharacteristic*   version;
    
    BOOL                initialized;
}

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate;
- (void) initializeService;

@property (nonatomic, strong) LGService* otaService;
@property (nonatomic, strong) id<MPServiceDelegate> delegate;
@property (readonly) BOOL initialized;

@property (readonly) LGCharacteristic*   current_app;
@property (readonly) LGCharacteristic*   read_cs_block;
@property (readonly) LGCharacteristic*   data_transfer;
@property (readonly) LGCharacteristic*   version;

@end
