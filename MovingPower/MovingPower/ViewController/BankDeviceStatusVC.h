//
//  BankDeviceStatusVC.h
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeChart.h"
#import "MPDevice.h"

@interface BankDeviceStatusVC : UIViewController {
    
    BOOL        bMainViewHidden;
    CGFloat     chargedPercent;
}

@property (nonatomic, strong) MPDevice* connectedDevice;

// IBOutlet
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vMainConstraint;
@property (weak, nonatomic) IBOutlet UIView *vMain;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;

@property (weak, nonatomic) IBOutlet ChargeChart *chargingChart;

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceType;

@property (weak, nonatomic) IBOutlet UILabel *lblChargedPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblVoltageStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblChargeDescription;

@property (weak, nonatomic) IBOutlet UISegmentedControl *swDevice;

// IBAction
- (IBAction)onSettingMenu:(id)sender;
- (IBAction)onDeviceSelectionChanged:(id)sender;
- (IBAction)onToggleMainView:(id)sender;


@end
