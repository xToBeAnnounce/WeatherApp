//
//  WeeklyCell.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeeklyCell : UITableViewCell

/* User Interface Labels */
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *lowTempLabel;
@property (strong, nonatomic) UILabel *highTempLabel;
@property (strong, nonatomic) UIStackView *tempStackView;

/* Weather Information */
@property (strong, nonatomic) Weather *dayWeather;
@property (strong, nonatomic) NSString *tempType; //C or F
@end
