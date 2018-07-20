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
#import "LocationPickerViewController.h"

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

    self.tabBarController = [[UITabBarController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
    self.weeklyVC = [[WeeklyViewController alloc] init];
    self.dailyVC = [[DailyViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:self.dailyVC, self.weeklyVC, nil];
    self.tabBarController.viewControllers = viewControllers;
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Daily"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Weekly"];
    self.window.rootViewController = self.navController;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(segueToSettings)];
    self.navController.navigationBar.topItem.rightBarButtonItem = settingsButton;
    
    [self parseBackendSetup];
//    self.window.rootViewController = LocationPickerViewController.new;
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
