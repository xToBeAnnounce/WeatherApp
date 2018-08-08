//
//  TodayWeatherCell.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface TodayWeatherCell : UITableViewCell

@property (strong, nonatomic) NSString *tempTypeString;
@property (strong, nonatomic) Weather *currentWeather;
@property (strong, nonatomic) Weather *todayWeather;

@end
