//
//  WeeklyCell.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
#import "Activity.h"
#import "Location.h"

@interface WeeklyCell : UITableViewCell

/* User Interface Labels */
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *lowTempLabel;
@property (strong, nonatomic) UILabel *highTempLabel;
@property (strong, nonatomic) UIStackView *tempStackView;
@property (strong, nonatomic) UIButton *sunnyActivity;

/* Weather Information */
@property (strong, nonatomic) Weather *dayWeather;
@property (strong, nonatomic) NSString *tempType; //C or F

/* Activity Information */
@property bool displayActivity;
@property (strong, nonatomic) id<ActivityDelegate>delegate;
@property (strong, nonatomic) NSArray *location;
@property int rowNum;
@property int rowHeight;
@end
