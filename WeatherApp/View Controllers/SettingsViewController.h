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
- (void) updatePreferences:(Preferences *)pref;
@end

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) id<NavigationDelegate> navDelegate;
@property (strong, nonatomic) id<SettingsDelegate>settingDelegate;
@property (strong, nonatomic) UITextField *tooHotTextField;
@property (strong, nonatomic) UITextField *tooColdTextField;

- (void) loadPreferences;
@end
