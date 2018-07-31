//
//  LocationWeatherViewController.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "AppDelegate.h"
#import "Activity.h"

@interface LocationWeatherViewController : UIViewController <ActivityDelegate>

@property (strong, nonatomic) UILabel *locLabel;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) id<NavigationDelegate>navDelegate;

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton;
- (BOOL) locationMatches:(Location *)location;
@end
