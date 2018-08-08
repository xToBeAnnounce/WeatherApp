//
//  TodayWeatherCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayWeatherCell.h"

@implementation TodayWeatherCell
{
    UIView *_weatherView;
    CAGradientLayer *_gradientLayer;
    UIImageView *_currentIconView;
    UIStackView *_contentStackView;
    
    UILabel *_iconDescLabel;
    UILabel *_currentTempLabel;
    UILabel *_highLowTempLabel;
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
    [super setSelected:selected animated:animated];
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
    _highLowTempLabel.text = [NSString stringWithFormat:@"%@/ %@",
                              [self.todayWeather getTempInString:self.todayWeather.temperatureHigh withType:self.tempTypeString],
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
    
    UIStackView *iconStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_currentIconView, _iconDescLabel]];
    iconStackView.axis = UILayoutConstraintAxisHorizontal;
    iconStackView.alignment = UIStackViewAlignmentCenter;
    iconStackView.spacing = 5;
    
    _contentStackView = [[UIStackView alloc] initWithArrangedSubviews:@[iconStackView, _highLowTempLabel, _currentTempLabel]];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.distribution = UIStackViewDistributionEqualSpacing;
    _contentStackView.alignment = UIStackViewAlignmentLeading;
    [_weatherView addSubview:_contentStackView];
    [self setConstraints];
}

- (void) setContentUI {
    _currentIconView = [[UIImageView alloc] init];
    _currentIconView.image = [UIImage imageNamed:@"clear-day"];
    _currentIconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _currentTempLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_currentTempLabel withFont:[UIFont systemFontOfSize:72 weight:UIFontWeightThin]];
    _currentTempLabel.text = @"63";
    [_currentTempLabel sizeToFit];
    
    _iconDescLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_iconDescLabel withFont:[UIFont systemFontOfSize:20]];
    _iconDescLabel.text = @"Sunny";
    [_iconDescLabel sizeToFit];
    
    _highLowTempLabel = [[UILabel alloc] init];
    [self configureLabelProperties:_highLowTempLabel withFont:[UIFont systemFontOfSize:20]];
    _highLowTempLabel.text = @"80/ 75";
    [_highLowTempLabel sizeToFit];
    
}

- (void) setConstraints {
    [_weatherView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_weatherView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_weatherView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_weatherView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    [_contentStackView.topAnchor constraintEqualToAnchor:_weatherView.topAnchor].active = YES;
    [_contentStackView.bottomAnchor constraintEqualToAnchor:_weatherView.bottomAnchor].active = YES;
    [_contentStackView.leadingAnchor constraintEqualToAnchor:_weatherView.leadingAnchor constant:8].active = YES;
    
    [_currentIconView.heightAnchor constraintEqualToConstant:_iconDescLabel.frame.size.height+10].active = YES;
    [_currentIconView.widthAnchor constraintEqualToAnchor:_currentIconView.heightAnchor].active = YES;
    
//    [_highLowTempLabel.leadingAnchor constraintEqualToAnchor:_contentStackView.leadingAnchor].active = YES;
//    [_highLowTempLabel.trailingAnchor constraintEqualToAnchor:_contentStackView.trailingAnchor].active = YES;
}

- (void) configureLabelProperties:(UILabel *)label withFont:(UIFont *)font{
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor whiteColor];
    label.font = font;
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
    _gradientLayer.opacity = 0.5;
    
    [_weatherView.layer addSublayer:_gradientLayer];
}
@end
