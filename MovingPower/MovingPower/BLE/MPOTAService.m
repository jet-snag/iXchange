//
//  MPOTAService.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPOTAService.h"

#import "LGCharacteristic.h"
#import "MPUUID.h"

@implementation MPOTAService

@synthesize otaService, delegate, initialized;
@synthesize current_app, read_cs_block, data_transfer, version;

- (id) initWithService : (LGService*) service delegate : (id<MPServiceDelegate>) _delegate {
 
    self = [super init];
    
    initialized = NO;
    
    otaService = service;
    delegate = _delegate;
    
    return self;
}

- (void) initializeService {
    
    [otaService discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
        
        if( error == nil ) {
            
            for( LGCharacteristic* character in characteristics ) {
                
                if( [character.UUIDString isEqualToString:CSR_OTA_CURRENT_APP_UUID] == YES ) {
                    
                    current_app = character;
                }
                else if( [character.UUIDString isEqualToString:CSR_OTA_READ_CS_BLOCK_UUID] == YES ) {
                    
                    read_cs_block = character;
                }
                else if( [character.UUIDString isEqualToString:CSR_OTA_DATA_TRANSFER_UUID] == YES ) {
                    
                    data_transfer = character;
                }
                else if( [character.UUIDString isEqualToString:CSR_OTA_VERSION_UUID] == YES ) {
                    
                    version = character;
                }
            }
            
            if( current_app != nil && read_cs_block != nil && data_transfer != nil && version != nil ) {
                
                initialized = YES;
            }
            
            [delegate didDiscovereCharacteristic];
        }
    }];

}

@end
