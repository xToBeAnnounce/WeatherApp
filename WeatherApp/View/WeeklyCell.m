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
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.dateLabel];
    
    //Weather icon image at center
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImageView];

    //High temperature display at right
    self.highTempLabel = [[UILabel alloc] init];
    self.highTempLabel.textColor = [UIColor redColor];
    self.highTempLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.highTempLabel];



    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] init];
    self.lowTempLabel.textColor = [UIColor cyanColor];
    self.lowTempLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.lowTempLabel];

    self.tempStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.highTempLabel,self.lowTempLabel]];
    [self.contentView addSubview:self.tempStackView];
    
    //Expanded View UI
    self.ExpandedView = [[UIView alloc]init];
    [self addSubview:self.ExpandedView];
    
    self.HumidityTitle = [[UILabel alloc]init];
    self.HumidityTitle.text = @"Humidity";
    self.HumidityTitle.font = [UIFont systemFontOfSize:18];
    [self.HumidityTitle sizeToFit];
    [self.ExpandedView addSubview:self.HumidityTitle];
    
    self.humidityLabel = [[UILabel alloc]init];
    [self.ExpandedView addSubview:self.humidityLabel];

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
    self.highTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureHigh withType:self.tempType];
    [self.highTempLabel sizeToFit];
    
    // Low temp label
    self.lowTempLabel.text = [dayWeather getTempInString:dayWeather.temperatureLow withType:self.tempType];
    [self.lowTempLabel sizeToFit];
    
    self.humidityLabel.text = [dayWeather getHumidityInString:dayWeather.humidity];
    [self.humidityLabel sizeToFit];
    
    
    
}

-(void)setConstraints{
    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.dateLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active=YES;
    [self.iconImageView.heightAnchor constraintEqualToConstant:37].active=YES;
    [self.iconImageView.widthAnchor constraintEqualToConstant:37].active=YES;
    [self.iconImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.tempStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active =YES;
    [self.tempStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active=YES;
    self.tempStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tempStackView.distribution = UIStackViewAlignmentCenter;
    self.tempStackView.axis = UILayoutConstraintAxisHorizontal;
    self.tempStackView.spacing = 8;
    
    //Constraints for Expanded View
    [self.ExpandedView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.ExpandedView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    self.ExpandedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ExpandedView.topAnchor constraintEqualToAnchor:self.tempStackView.bottomAnchor constant:20].active = YES;
    
    
    

    

}

@end
