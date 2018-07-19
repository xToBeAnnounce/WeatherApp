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
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setWeeklyCell:(Weather*)dailyWeather{
       UIStackView *weeklyCellStackView = [[UIStackView alloc] init];
       weeklyCellStackView.axis = UILayoutConstraintAxisHorizontal;
       weeklyCellStackView.distribution = UIStackViewDistributionFill;
       weeklyCellStackView.alignment = UIStackViewAlignmentCenter;
    
//       double timeSince = [dailyData[@"time"] doubleValue];
//       NSDate *dayOfWeek = [NSDate dateWithTimeIntervalSince1970:timeSince];
//
//       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//       formatter.dateStyle = NSDateFormatterMediumStyle;
//       formatter.timeStyle = NSDateFormatterNoStyle;
//       formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//       [formatter setLocalizedDateFormatFromTemplate:@"EEEE MMMMd"];
    
       UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
       //dateLabel.text = [formatter stringFromDate:dayOfWeek];
       dateLabel.text = [dailyWeather getDayOfWeekWithTime:dailyWeather.time];
       dateLabel.textColor = [UIColor blackColor];
       [dateLabel sizeToFit];
       [self.contentView addSubview:dateLabel];
    
       UILabel *highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 0, 0)];
//       double highTemp = [dailyData[@"temperatureHigh"] doubleValue];
//       highTempLabel.text = [NSString stringWithFormat:@"%.0f", highTemp];
    highTempLabel.text = [dailyWeather getTempInString:dailyWeather.temperatureHigh];
       highTempLabel.textColor = [UIColor redColor];
       [highTempLabel sizeToFit];
       [self.contentView addSubview:highTempLabel];
    
       UILabel *lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 0, 0)];
//       double lowTemp = [dailyData[@"temperatureLow"] doubleValue];
//       lowTempLabel.text = [NSString stringWithFormat:@"%.0f", lowTemp];
    lowTempLabel.text = [dailyWeather getTempInString:dailyWeather.temperatureLow];
       lowTempLabel.textColor = [UIColor blueColor];
       [lowTempLabel sizeToFit];
       [self.contentView addSubview:lowTempLabel];
    
       [weeklyCellStackView addArrangedSubview:dateLabel];
       [weeklyCellStackView addArrangedSubview:highTempLabel];
       [weeklyCellStackView addArrangedSubview:lowTempLabel];
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

    // Configure the view for the selected state
}

@end
