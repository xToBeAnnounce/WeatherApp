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

@interface NavigationController()
@property (strong, nonatomic) UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) UINavigationController *settingsNVC;
@property (strong,nonatomic) HamburgerViewController *hamburgerVC;
@end

@implementation NavigationController

-(instancetype)initWithViewController:(UIViewController*)viewController{
    self.navStack = [[UINavigationController alloc] initWithRootViewController:viewController];
    if ([viewController.class isEqual:PageViewController.class]) {
      
        self.hamburgerVC = [[HamburgerViewController alloc]init];
        self.revealViewController = [[SWRevealViewController alloc]initWithRearViewController:self.hamburgerVC frontViewController:viewController];
        self.revealViewController.rearViewRevealWidth = UIScreen.mainScreen.bounds.size.width - 225;
        self.revealViewController.toggleAnimationDuration = 0.5;
            
        self.navStack = [[UINavigationController alloc] initWithRootViewController:self.revealViewController];
        //[self.navStack presentViewController:self.revealViewController animated:YES completion:nil];
        //[self setPageVCNavigationBar:viewController.navigationController];
    }
    return self;
}

- (void)presentViewController:(UIViewController *)viewController Name:(NSString*)name{
    if([name isEqualToString:@"pageVC"]){
        UINavigationController *pageNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
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

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
//    locationVC.delegate = self;
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

