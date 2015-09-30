//
//  MPSerialService.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPSerialService.h"

#import "LGCharacteristic.h"
#import "MPUUID.h"

@implementation MPSerialService

@synthesize serialService, delegate, initialized;
@synthesize data_tansfer;

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate {
    
    self = [super init];
    
    initialized = NO;
    
    serialService = service;
    delegate = _delegate;
    
    return self;
}

- (void) initializeService {
    
    [serialService discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
        
        if( error == nil ) {
            
            for( LGCharacteristic* character in characteristics ) {
                
                if( [character.UUIDString isEqualToString:SERIAL_DATA_TRANSFER_UUID] == YES ) {
                    
                    data_tansfer = character;
                }
            }
            
            if( data_tansfer != nil ) {
                
                initialized = YES;
            }
            
            [delegate didDiscovereCharacteristic];
        }
    }];

}

@end
