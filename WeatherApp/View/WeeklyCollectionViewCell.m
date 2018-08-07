//
//  WeeklyCollectionViewCell.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/3/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyCollectionViewCell.h"
#import "Weather.h"

@implementation WeeklyCollectionViewCell

-(void)setWeeklyCVC{
    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blureffectView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
    blureffectView.alpha = 0.4;
    blureffectView.frame = self.contentView.frame;
    [self.contentView addSubview:blureffectView];
    
    //Date Label at left (Monday, Tuesday...)
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 0, 0)];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:19];
    //self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.dateLabel];
    
    self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 23, 0, 0)];
    self.summaryLabel.textColor = UIColor.whiteColor;
    self.summaryLabel.font = [UIFont systemFontOfSize:16];
    self.summaryLabel.numberOfLines = 2;
    [self.contentView addSubview:self.summaryLabel];
    
    //Weather icon image at center
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 44, 78, 78)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    //self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];
    

    //High temperature display at right
    self.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 75, 0, 0)];
    self.highTempLabel.textColor = [UIColor redColor];
    self.highTempLabel.font = [UIFont systemFontOfSize:25];
    [self.contentView addSubview:self.highTempLabel];
    
    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 105, 0, 0)];
    self.lowTempLabel.textColor = [UIColor blueColor];
    self.lowTempLabel.font = [UIFont systemFontOfSize:25];
    [self.contentView addSubview:self.lowTempLabel];
}

- (void)setDayWeather:(Weather *)dayWeather {
    _dayWeather = dayWeather;
    // Day of Week Label
    self.dateLabel.text = [dayWeather getDayOfWeekWithTime:dayWeather.time];
    [self.dateLabel sizeToFit];
    
    self.summaryLabel.text = [dayWeather formatSummary:dayWeather.icon];
    [self.summaryLabel sizeToFit];
    
    // Weather icon image view
    self.iconImageView.image = [UIImage imageNamed:dayWeather.icon];
    
    
    // High temp label
    self.highTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureHigh withType:self.tempType];
    [self.highTempLabel sizeToFit];
    
    // Low temp label
    self.lowTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureLow withType:self.tempType];
    [self.lowTempLabel sizeToFit];
}




@end
