//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationDelegate
-(void)presentViewController:(UIViewController*)viewController Name:(NSString*)name;
-(void)pushViewController:(UIViewController*)viewController;
-(void)dismissViewController;
-(UINavigationController*)getNavController;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

