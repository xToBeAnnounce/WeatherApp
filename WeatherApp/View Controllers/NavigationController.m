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

- (void) presentRevealViewController {
    UINavigationController *revealNVC = [[UINavigationController alloc] initWithRootViewController:self.revealVC];
    [self.navStack presentViewController:revealNVC animated:YES completion:nil];
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
    
    // Creates page view controller page
    self.hamburgerVC.pageVC = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.hamburgerVC.pageVC.navDelegate = self;
    
    // Creates map view controller
    self.hamburgerVC.mapWVC = WebViewViewController.new;
    
    // Creates settings view controller
    self.hamburgerVC.settingsVC = SettingsViewController.new;
    self.hamburgerVC.settingsVC.settingsDelegate = self.hamburgerVC.pageVC;
    
    // Main reveal controller
    self.revealVC = [[SWRevealViewController alloc]initWithRearViewController:self.hamburgerVC frontViewController:self.hamburgerVC.pageVC];
    self.revealVC.rearViewRevealWidth = UIScreen.mainScreen.bounds.size.width - 225;
    self.revealVC.toggleAnimationDuration = 0.5;
    
    // Hamburger button
    self.revealVC.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self.revealVC action:@selector(revealToggle:)];
}
@end

