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
#import "LoginViewController.h"

@interface AppDelegate ()
@property UITabBarController *tabBarController;
@property UINavigationController *navController;
@property LoginViewController *LoginVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.LoginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = self.LoginVC;
    
//self.window.rootViewController = LocationPickerViewController.new;
    [self parseBackendSetup];
    [self.window makeKeyAndVisible];
    
    if (PFUser.currentUser) {
        self.window.rootViewController = self.LoginVC.navController;
    }
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
