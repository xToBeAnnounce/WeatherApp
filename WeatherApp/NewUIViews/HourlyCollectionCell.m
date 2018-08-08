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
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setWeather:(Weather *)weather{
    _weather = weather;
    _timeLabel.text = [weather getHourInDayWithTime:weather.time];
    [_timeLabel sizeToFit];
}
@end
