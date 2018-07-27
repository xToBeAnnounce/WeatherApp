//
//  NavigationController.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PageViewController.h"

@interface NavigationController : NSObject <NavigationDelegate>
@property (strong, nonatomic) UINavigationController *navStack;
@property (strong, nonatomic) PageViewController *pageVC;
-(instancetype)initWithViewController:(UIViewController*)viewController;
@end
