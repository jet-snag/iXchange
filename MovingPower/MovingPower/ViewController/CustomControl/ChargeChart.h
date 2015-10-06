//
//  ChargeChart.h
//  MovingPower
//
//  Created by Marko Markov on 04/10/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface ChargeChart : UIView

@property (nonatomic, readwrite)    CGFloat     chargedPercentage;  // 0 ~ 1
@property (nonatomic, strong)       UIColor*    chartViewColor;     // View Color
@property (nonatomic, strong)       UIColor*    chartBackColor;     // BackColor
@property (nonatomic, strong)       UIColor*    chartColor;         // ForeColor

@property (nonatomic, readwrite)    CGFloat     chartBkWidth;
@property (nonatomic, readwrite)    CGFloat     chartFrWidth;

@property (nonatomic, readwrite)    NSUInteger  totalCapacity;      // mAh
@property (nonatomic, readwrite)    NSUInteger  chargedCapacity;    // mAh

- (void) updateDrawing;

@end
