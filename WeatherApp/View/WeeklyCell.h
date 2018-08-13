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
@property (strong,nonatomic) UILabel *summaryLabel;
@property (strong, nonatomic) UIStackView *activityStack;
@property (strong, nonatomic) UIButton *sunnyActivity;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;
@property (strong,nonatomic) UILabel *humidityLabel;
@property (strong,nonatomic) UILabel *windspeedLabel;
@property (strong,nonatomic) UIView *ExpandedView;
@property (strong,nonatomic) UIButton *activityButton;
/* Weather Information */
@property (strong, nonatomic) Weather *dayWeather;
@property (strong, nonatomic) NSString *tempType; //C or F

@end
