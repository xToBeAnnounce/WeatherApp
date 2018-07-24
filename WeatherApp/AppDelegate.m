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
#import "PageViewController.h"

@interface AppDelegate ()
@property PageViewController *pageVC;
@property LoginViewController *loginVC;
@property UINavigationController *mainNavController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.loginVC = [[LoginViewController alloc] init];
    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    self.loginVC.mainNavController = self.mainNavController;
    self.window.rootViewController = self.mainNavController;
    
    [self parseBackendSetup];
    [self.window makeKeyAndVisible];
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
