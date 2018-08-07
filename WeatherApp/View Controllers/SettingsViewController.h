//
//  SettingsViewController.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "Preferences.h"

@protocol SettingsDelegate
-(void) setPreferences:(Preferences *)pref;
-(void) updatePreferences:(Preferences *)pref;
@end

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) id<NavigationDelegate> navigationDelegate;
@property (strong, nonatomic) id<SettingsDelegate> settingsDelegate;
@end
