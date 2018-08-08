//
//  TodayWeatherView.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayWeatherView.h"

@implementation TodayWeatherView
{
    UIView *_weatherView;
    CAGradientLayer *_gradientLayer;
    UIImageView *_currentIconView;
    UIStackView *_iconStackView;
    UIStackView *_highLowStackView;
    
    UILabel *_iconDescLabel;
    UILabel *_currentTempLabel;
    UILabel *_highTempLabel;
    UILabel *_lowTempLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
}

- (void)setTempTypeString:(NSString *)tempTypeString {
    _tempTypeString = tempTypeString;
    [self refreshView];
}

- (void)setCurrentWeather:(Weather *)currentWeather {
    _currentWeather = currentWeather;
    [self refreshView];
}

- (void)setTodayWeather:(Weather *)todayWeather {
    _todayWeather = todayWeather;
    [self refreshView];
}

- (void)layoutSubviews {
    _gradientLayer.frame = self.bounds;
    [super layoutSubviews];
}

- (void) refreshView {
    // Icon and description
    _currentIconView.image = [UIImage imageNamed:self.currentWeather.icon];
    _iconDescLabel.text = [self.currentWeather formattedIconSummary];
    
    // High low for the day
    _highTempLabel.text = [NSString stringWithFormat:@"%@",
                           [self.todayWeather getTempInString:self.todayWeather.temperatureHigh withType:self.tempTypeString]];
    _lowTempLabel.text = [NSString stringWithFormat:@"%@",
                          [self.todayWeather getTempInString:self.todayWeather.temperatureLow withType:self.tempTypeString]];
    
    // current temperature
    _currentTempLabel.text = [self.currentWeather getTempInString:self.currentWeather.temperature withType:self.tempTypeString];
}

- (void) setViewUI {
    self.backgroundColor = [UIColor clearColor];
    [self setContentUI];
    
    _weatherView = [[UIView alloc] init];
    _weatherView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_weatherView];
    [self makeGradientLayer];
    
    _iconStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_currentIconView, _iconDescLabel]];
    _iconStackView.axis = UILayoutConstraintAxisHorizontal;
    _iconStackView.alignment = UIStackViewAlignmentCenter;
    _iconStackView.spacing = 5;
    _iconStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _highLowStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_highTempLabel, _lowTempLabel]];
    _highLowStackView.axis = UILayoutConstraintAxisHorizontal;
    _highLowStackView.alignment = UIStackViewAlignmentCenter;
    _highLowStackView.spacing = 15;
    _highLowStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_weatherView addSubview:_iconStackView];
    [_weatherView addSubview:_currentTempLabel];
    [_weatherView addSubview:_highLowStackView];
    [self setConstraints];
}

- (void) setContentUI {
    _currentIconView = [[UIImageView alloc] init];
    _currentIconView.image = [UIImage imageNamed:@"clear-day"];
    _currentIconView.contentMode = UIViewContentModeScaleAspectFit;
    _currentIconView.clipsToBounds = YES;
    _currentIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _currentTempLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_currentTempLabel withFont:[UIFont systemFontOfSize:72 weight:UIFontWeightThin] text:@"--°"];
    
    _iconDescLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_iconDescLabel withFont:[UIFont systemFontOfSize:20] text:@" "];
    
    UIColor *lightBlueColor = [UIColor colorWithRed:0.83 green:0.92 blue:1.00 alpha:1.0];
    UIColor *lightRedColor = [UIColor colorWithRed:1.00 green:0.83 blue:0.92 alpha:1.0];
    
    _highTempLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_highTempLabel withFont:[UIFont systemFontOfSize:20] text:@"--°"];
    _highTempLabel.textColor = lightRedColor;
    
    _lowTempLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_lowTempLabel withFont:[UIFont systemFontOfSize:20] text:@"--°"];
    _lowTempLabel.textColor = lightBlueColor;
    
}

- (void) setConstraints {
    [_weatherView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_weatherView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_weatherView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_weatherView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    [_currentIconView.heightAnchor constraintEqualToConstant:_iconDescLabel.frame.size.height+10].active = YES;
    [_currentIconView.widthAnchor constraintEqualToAnchor:_currentIconView.heightAnchor].active = YES;
    
    [_highLowStackView.trailingAnchor constraintEqualToAnchor:_weatherView.trailingAnchor constant:-8].active = YES;
    [_highLowStackView.bottomAnchor constraintEqualToAnchor:_weatherView.bottomAnchor constant:-8].active = YES;
    
    [_currentTempLabel.leadingAnchor constraintEqualToAnchor:_weatherView.leadingAnchor constant:8].active = YES;
    
    [_weatherView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[iconStackView]-(-10)-[currentTempLabel]-(-2)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"iconStackView":_iconStackView, @"currentTempLabel":_currentTempLabel}]];
}

- (void) configureLabelProperties:(UILabel *)label withFont:(UIFont *)font text:(NSString *)text{
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    [_iconDescLabel sizeToFit];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    
    label.layer.shadowColor = [UIColor.blackColor CGColor];
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 2;
    label.layer.shadowOffset = CGSizeMake(0.5, 1.0);
    
    [_weatherView addSubview:label];
}


- (void) makeGradientLayer{
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = _gradientLayer.frame;
    _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor.blackColor CGColor]];
    _gradientLayer.opacity = 0.8;
    
    [_weatherView.layer addSublayer:_gradientLayer];
}

@end
