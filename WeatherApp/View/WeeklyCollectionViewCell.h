//
//  WeeklyCollectionViewCell.h
//  WeatherApp
//
//  Created by Trustin Harris on 8/3/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
#import "Location.h"

@interface WeeklyCollectionViewCell : UICollectionViewCell

/* User Interface Labels */
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *backIV;
@property (strong, nonatomic) UILabel *lowTempLabel;
@property (strong, nonatomic) UILabel *highTempLabel;
@property (strong,nonatomic) UILabel *summaryLabel;

/* Weather Information */
@property (strong, nonatomic) Weather *dayWeather;
@property (strong, nonatomic) NSString *tempType; //C or F
- (void)setDayWeather:(Weather *)dayWeather;


-(void)setWeeklyCVC;
@end
