//
//  DailyTableViewCell.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/18/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyTableViewCell.h"
#import "Weather.h"

@implementation DailyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    // initalizing time label
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:20];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.timeLabel];

    // initalizing icon view
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];
    
    // initalizing temperature label
    self.temperateLabel = [[UILabel alloc] init];
    self.temperateLabel.textColor = [UIColor blackColor];
    self.temperateLabel.font = [UIFont systemFontOfSize:20];
    self.temperateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.temperateLabel];
    
    
    [self setConstraints];
    
    return self;
}

- (void)setHourWeather:(Weather *)hourWeather {
    _hourWeather = hourWeather;
    
    //setting timeLabel
    self.timeLabel.text = [hourWeather getHourInDayWithTime:hourWeather.time];
    [self.timeLabel sizeToFit];
    
    //setting icons image view
    self.iconImageView.image = [UIImage imageNamed:hourWeather.icon];
    
    //setting temperatureLabel
    self.temperateLabel.text = [hourWeather getTempInString:hourWeather.temperature withType:self.tempType];
    [self.temperateLabel sizeToFit];
}

- (void) setConstraints {
    [self.timeLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.timeLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    
    [self.iconImageView.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    
    [self.temperateLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.temperateLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
}

@end
