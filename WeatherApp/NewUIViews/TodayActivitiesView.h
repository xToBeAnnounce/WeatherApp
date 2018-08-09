//
//  TodayActivitiesView.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Weather.h"
#import "Activity.h"

@interface TodayActivitiesView : UIView

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Weather *currentWeather;
@property (strong, nonatomic) id<ActivityDelegate> activityDelegate;

@end
