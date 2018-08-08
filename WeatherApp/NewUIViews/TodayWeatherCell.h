//
//  TodayWeatherCell.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import "TodayWeatherView.h"
@interface TodayWeatherCell : UITableViewCell
@property (strong, nonatomic) TodayWeatherView *weatherView;
=======
#import "Weather.h"

@interface TodayWeatherCell : UITableViewCell

@property (strong, nonatomic) NSString *tempTypeString;
@property (strong, nonatomic) Weather *currentWeather;
@property (strong, nonatomic) Weather *todayWeather;

>>>>>>> 5f4f0fc1d1352127dd9b65484fe75e94b925804c
@end
