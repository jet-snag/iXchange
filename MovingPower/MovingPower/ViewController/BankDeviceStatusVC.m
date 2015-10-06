//
//  BankDeviceStatusVC.m
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "BankDeviceStatusVC.h"
#import "MPDeviceDelegate.h"
#import "MPUtils.h"

#define MAINVIEW_OFFSET         177

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
    
    //
    bMainViewHidden = NO;
    
    chargedPercent = 0.56;
    
    _chargingChart.chargedPercentage = chargedPercent;
    _lblChargedPercent.text = [NSString stringWithFormat:@"%ld", (long)(chargedPercent * 100)];
    
    _lblDeviceType.text = [MPUtils GetDeviceType];
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
    
    
}

-(void)device:(MPDevice *)device didDischargeUSB2Read:(NSNumber *)voltage current:(NSNumber *)current {
    
    
}

-(void)device:(MPDevice *)device didBatteryChargeRead:(NSNumber *)voltage current:(NSNumber *)current {
    
    
}

-(void)device:(MPDevice *)device didQualityRead:(UInt16)quality {
    
}

#pragma mark ---
#pragma mark --- UIAction

- (IBAction)onSettingMenu:(id)sender {
    
}

- (IBAction)onDeviceSelectionChanged:(id)sender {
    
}

- (IBAction)onToggleMainView:(id)sender {
    
    bMainViewHidden = !bMainViewHidden;
    
    // Update constraint and button
    UIImage* image = nil;
    
    if( bMainViewHidden == YES ) {
        _vMainConstraint.constant = [[UIScreen mainScreen] bounds].size.height;
        image = [UIImage imageNamed:@"Expand"];
    }
    else {
        _vMainConstraint.constant = MAINVIEW_OFFSET;
        image = [UIImage imageNamed:@"Collapse"];
    }
    
    [_btnExpand setImage:image forState:UIControlStateNormal];
    
    // Animation func
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
