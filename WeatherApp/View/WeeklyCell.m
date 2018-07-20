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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    self.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 0, 0)];
    self.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 0, 0)];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setWeeklyCell:(Weather*)dailyWeather{
    UIStackView *weeklyCellStackView = [[UIStackView alloc] init];
    weeklyCellStackView.axis = UILayoutConstraintAxisHorizontal;
    weeklyCellStackView.distribution = UIStackViewDistributionFill;
    weeklyCellStackView.alignment = UIStackViewAlignmentCenter;
    
    //Day of Week Label
    self.dateLabel.text = [dailyWeather getDayOfWeekWithTime:dailyWeather.time];
    self.dateLabel.textColor = [UIColor blackColor];
    [self.dateLabel sizeToFit];
    [self.contentView addSubview:self.dateLabel];
    
    //High temp label
    self.highTempLabel.text = [dailyWeather getTempInString:dailyWeather.temperatureHigh];
    self.highTempLabel.textColor = [UIColor redColor];
    [self.highTempLabel sizeToFit];
    [self.contentView addSubview:self.highTempLabel];
    
    //Low temp label
    self.lowTempLabel.text = [dailyWeather getTempInString:dailyWeather.temperatureLow];
    self.lowTempLabel.textColor = [UIColor blueColor];
    [self.lowTempLabel sizeToFit];
    [self.contentView addSubview:self.lowTempLabel];
    
    //Adding labels to single stack view
    [weeklyCellStackView addArrangedSubview:self.dateLabel];
    [weeklyCellStackView addArrangedSubview:self.highTempLabel];
    [weeklyCellStackView addArrangedSubview:self.lowTempLabel];
    [self.contentView addSubview:weeklyCellStackView];

    weeklyCellStackView.translatesAutoresizingMaskIntoConstraints = NO;
    weeklyCellStackView.spacing = 5;
    [weeklyCellStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20].active = YES;
    [weeklyCellStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [weeklyCellStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20].active = YES;
    [weeklyCellStackView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-8].active = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
