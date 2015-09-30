//
//  BankDeviceListVC.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankDeviceListVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (IBAction)onRefreshDevices:(id)sender;
- (IBAction)onSkipDiscover:(id)sender;

@end
