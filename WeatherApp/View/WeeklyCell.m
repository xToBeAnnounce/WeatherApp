//
//  WeeklyCell.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyCell.h"
#import "Weather.h"

@implementation WeeklyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.dateLabel];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];

    self.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 0, 0)];
    self.highTempLabel.textColor = [UIColor redColor];

    self.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 0, 0)];
    self.lowTempLabel.textColor = [UIColor blueColor];
    
    NSArray *tempArray = @[self.highTempLabel, self.lowTempLabel];
    self.tempStackView = [[UIStackView alloc] initWithArrangedSubviews:tempArray];
    self.tempStackView.axis = UILayoutConstraintAxisHorizontal;
    self.tempStackView.distribution = UIStackViewDistributionFill;
    self.tempStackView.alignment = UIStackViewAlignmentCenter;
    self.tempStackView.spacing = 8;
    self.tempStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.tempStackView];
    
    [self setConstraints];
    
    return self;
}

- (void)setDayWeather:(Weather *)dayWeather {
    _dayWeather = dayWeather;
    // Day of Week Label
    self.dateLabel.text = [dayWeather getDayOfWeekWithTime:dayWeather.time];
    [self.dateLabel sizeToFit];
    
    // Weather icon image view
    self.iconImageView.image = [UIImage imageNamed:dayWeather.icon];
    
    // High temp label
    self.highTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureHigh];
    [self.highTempLabel sizeToFit];
    
    // Low temp label
    self.lowTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureLow];
    [self.lowTempLabel sizeToFit];
}

- (void) setConstraints {
    [self.dateLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    
    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.iconImageView.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    [self.iconImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4].active = YES;
    [self.iconImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4].active = YES;
    
    [self.tempStackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.tempStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
}

@end
