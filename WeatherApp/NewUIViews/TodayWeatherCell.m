//
//  TodayWeatherCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayWeatherCell.h"


@implementation TodayWeatherCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = nil;
        self.weatherView = [[TodayWeatherView alloc] init];
        self.weatherView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.weatherView];
        [self setConstraints];
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
- (void) setConstraints {
    [self.weatherView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.weatherView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.weatherView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.weatherView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}
@end
