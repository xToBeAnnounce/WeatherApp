//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <UserNotifications/UserNotifications.h>


@protocol NavigationDelegate
-(void)presentViewController:(NSString*)name;
-(void)pushViewController:(UIViewController*)viewController;
-(void)dismissViewController;
-(void)setLeftBarItem:(UIBarButtonItem *)button WithNVC:(UINavigationController*)navController;
-(SWRevealViewController*)getRevealViewController;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

