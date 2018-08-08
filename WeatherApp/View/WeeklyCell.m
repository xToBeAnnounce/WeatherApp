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

static NSArray *activityNames;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //Date Label at left (Monday, Tuesday...)
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 13, 0, 0)];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:17];
    //self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.dateLabel];
    
    //Weather icon image at center
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 2, 37, 37)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    //self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];

    //High temperature display at right
    self.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(340, 2, 0, 0)];
    self.highTempLabel.textColor = [UIColor redColor];
    self.highTempLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.highTempLabel];

    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(380, 2, 0, 0)];
    self.lowTempLabel.textColor = [UIColor cyanColor];
    self.lowTempLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.lowTempLabel];
    
//    self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 2, 0, 0)];
//    self.summaryLabel.textColor = UIColor.whiteColor;
//    self.summaryLabel.font = [UIFont systemFontOfSize:16];
//    self.summaryLabel.numberOfLines = 2;
//    [self.contentView addSubview:self.summaryLabel];
//
//    UILabel *humidity = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 0, 0)];
//    humidity.font = [UIFont systemFontOfSize:15];
//    humidity.text = @"Humidity:";
//    humidity.textColor = UIColor.whiteColor;
//    [humidity sizeToFit];
//    [self.contentView addSubview:humidity];
    
//    UILabel *windspeed = [[UILabel alloc]initWithFrame:CGRectMake(120, 60, 0,0)];
//    windspeed.text = @"Wind Speed:";
//    windspeed.textColor = UIColor.whiteColor;
//    windspeed.font = [UIFont systemFontOfSize:15];
//    [windspeed sizeToFit];
//    [self.contentView addSubview:windspeed];

//    self.humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 30, 0, 0)];
//    self.humidityLabel.textColor = UIColor.whiteColor;
//    self.humidityLabel.font = [UIFont systemFontOfSize:15];
//    [self.contentView addSubview:self.humidityLabel];
//
//    self.windspeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 60, 0, 0)];
//    self.windspeedLabel.textColor = UIColor.whiteColor;
//    self.windspeedLabel.font = [UIFont systemFontOfSize:15];
//    [self.contentView addSubview:self.windspeedLabel];
   
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
    self.highTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureHigh withType:self.tempType];
    [self.highTempLabel sizeToFit];
    
    // Low temp label
    self.lowTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureLow withType:self.tempType];
    [self.lowTempLabel sizeToFit];
    
//    self.summaryLabel.text = [dayWeather formatSummary:dayWeather.icon];
//    [self.summaryLabel sizeToFit];
//
//    self.humidityLabel.text = [dayWeather getHumidityInString:dayWeather.humidity];
//    [self.humidityLabel sizeToFit];
//
//    self.windspeedLabel.text = [dayWeather getWindSpeedInString:dayWeather.windSpeed];
//    [self.windspeedLabel sizeToFit];
}

@end
