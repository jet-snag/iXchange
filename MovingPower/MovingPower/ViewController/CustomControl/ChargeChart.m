//
//  ChargeChart.m
//  MovingPower
//
//  Created by Marko Markov on 04/10/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "ChargeChart.h"
#import "MPDefine.h"

@implementation ChargeChart

@synthesize chargedPercentage, chartViewColor, chartBackColor, chartColor, totalCapacity, chargedCapacity, chartBkWidth, chartFrWidth;

#pragma mark --
-(id) initWithCoder:(NSCoder *)aDecoder {
    
    if( self = [super initWithCoder:aDecoder] ) {
        
        [self initialize];
    }
    
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    
    if ( self = [super initWithFrame:frame] ) {
        
        [self initialize];
    }
    
    return self;
}

-(void) initialize {
    
    self.backgroundColor = [UIColor clearColor];
    
    // Default color of chart
    chartViewColor = [UIColor colorWithRed:37/255.f green:48/255.f blue:57/255.f alpha:1.0];
    
    chartBackColor = [UIColor colorWithRed:165/255.f green:169/255.f blue:172/255.f alpha:1.0];
    
    chartColor = kNormalState_Color;
    
    // Set Geometric components
    chartBkWidth = 2.f;
    chartFrWidth = 5.f;
}

#pragma mark --
#pragma mark -- Setter/Getter
- (void) setChargedPercentage:(CGFloat)_chargedPercentage {
    
    if( chargedPercentage != _chargedPercentage ) {
        
        chargedPercentage = _chargedPercentage;
        [self updateDrawing];
    }
}

- (void) setChartColor:(UIColor *)_chartColor {
    
    if( [chartColor isEqual:_chartColor] == NO ) {
        
        chartColor = _chartColor;
        [self updateDrawing];
    }
}

- (void) setTotalCapacity:(NSUInteger)_totalCapacity {
    
    if( totalCapacity != _totalCapacity ) {
        
        totalCapacity = _totalCapacity;
        [self updateDrawing];
    }
}

- (void) setChargedCapacity:(NSUInteger)_chargedCapacity {
    
    if( chargedCapacity != _chargedCapacity ) {
        
        chargedCapacity = _chargedCapacity;
        [self updateDrawing];
    }
}

- (void) setChartBkWidth:(CGFloat)_chartBkWidth {
    
    if ( chartBkWidth != _chartBkWidth ) {
        
        chartBkWidth = _chartBkWidth;
        [self updateDrawing];
    }
}

- (void) setChartFrWidth:(CGFloat)_chartFrWidth {
    
    if( chartFrWidth != _chartFrWidth ) {
        
        chartFrWidth = _chartFrWidth;
        [self updateDrawing];
    }
}

#pragma mark ---
#pragma mark --- Update drawing force
- (void) updateDrawing {
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Clear???
    CGContextClearRect(context, self.bounds);
    
    // Background Rect
    CGRect innerCircleRect = rect;//CGRectInset(rect, chartBkWidth*3/4, chartBkWidth*3/4);
    CGContextSetFillColorWithColor(context, chartViewColor.CGColor);
    CGContextFillEllipseInRect (context, innerCircleRect);
    
    CGContextFillPath(context);
    
    // Background Process
    CGRect strokeCircleRect = CGRectInset(rect, chartBkWidth, chartBkWidth);
    CGContextSetStrokeColorWithColor(context, chartBackColor.CGColor);
    CGContextSetLineWidth(context, chartBkWidth);
    CGContextStrokeEllipseInRect(context, strokeCircleRect);
    CGContextStrokePath(context);
    
    // Set Percent
    // Set EndCap style
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGFloat angle = (360.0f * chargedPercentage) - 90.0;
    CGContextSetStrokeColorWithColor(context, chartColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, chartFrWidth);
    CGFloat radius = rect.size.width/2 - chartFrWidth/2;
    CGPathAddArc(path, NULL, rect.size.width/2, rect.size.height/2, radius, -90.0 * M_PI / 180, angle * M_PI / 180, 0);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
}

@end
