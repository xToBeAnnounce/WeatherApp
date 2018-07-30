//
//  LocationWeatherViewController.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationWeatherViewController : UIViewController

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *tempTypeString;

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton;
@end
