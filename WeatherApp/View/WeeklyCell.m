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
    self.displayActivity = NO;
    
    //Date Label at left (Monday, Tuesday...)
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 0, 0)];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:19];
    //self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.dateLabel];
    
    //Weather icon image at center
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 25, 53, 53)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    //self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];

    //High temperature display at right
    self.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(335, 2, 0, 0)];
    self.highTempLabel.textColor = [UIColor redColor];
    self.highTempLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.highTempLabel];

    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(335, 50, 0, 0)];
    self.lowTempLabel.textColor = [UIColor cyanColor];
    self.lowTempLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.lowTempLabel];
    
    self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 2, 0, 0)];
    self.summaryLabel.textColor = UIColor.whiteColor;
    self.summaryLabel.font = [UIFont systemFontOfSize:16];
    self.summaryLabel.numberOfLines = 2;
    [self.contentView addSubview:self.summaryLabel];
    
    UILabel *humidity = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 0, 0)];
    humidity.font = [UIFont systemFontOfSize:15];
    humidity.text = @"Humidity:";
    humidity.textColor = UIColor.whiteColor;
    [humidity sizeToFit];
    [self.contentView addSubview:humidity];
    
    UILabel *windspeed = [[UILabel alloc]initWithFrame:CGRectMake(120, 60, 0,0)];
    windspeed.text = @"Wind Speed:";
    windspeed.textColor = UIColor.whiteColor;
    windspeed.font = [UIFont systemFontOfSize:15];
    [windspeed sizeToFit];
    [self.contentView addSubview:windspeed];

    self.humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 30, 0, 0)];
    self.humidityLabel.textColor = UIColor.whiteColor;
    self.humidityLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.humidityLabel];
    
    self.windspeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 60, 0, 0)];
    self.windspeedLabel.textColor = UIColor.whiteColor;
    self.windspeedLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.windspeedLabel];
    
    
    
                                                                  


    
    [self setConstraints];
    return self;
}

-(IBAction)onSelectActivity:(id)sender{
    UIButton *activity = (UIButton*)sender;
    NSString *activityType = activity.titleLabel.text;
    
    [self.delegate displayPopoverWithType:activityType Location:self.location];
}

- (void)setDayWeather:(Weather *)dayWeather {
    _dayWeather = dayWeather;
    NSLog(@"%@", dayWeather.icon);
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
    
    self.summaryLabel.text = [dayWeather formatSummary:dayWeather.icon];
    [self.summaryLabel sizeToFit];
    
    self.humidityLabel.text = [dayWeather getHumidityInString:dayWeather.humidity];
    [self.humidityLabel sizeToFit];
    
    self.windspeedLabel.text = [dayWeather getWindSpeedInString:dayWeather.windSpeed];
    [self.windspeedLabel sizeToFit];
    
    //Activity
    NSString *weatherCondition = dayWeather.icon;
    if([weatherCondition rangeOfString:@"clear"].location != NSNotFound){
        activityNames = @[@"amusement_park", @"campground", @"park", @"zoo", @"stadium", @"resturant", @"cafe"];
    }
    else if([weatherCondition rangeOfString:@"cloud"].location != NSNotFound ||
            [weatherCondition rangeOfString:@"rain"].location != NSNotFound){
        activityNames = @[@"aquarium", @"cafe", @"resturant", @"bowling_alley", @"clothing_store", @"gym", @"library", @"movie_theater", @"shopping_mall"];
    }

    self.activityStack.hidden = !self.displayActivity;
    if(self.displayActivity){
        [self initActivityButtons];
        self.bottomConstraint.active = NO;
        [self.contentView addSubview:self.activityStack];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconView]-10-[activityView]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"iconView":self.iconImageView, @"activityView":self.activityStack}]];
    }
    else{
        [self.activityStack removeFromSuperview];
        self.bottomConstraint.active = YES;
    }
}

- (void) setConstraints {
//    self.bottomConstraint = [self.iconImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4];
//    self.bottomConstraint.active = YES;
//
//    [self.dateLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
//    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
//
//    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
//    [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
//    [self.iconImageView.heightAnchor constraintEqualToConstant:40].active = YES;
//    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
//
//    [self.tempStackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
//    [self.tempStackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
}

-(void)initActivityButtons{
    int rowCount = 6;
    self.activityStack = [[UIStackView alloc] init];
    self.activityStack.axis = UILayoutConstraintAxisVertical;
    self.activityStack.distribution = UIStackViewDistributionFill;
    self.activityStack.alignment = UIStackViewAlignmentCenter;
    self.activityStack.spacing = 5;
    self.activityStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    for(int i=0; i<((activityNames.count + rowCount-1) / rowCount); i++){
        UIStackView *rowStack = [[UIStackView alloc] init];
        rowStack.axis = UILayoutConstraintAxisHorizontal;
        rowStack.distribution = UIStackViewDistributionFill;
        rowStack.alignment = UIStackViewAlignmentCenter;
        rowStack.spacing = 5;
        rowStack.translatesAutoresizingMaskIntoConstraints = NO;
        
        for(int j=0; j<rowCount; j++){
            if(rowCount*i + j == activityNames.count) break;
            NSString *title = activityNames[rowCount*i + j];
            UIButton *activity = [[UIButton alloc] init];
            [activity setTitle:title forState:UIControlStateNormal];
            [activity setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
            [activity.heightAnchor constraintEqualToConstant:30].active = YES;
            [activity.widthAnchor constraintEqualToConstant:30].active = YES;
            activity.translatesAutoresizingMaskIntoConstraints = NO;
            [activity addTarget:self action:@selector(onSelectActivity:) forControlEvents:UIControlEventTouchUpInside];
            [rowStack addArrangedSubview:activity];
        }
        [self.activityStack addArrangedSubview:rowStack];
    }
    [self.contentView addSubview:self.activityStack];
}

@end
