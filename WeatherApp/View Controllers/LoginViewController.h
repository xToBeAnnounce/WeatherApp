//
//  LoginViewController.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PageViewController.h"

@interface LoginViewController : UIViewController
@property (strong, nonatomic) UINavigationController *mainNavController;
@property (strong, nonatomic) id<NavigationDelegate> navDelegate;
@property (strong, nonatomic) PageViewController *pageVC;

