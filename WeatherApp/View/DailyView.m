//
//  DailyView.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyView.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"
#import "Location.h"


@implementation DailyView
{
    UIView *_lineView;
    UIView *_lineView2;
    UIView *_lineView3;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDailyUI];
        [self displayCurrentWeather];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void) updateDataIfNeeded {
    if (self.location.weeklyData.count == 0) {
        [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                [self displayCurrentWeather];
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void) setLocation:(Location *)location {
    if (_location.weeklyData) location.weeklyData = _location.weeklyData;
    _location = location;
    [self updateDataIfNeeded];
    [self refreshView];
}

- (void)setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self refreshView];
}

- (void) setDailyUI {
    
    //setting up icon image view
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    
    //setting up humidity label
    UILabel *humidityTitle = [[UILabel alloc]init];
    humidityTitle.font = [UIFont systemFontOfSize:15];
    humidityTitle.text = @"HUMIDITY";
    humidityTitle.textColor = UIColor.whiteColor;
    [humidityTitle sizeToFit];
    self.humidityLabel = [[UILabel alloc]init];
    self.humidityLabel.font = [UIFont systemFontOfSize:18];
    self.humidityLabel.textColor = UIColor.whiteColor;
    
    //setting up windspeed label
    UILabel *windspeedTitle = [[UILabel alloc]init];
    windspeedTitle.font = [UIFont systemFontOfSize:15];
    windspeedTitle.text = @"WIND SPEED";
    windspeedTitle.textColor = UIColor.whiteColor;
    [windspeedTitle sizeToFit];
    self.windspeedLabel = [[UILabel alloc]init];
    self.windspeedLabel.font = [UIFont systemFontOfSize:18];
    self.windspeedLabel.textColor = UIColor.whiteColor;
    
    //setting up uvIndex
    UILabel *uvIndexTitle = [[UILabel alloc]init];
    uvIndexTitle.font = [UIFont systemFontOfSize:15];
    uvIndexTitle.text = @"UV INDEX";
    uvIndexTitle.textColor = UIColor.whiteColor;
    [uvIndexTitle sizeToFit];
    self.uvIndexLabel = [[UILabel alloc]init];
    self.uvIndexLabel.font = [UIFont systemFontOfSize:18];
    self.uvIndexLabel.textColor = UIColor.whiteColor;
    
    //setting up rain chance
    UILabel *rainChanceTitle = [[UILabel alloc]init];
    rainChanceTitle.font = [UIFont systemFontOfSize:15];
    rainChanceTitle.text = @"CHANCE OF RAIN";
    rainChanceTitle.textColor = UIColor.whiteColor;
    [rainChanceTitle sizeToFit];
    self.rainChanceLabel = [[UILabel alloc]init];
    self.rainChanceLabel.font = [UIFont systemFontOfSize:18];
    self.rainChanceLabel.textColor = UIColor.whiteColor;
    
    //setting up summary
    self.summaryLabel = [[UILabel alloc]init];
    self.summaryLabel.text = @"--";
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.font = [UIFont systemFontOfSize:17];
    self.summaryLabel.textColor = UIColor.whiteColor;

    UIImageView *sunriseIV = [[UIImageView alloc]init];
    sunriseIV.image = [UIImage imageNamed:@"sunrise"];
    UIImageView *sunsetIV = [[UIImageView alloc]init];
    sunsetIV.image = [UIImage imageNamed:@"sunset"];

    self.sunriseLabel = [[UILabel alloc]init];
    self.sunriseLabel.text = @"6am";
    self.sunriseLabel.font = [UIFont systemFontOfSize:18];
    self.sunriseLabel.textColor = UIColor.whiteColor;
    [self.sunriseLabel sizeToFit];

    self.sunsetLabel = [[UILabel alloc]init];
    self.sunsetLabel.text = @"8pm";
    self.sunsetLabel.font = [UIFont systemFontOfSize:18];
    self.sunsetLabel.textColor = UIColor.whiteColor;
    [self.sunsetLabel sizeToFit];

    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = UIColor.whiteColor;
    _lineView.alpha = 0.7;
    [self addSubview:_lineView];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5].active = YES;
    [_lineView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5].active = YES;
    [_lineView.heightAnchor constraintEqualToConstant:1].active = YES;

    _lineView2 = [[UIView alloc]init];
    _lineView2.backgroundColor = UIColor.whiteColor;
        _lineView2.alpha = 0.7;
    [self addSubview:_lineView2];
    _lineView2.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView2.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5].active = YES;
    [_lineView2.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5].active = YES;
    [_lineView2.heightAnchor constraintEqualToConstant:1].active = YES;

    _lineView3 = [[UIView alloc]init];
    _lineView3.backgroundColor = UIColor.whiteColor;
        _lineView3.alpha = 0.7;
    [self addSubview:_lineView3];
    _lineView3.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView3.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5].active = YES;
    [_lineView3.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5].active = YES;
    [_lineView3.heightAnchor constraintEqualToConstant:1].active = YES;

    self.IconSummaryStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.iconImageView,self.summaryLabel]];
    [self addSubview:self.IconSummaryStackView];
    
    self.HumidityStack = [[UIStackView alloc]initWithArrangedSubviews:@[humidityTitle,self.humidityLabel]];
    self.WindspeedStack = [[UIStackView alloc]initWithArrangedSubviews:@[windspeedTitle,self.windspeedLabel]];
    self.HumidityWindStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.HumidityStack,self.WindspeedStack]];
    [self addSubview:self.HumidityWindStackView];
    
    self.UVIndexStack = [[UIStackView alloc]initWithArrangedSubviews:@[uvIndexTitle,self.uvIndexLabel]];
    self.ChanceOfRainStack = [[UIStackView alloc]initWithArrangedSubviews:@[rainChanceTitle,self.rainChanceLabel]];
    self.UVIndexRainStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.UVIndexStack,self.ChanceOfRainStack]];
    [self addSubview:self.UVIndexRainStackView];
    
    self.sunRiseStack = [[UIStackView alloc]initWithArrangedSubviews:@[sunriseIV,self.sunriseLabel]];
    self.sunSetStack = [[UIStackView alloc]initWithArrangedSubviews:@[sunsetIV,self.sunsetLabel]];
    self.sunRiseSetStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.sunRiseStack,self.sunSetStack]];
    [self addSubview:self.sunRiseSetStackView];
    
    
    [self setConstraints];
}

-(void)setConstraints{
    [self.iconImageView.heightAnchor constraintEqualToConstant:70].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToConstant:70].active = YES;
    
    self.IconSummaryStackView.distribution = UIStackViewAlignmentCenter;
    self.IconSummaryStackView.axis = UILayoutConstraintAxisHorizontal;
    self.IconSummaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.IconSummaryStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.IconSummaryStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.IconSummaryStackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
    
    self.HumidityStack.axis = UILayoutConstraintAxisVertical;
    self.HumidityStack.distribution = UIStackViewAlignmentCenter;
    self.HumidityStack.spacing = 5;
    self.HumidityStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.WindspeedStack.axis = UILayoutConstraintAxisVertical;
    self.WindspeedStack.distribution = UIStackViewAlignmentCenter;
    self.WindspeedStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.WindspeedStack.spacing = 5;
    self.HumidityWindStackView.axis = UILayoutConstraintAxisHorizontal;
    self.HumidityWindStackView.distribution = UIStackViewAlignmentCenter;
    self.HumidityWindStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.HumidityWindStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:55].active=YES;
    [self.HumidityWindStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-55].active=YES;
    [_lineView.topAnchor constraintEqualToAnchor: self.IconSummaryStackView.bottomAnchor constant:5].active = YES;
    [_lineView.bottomAnchor constraintEqualToAnchor:self.HumidityWindStackView.topAnchor constant:-5].active = YES;
//    [self.IconSummaryStackView.bottomAnchor constraintEqualToAnchor:self.HumidityWindStackView.topAnchor constant:-5].active=YES;
    
    self.UVIndexStack.axis = UILayoutConstraintAxisVertical;
    self.UVIndexStack.distribution = UIStackViewAlignmentCenter;
    self.UVIndexStack.spacing = 5;
    self.UVIndexStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.ChanceOfRainStack.axis = UILayoutConstraintAxisVertical;
    self.ChanceOfRainStack.distribution = UIStackViewAlignmentCenter;
    self.ChanceOfRainStack.spacing = 5;
    self.ChanceOfRainStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.UVIndexRainStackView.axis = UILayoutConstraintAxisHorizontal;
    self.UVIndexRainStackView.distribution = UIStackViewAlignmentCenter;
    self.UVIndexRainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.UVIndexRainStackView.spacing = 90;
    [self.UVIndexRainStackView.leadingAnchor constraintLessThanOrEqualToAnchor:self.leadingAnchor constant:55].active = YES;
    [self.UVIndexRainStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50].active = YES;
//    [self.HumidityWindStackView.bottomAnchor constraintEqualToAnchor:self.UVIndexRainStackView.topAnchor constant:-6].active = YES;
    [_lineView2.topAnchor constraintEqualToAnchor: self.HumidityWindStackView.bottomAnchor constant:5].active = YES;
    [_lineView2.bottomAnchor constraintEqualToAnchor:self.UVIndexRainStackView.topAnchor constant:-5].active = YES;

    
    self.sunRiseStack.axis = UILayoutConstraintAxisVertical;
    self.sunRiseStack.distribution = UIStackViewAlignmentCenter;
    self.sunRiseStack.spacing = 5;
    self.sunRiseStack.translatesAutoresizingMaskIntoConstraints = NO;

    self.sunSetStack.axis = UILayoutConstraintAxisVertical;
    self.sunSetStack.distribution = UIStackViewAlignmentCenter;
    self.sunSetStack.spacing = 5;
    self.sunSetStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.sunRiseSetStackView.axis = UILayoutConstraintAxisHorizontal;
    self.sunRiseSetStackView.distribution = UIStackViewAlignmentCenter;
    self.sunRiseSetStackView.spacing = 40;
    self.sunRiseSetStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.sunRiseSetStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:55].active = YES;
    [self.sunRiseSetStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -55].active = YES;
//    [self.UVIndexRainStackView.bottomAnchor constraintEqualToAnchor:self.sunRiseSetStackView.topAnchor constant:-9].active = YES;
    [_lineView3.topAnchor constraintEqualToAnchor: self.UVIndexRainStackView.bottomAnchor constant:5].active = YES;
    [_lineView3.bottomAnchor constraintEqualToAnchor:self.sunRiseSetStackView   .topAnchor constant:-5].active = YES;

    [self.sunRiseSetStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8].active = YES;
}


-(void)displayCurrentWeather{
    Weather *currentWeather;
    if (self.location.weeklyData.count) currentWeather = self.location.weeklyData[0];
    
    self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    self.humidityLabel.text = [currentWeather getHumidityInString:currentWeather.humidity];
    [self.humidityLabel sizeToFit];
    
    self.windspeedLabel.text = [currentWeather getWindSpeedInString:currentWeather.windSpeed];
    [self.windspeedLabel sizeToFit];
    

    self.uvIndexLabel.text = [NSString stringWithFormat:@"%d", currentWeather.uvIndex];
    [self.uvIndexLabel sizeToFit];
    
    self.summaryLabel.text = [currentWeather formatSummary];
    [self.summaryLabel  sizeToFit];
    
    self.rainChanceLabel.text = [currentWeather getprecipProbabilityInString:currentWeather.precipProbability];
    [self.rainChanceLabel sizeToFit];
}

- (void) refreshView {
    [self displayCurrentWeather];
}

@end
