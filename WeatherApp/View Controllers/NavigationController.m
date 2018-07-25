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

@interface NavigationController()
@property (strong, nonatomic) UIBarButtonItem *settingsButton;
@property (strong, nonatomic) UIBarButtonItem *addLocationButton;
@end

@implementation NavigationController

-(instancetype)initWithViewController:(UIViewController*)viewController{
    self.navStack = [[UINavigationController alloc] initWithRootViewController:viewController];
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

-(void)setPageVCNavigationBar:(UINavigationController*)pageNavController{
    self.settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(segueToSettings)];
    pageNavController.navigationBar.topItem.leftBarButtonItem = self.settingsButton;
    self.addLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(segueToAddLocation)];
    pageNavController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
}

-(void)segueToSettings{
    SettingsViewController *settingsVC = SettingsViewController.new;
    settingsVC.delegate = self;
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:settingsNavigationController Name:@"setting"];
}

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    locationVC.delegate = self;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self presentViewController:locationNavVC Name:@"location"];
}

@end

