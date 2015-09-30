//
//  BankDeviceListVC.m
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "BankDeviceListVC.h"
#import "MPBLEManager.h"
#import "MPDevice.h"
#import "MPDefine.h"

#import "MPStoryboardManager.h"
#import "BankDeviceStatusVC.h"

@interface BankDeviceListVC ()<MPBLEManagerDelegate, MPDeviceDelegate>

@end

@implementation BankDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupUI];
    [self discoverDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupUI {
    // Customize controls here!
    
    _btnSkip.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _btnSkip.layer.borderWidth = 0.8f;
    
    _btnSkip.layer.cornerRadius = 4.f;
    _btnSkip.layer.masksToBounds = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) discoverDevices {
    
    // UI
    _lblStatus.text = kStr_Discovering;
    [_progressIndicator setHidden:NO];
    [_progressIndicator startAnimating];
    
    // Discover devices
    [[MPBLEManager sharedInstance] scanDevices];
    [MPBLEManager sharedInstance].delegate = self;
}

#pragma mark ---
#pragma mark --- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [MPBLEManager sharedInstance]._devices.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    
    MPDevice* device = [MPBLEManager sharedInstance]._devices[indexPath.row];
    device.delegate = self;
    
    UIFont* font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    NSMutableAttributedString* deviceString = [[NSMutableAttributedString alloc] initWithString:device.deviceName];
    NSRange range = NSMakeRange(0, device.deviceName.length);
    
    [deviceString addAttribute:NSFontAttributeName value:font range:range];
    [deviceString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setAttributedText:deviceString];
    
    return cell;
}

#pragma mark -- 
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPDevice* device = [MPBLEManager sharedInstance]._devices[indexPath.row];
    [device initializeDevice];
}

#pragma mark ---
#pragma mark --- MPDeviceDelegate
-(void) deviceDidConnect:(MPDevice *)device {
    
    // Perform segue to DeviceStatusVC
    BankDeviceStatusVC* statusVC = (BankDeviceStatusVC*) [MPStoryboardManager getViewControllerWithIdentifider:@"Main" identifier:@"DeviceStatus"];
    statusVC.connectedDevice = device;
    [self.navigationController pushViewController:statusVC animated:YES];
}

-(void) deviceDidDisconnect:(MPDevice *)device {
    
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection failed, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [errorView show];
}

-(void)device:(MPDevice *)device didDischargeUSB1Read:(NSNumber *)voltage current:(NSNumber *)current {
    
    NSLog(@"===USB1 Read===");
    // _lblDischarge_Usb1.text = [NSString stringWithFormat:@"%3.f V, %3.f A", voltage.floatValue, current.floatValue];
}

-(void)device:(MPDevice *)device didDischargeUSB2Read:(NSNumber *)voltage current:(NSNumber *)current {
    
    NSLog(@"===USB2 Read===");
    // _lblDischarge_USB2.text = [NSString stringWithFormat:@"%3.f V, %3.f A", voltage.floatValue, current.floatValue];
}

-(void)device:(MPDevice *)device didBatteryChargeRead:(NSNumber *)voltage current:(NSNumber *)current {
    
    NSLog(@"===Battery Charge===");
    // _lblBattery_Discharge.text = [NSString stringWithFormat:@"%3.f V, %3.f A", voltage.floatValue, current.floatValue];
}

-(void)device:(MPDevice *)device didQualityRead:(UInt16)quality {
    
}

#pragma mark ---
#pragma mark --- MPBLEManagerDelegate
-(void) didDiscoverDevices {
    
    // Reload table according to BLEManager
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_progressIndicator stopAnimating];
        _lblStatus.text = kStr_Available;
        
        [self.tblDevices reloadData];
    });
}

- (IBAction)onRefreshDevices:(id)sender {
    
    [self discoverDevices];
}

- (IBAction)onSkipDiscover:(id)sender {
    
}
@end
