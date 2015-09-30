//
//  BankDeviceStatusVC.m
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "BankDeviceStatusVC.h"
#import "MPDeviceDelegate.h"

@interface BankDeviceStatusVC (Private)<MPDeviceDelegate>

@end

@implementation BankDeviceStatusVC
@synthesize connectedDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Register Delegate
    if( connectedDevice ) {
        connectedDevice.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ---
#pragma mark --- MPDeviceDelegate
-(void)device:(MPDevice *)device didDischargeUSB1Read:(NSNumber *)voltage current:(NSNumber *)current {
    
    _lblDischarge_Usb1.text = [NSString stringWithFormat:@"%.3f V, %.3f A", voltage.floatValue / 1000.f, current.floatValue / 1000.f];
}

-(void)device:(MPDevice *)device didDischargeUSB2Read:(NSNumber *)voltage current:(NSNumber *)current {
    
    _lblDischarge_USB2.text = [NSString stringWithFormat:@"%.3f V, %.3f A", voltage.floatValue / 1000.f, current.floatValue / 1000.f];
}

-(void)device:(MPDevice *)device didBatteryChargeRead:(NSNumber *)voltage current:(NSNumber *)current {
    
    _lblBattery_Discharge.text = [NSString stringWithFormat:@"%3.f V, %3.f A", voltage.floatValue / 1000.f, current.floatValue / 1000.f];
}

-(void)device:(MPDevice *)device didQualityRead:(UInt16)quality {
    
}

#pragma mark ---
#pragma mark --- UIAction
- (IBAction)onReadQuality:(id)sender {
    
    [connectedDevice readDischgUSB1Character];
    [connectedDevice readDischgUSB2Character];
    [connectedDevice readBatChgCharacter];
}
@end
