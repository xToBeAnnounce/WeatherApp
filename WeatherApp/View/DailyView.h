//
//  DailyView.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface DailyView : UIView
@property (strong,nonatomic) Location *location;
@property (strong, nonatomic) NSString *tempType;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *humidityLabel;
@property (strong,nonatomic) UILabel *windspeedLabel;
@property (strong,nonatomic) UILabel *summaryLabel;
@property (strong,nonatomic) UILabel *uvIndexLabel;
@property (strong,nonatomic) UILabel *rainChance;

- (void) refreshView;

@end
