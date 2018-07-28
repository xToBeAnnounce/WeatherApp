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

@interface NavigationController()
@property (strong, nonatomic) UIBarButtonItem *settingsButton;
@property (strong, nonatomic) UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) UISegmentedControl *DailyWeeklySegmentedControl;
@property (strong, nonatomic) UINavigationController *settingsNVC;
@property (strong, nonatomic) SWRevealViewController *revealViewController;
@end

@implementation NavigationController

-(instancetype)initWithViewController:(UIViewController*)viewController{
    self.navStack = [[UINavigationController alloc] initWithRootViewController:viewController];
    if ([viewController.class isEqual:PageViewController.class]) {
        UINavigationController *pageNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        //UITableViewController *userVC = [[UITableViewController alloc] init];
        //userVC.view.backgroundColor = UIColor.orangeColor;
        SettingsViewController *settingsVC = SettingsViewController.new;
        settingsVC.delegate = self;
        self.settingsNVC = [[UINavigationController alloc] initWithRootViewController:settingsVC];

        self.revealViewController = [[SWRevealViewController alloc]initWithRearViewController:self.settingsNVC frontViewController:pageNavController];
        self.revealViewController.rearViewRevealWidth = UIScreen.mainScreen.bounds.size.width;
        self.revealViewController.toggleAnimationDuration = 0.5;
        
        self.navStack = [[UINavigationController alloc] initWithRootViewController:self.revealViewController];
        [self setPageVCNavigationBar:self.navStack];
        //[self.navStack presentViewController:self.revealViewController animated:YES completion:nil];
        //[self setPageVCNavigationBar:viewController.navigationController];
    }
    return self;
}

- (void)presentViewController:(UIViewController *)viewController Name:(NSString*)name{
    if([name isEqualToString:@"pageVC"]){
        UINavigationController *pageNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self setPageVCNavigationBar:pageNavController];
        [self.navStack presentViewController:pageNavController animated:YES completion:nil];
        self.navStack = pageNavController;
    }
    else{
        [self.navStack presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)pushViewController:(UIViewController *)viewController{
    [self.navStack pushViewController:viewController animated:YES];
}

-(void)dismissViewController{
    [self.navStack popViewControllerAnimated:YES];
    [self.navStack dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPageVCNavigationBar:(UINavigationController*)currentNavController{
    self.addLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueToAddLocation)];
    self.addLocationButton.image = [UIImage imageNamed:@"plus-1"];
    self.addLocationButton.tintColor = UIColor.whiteColor;
    currentNavController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
    
    self.DailyWeeklySegmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Daily",@"Weekly"]];
    self.DailyWeeklySegmentedControl.selectedSegmentIndex = 0;
    self.DailyWeeklySegmentedControl.tintColor = UIColor.blackColor;
    currentNavController.navigationBar.topItem.titleView = self.DailyWeeklySegmentedControl;
}

-(UISegmentedControl*)getDailyWeeklySegmentControl{
    return self.DailyWeeklySegmentedControl;
}

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    locationVC.delegate = self;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self presentViewController:locationNavVC Name:@"location"];
}

-(void)setLeftBarItem:(UIBarButtonItem *)button{
    self.navStack.navigationBar.topItem.leftBarButtonItem = button;
}

-(SWRevealViewController*)getRevealViewController{
    return self.revealViewController;
}

@end

