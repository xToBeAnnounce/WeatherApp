//
//  AppDelegate.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "AppDelegate.h"
#import "WeeklyViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "DailyViewController.h"
#import "SettingsViewController.h"
#import "Location.h"

@interface AppDelegate ()
@property UITabBarController *tabBarController;
@property UINavigationController *navController;
@property WeeklyViewController *weeklyVC;
@property DailyViewController *dailyVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self parseBackendSetup];

    self.tabBarController = [[UITabBarController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
    self.weeklyVC = [[WeeklyViewController alloc] init];
    self.dailyVC = [[DailyViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:self.dailyVC, self.weeklyVC, nil];
    self.tabBarController.viewControllers = viewControllers;
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Daily"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Weekly"];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(segueToSettings)];
    self.navController.navigationBar.topItem.rightBarButtonItem = settingsButton;
    return YES;
}

-(void)parseBackendSetup{
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"ttjWeatherApp";
        configuration.clientKey = @"ttjWAMasterKey";
        configuration.server = @"https://ttj-weather-app.herokuapp.com/parse";
        configuration.localDatastoreEnabled = YES;
    }];
    [Parse initializeWithConfiguration:config];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    SettingsViewController *settingsVC = SettingsViewController.new;
//    UINavigationController *navigationController= [[UINavigationController alloc] initWithRootViewController:settingsVC];
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = SettingsViewController.new;
//    [self.window makeKeyAndVisible];
}

-(void)segueToSettings{
    self.navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.navController.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:SettingsViewController.new];
    [self.navController presentViewController:settingsNavigationController animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
