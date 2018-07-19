//
//  DailyTableViewCell.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/18/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyTableViewCell.h"

@implementation DailyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellUI:(NSDictionary*)dailyDict{
    NSDictionary *newDict = dailyDict;
    
    //setting temperatureLabel
    NSString *temp = newDict[@"temperature"];
    self.temperateLabel = [[UILabel alloc] initWithFrame:CGRectMake(325,10 , 10, 10)];
    self.temperateLabel.text = [NSString stringWithFormat:@"%.0ld", (long)temp.integerValue ];
    self.temperateLabel.textColor = [UIColor blackColor];
    self.temperateLabel.font = [UIFont systemFontOfSize:20];
    [self.temperateLabel sizeToFit];
    [self.contentView addSubview:self.temperateLabel];
    
    //setting timeLabel
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , 10, 10)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", newDict[@"time"]];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:20];
    [self.timeLabel sizeToFit];
    [self.contentView addSubview:self.timeLabel];
    
    //setting icons image view
    NSString *iconName = newDict[@"icon"];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(155, 10, 35, 35)];
    self.iconImageView.image = [UIImage imageNamed:iconName];
    [self.contentView addSubview:self.iconImageView];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
