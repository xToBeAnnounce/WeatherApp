//
//  NavigationController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "NavigationController.h"
#import "User.h"
#import "HamburgerViewController.h"
#import "WebViewViewController.h"
#import "SettingsViewController.h"
#import "PageViewController.h"
#import "LoginViewController.h"


@interface NavigationController()

@property (strong, nonatomic) SWRevealViewController *revealVC;
@property (strong,nonatomic) HamburgerViewController *hamburgerVC;
@property (strong, nonatomic) UIViewController *rootVC;

@end

@implementation NavigationController

-(instancetype)init{
    [self initalizeRevealViewController];
    if (User.currentUser) {
        self.rootVC = self.revealVC;
    }
    else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.navDelegate = self;
        self.rootVC = loginVC;
    }
    self.navStack = [[UINavigationController alloc] initWithRootViewController: self.rootVC];
    return self;
}

- (void)presentViewController:(NSString*)name{
    if([name isEqualToString:@"pageVC"]){
        UINavigationController *revealNVC = [[UINavigationController alloc] initWithRootViewController:self.revealVC];
        [self.navStack presentViewController:revealNVC animated:YES completion:nil];
    }
}

- (void)pushViewController:(UIViewController *)viewController{
    [self.navStack pushViewController:viewController animated:YES];
}

-(void)dismissViewController{
    [self.navStack popViewControllerAnimated:YES];
    [self.navStack dismissViewControllerAnimated:YES completion:nil];
}

-(void)initalizeRevealViewController{
    self.hamburgerVC = [[HamburgerViewController alloc] init];
    self.hamburgerVC.navDelegate = self;
    
    self.hamburgerVC.pageVC = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.hamburgerVC.pageVC.navDelegate = self;
    self.hamburgerVC.mapWVC = WebViewViewController.new;
    self.hamburgerVC.settingsVC = SettingsViewController.new;
    
    self.revealVC = [[SWRevealViewController alloc]initWithRearViewController:self.hamburgerVC frontViewController:self.hamburgerVC.pageVC];
    self.revealVC.rearViewRevealWidth = UIScreen.mainScreen.bounds.size.width - 225;
    self.revealVC.toggleAnimationDuration = 0.5;
}

-(void)setLeftBarItem:(UIBarButtonItem *)button WithNVC:(UINavigationController*)navController{
    navController.navigationBar.topItem.leftBarButtonItem = button;
}

-(SWRevealViewController*)getRevealViewController{
    return self.revealVC;
}
@end

