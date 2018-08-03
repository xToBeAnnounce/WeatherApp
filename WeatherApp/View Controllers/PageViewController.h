//
//  PageViewController.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/20/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import <UserNotifications/UserNotifications.h>
#import "SettingsViewController.h"
#import "User.h"

@interface PageViewController : UIPageViewController <SettingsDelegate>

@property (strong, nonatomic) id<NavigationDelegate> navDelegate;

@end
