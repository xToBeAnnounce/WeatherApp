//
//  HourlyCollectionCell.m
//  WeatherApp
//
//  Created by Tiffany Ma on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HourlyCollectionCell.h"

@implementation HourlyCollectionCell

{
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UILabel *_temperatureLabel;
    UIStackView *_hourlyStackView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellBackground];
        [self initalizeLabels];
        [self setLabelConstraints];
    }
    return self;
}

-(void)initalizeLabels{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_timeLabel];
    
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    _temperatureLabel = [[UILabel alloc] init];
    _temperatureLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_temperatureLabel];
}

-(void)setLabelConstraints{
    [_iconView.heightAnchor constraintEqualToConstant:20];
    [_iconView.widthAnchor constraintEqualToConstant:20];
    NSArray *arrangedViews = @[_timeLabel, _iconView, _temperatureLabel];
    _hourlyStackView = [[UIStackView alloc] initWithArrangedSubviews: arrangedViews];
    _hourlyStackView.axis = UILayoutConstraintAxisVertical;
    _hourlyStackView.distribution = UIStackViewDistributionFill;
    _hourlyStackView.alignment = UIStackViewAlignmentCenter;
    _hourlyStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_hourlyStackView];
    
    [_hourlyStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_hourlyStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_hourlyStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [_hourlyStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
}

-(void)setCellBackground{
    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blureffectView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
    blureffectView.alpha = 0.3;
    blureffectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.contentView addSubview:blureffectView];
    
    [blureffectView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [blureffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [blureffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [blureffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)setWeather:(Weather *)weather{
    _weather = weather;
    _timeLabel.text = [weather getHourInDayWithTime:weather.time];
    [_timeLabel sizeToFit];
    
    _iconView.image = [UIImage imageNamed:weather.icon];
    
    _temperatureLabel.text = [weather getTempInString:weather.temperature];
    [_temperatureLabel sizeToFit];
}
@end
