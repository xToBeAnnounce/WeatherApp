//
//  NavigationController.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@protocol NavigationDelegate
-(void)presentViewController:(NSString*)name;
-(void)pushViewController:(UIViewController*)viewController;
-(void)dismissViewController;
-(void)setLeftBarItem:(UIBarButtonItem *)button WithNVC:(UINavigationController*)navController;
-(SWRevealViewController*)getRevealViewController;
@end

@interface NavigationController : NSObject <NavigationDelegate>
@property (strong, nonatomic) UINavigationController *navStack;
@end
