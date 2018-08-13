//
//  TodayWeatherView.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface TodayWeatherView : UIView

@property (strong, nonatomic) NSString *tempTypeString;
@property (strong, nonatomic) NSString *customName;
@property (strong, nonatomic) Weather *currentWeather;
@property (strong, nonatomic) Weather *todayWeather;

@end
