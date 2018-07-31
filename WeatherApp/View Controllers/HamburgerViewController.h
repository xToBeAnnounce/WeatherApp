//
//  HamburgerViewController.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"

@interface HamburgerViewController : UIViewController
@property (strong, nonatomic) id<NavigationDelegate> navDelegate;
@end
