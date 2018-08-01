//
//  NavigationController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "NavigationController.h"
#import "SettingsViewController.h"
#import "LocationPickerViewController.h"
#import "SWRevealViewController.h"
#import "HamburgerViewController.h"
#import "PageViewController.h"
#import "LoginViewController.h"
#import "Parse.h"

@interface NavigationController()
@property (strong, nonatomic) UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) UINavigationController *settingsNVC;
@property (strong, nonatomic) SWRevealViewController *revealVC;
@property (strong,nonatomic) HamburgerViewController *hamburgerVC;
@property (strong, nonatomic) PageViewController *pageVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@end

@implementation NavigationController

-(instancetype)init{
    if (PFUser.currentUser) {
        [self initalizeRevealViewController];
        self.navStack = [[UINavigationController alloc] initWithRootViewController:self.revealVC];
        [self setWeatherNavigationBar:self.navStack];
    }
    else{
        self.loginVC = [[LoginViewController alloc] init];
        self.loginVC.navDelegate = self;
        self.navStack = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    }
    return self;
}

- (void)presentViewController:(NSString*)name{
    if([name isEqualToString:@"pageVC"]){
        [self initalizeRevealViewController];
        UINavigationController *revealNVC = [[UINavigationController alloc] initWithRootViewController:self.revealVC];
        [self setWeatherNavigationBar:revealNVC];
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
    self.hamburgerVC = [[HamburgerViewController alloc]init];
    self.hamburgerVC.navDelegate = self;
    self.pageVC = [[PageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageVC.navDelegate = self;
    
    self.revealVC = [[SWRevealViewController alloc]initWithRearViewController:self.hamburgerVC frontViewController:self.pageVC];
    self.revealVC.rearViewRevealWidth = UIScreen.mainScreen.bounds.size.width - 225;
    self.revealVC.toggleAnimationDuration = 0.5;
}

-(void)setWeatherNavigationBar:(UINavigationController*)currentNavController{
    self.addLocationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-1"] style:UIBarButtonItemStylePlain target:self action:@selector(segueToAddLocation)];
    currentNavController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
}

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    locationVC.delegate = self;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self.navStack presentViewController:locationNavVC animated:YES completion:nil];
}

-(void)setLeftBarItem:(UIBarButtonItem *)button WithNVC:(UINavigationController*)navController{
    navController.navigationBar.topItem.leftBarButtonItem = button;
}

-(SWRevealViewController*)getRevealViewController{
    return self.revealVC;
}

@end

