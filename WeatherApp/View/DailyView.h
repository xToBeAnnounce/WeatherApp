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
@property (strong,nonatomic) UILabel *rainChanceLabel;
@property (strong,nonatomic) UILabel *sunriseLabel;
@property (strong,nonatomic) UILabel *sunsetLabel;
@property (strong,nonatomic) NSString *temptypeString;
@property (strong,nonatomic) UIStackView *IconSummaryStackView;
@property (strong,nonatomic) UIStackView *HumidityStack;
@property (strong,nonatomic) UIStackView *WindspeedStack;
@property (strong,nonatomic) UIStackView *HumidityWindStackView;
@property (strong,nonatomic) UIStackView *UVIndexStack;
@property (strong,nonatomic) UIStackView *ChanceOfRainStack;
@property (strong,nonatomic) UIStackView *UVIndexRainStackView;
@property (strong,nonatomic) UIStackView *sunRiseStack;
@property (strong,nonatomic) UIStackView *sunSetStack;
@property (strong,nonatomic) UIStackView *sunRiseSetStackView;


- (void) refreshView;

@end
