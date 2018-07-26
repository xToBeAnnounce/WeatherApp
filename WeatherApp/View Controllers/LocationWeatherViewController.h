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

@property (strong, nonatomic) UILabel *locLabel;
@property (strong, nonatomic) Location *location;

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC;
@end
