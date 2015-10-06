//
//  MPStoryboardManager.m
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import "MPStoryboardManager.h"

@implementation MPStoryboardManager

+ (UIViewController*) getInitialViewController : (NSString*) storyboardName {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateInitialViewController];
}

+ (UIViewController*) getViewControllerWithIdentifider : (NSString*) storyboardName identifier : (NSString*) identifier{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName : storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier : identifier];
}

@end
