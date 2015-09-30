//
//  BankDeviceStatusVC.h
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDevice.h"

@interface BankDeviceStatusVC : UIViewController

@property (nonatomic, strong) MPDevice* connectedDevice;

@property (weak, nonatomic) IBOutlet UILabel *lblDischarge_Usb1;
@property (weak, nonatomic) IBOutlet UILabel *lblDischarge_USB2;
@property (weak, nonatomic) IBOutlet UILabel *lblBattery_Discharge;
@property (weak, nonatomic) IBOutlet UILabel *lblQuality;

- (IBAction)onReadQuality:(id)sender;

@end
