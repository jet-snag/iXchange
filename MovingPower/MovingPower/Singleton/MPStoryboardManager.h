//
//  MPStoryboardManager.h
//  MovingPower
//
//  Created by Marko Markov on 30/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPStoryboardManager : NSObject

+ (UIViewController*) getInitialViewController : (NSString*) storyboardName;
+ (UIViewController*) getViewControllerWithIdentifider : (NSString*) storyboardName identifier : (NSString*) identifier;

@end
