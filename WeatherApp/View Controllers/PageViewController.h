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

@interface PageViewController : UIPageViewController

@property (strong, nonatomic) id<NavigationDelegate> navDelegate;

@end
