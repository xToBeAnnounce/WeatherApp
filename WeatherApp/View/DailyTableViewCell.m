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
    self.temperateLabel = [[UILabel alloc] initWithFrame:CGRectMake(325,10 , 10, 10)];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , 10, 10)];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(155, 10, 35, 35)];
    return self;
}

-(void)setCellUI:(Weather*)dailyWeather{
    self.temperateLabel.text = [dailyWeather getTempInString:dailyWeather.temperature];
    self.temperateLabel.textColor = [UIColor blackColor];
    self.temperateLabel.font = [UIFont systemFontOfSize:20];
    [self.temperateLabel sizeToFit];
    [self.contentView addSubview:self.temperateLabel];
    
    //setting timeLabel
    self.timeLabel.text = [dailyWeather getHourInDayWithTime:dailyWeather.time];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:20];
    [self.timeLabel sizeToFit];
    [self.contentView addSubview:self.timeLabel];
    
    //setting icons image view
    self.iconImageView.image = [UIImage imageNamed:dailyWeather.icon];
    [self.contentView addSubview:self.iconImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
