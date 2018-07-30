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
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.dateLabel];
    
    //Weather icon image at center
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.iconImageView];

    //High temperature display at right
    self.highTempLabel = [[UILabel alloc] init];
    self.highTempLabel.textColor = [UIColor redColor];
    self.highTempLabel.font = [UIFont systemFontOfSize:20];

    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] init];
    self.lowTempLabel.textColor = [UIColor blueColor];
    self.lowTempLabel.font = [UIFont systemFontOfSize:20];
    
    NSArray *tempArray = @[self.highTempLabel, self.lowTempLabel];
    self.tempStackView = [[UIStackView alloc] initWithArrangedSubviews:tempArray];
    self.tempStackView.axis = UILayoutConstraintAxisHorizontal;
    self.tempStackView.distribution = UIStackViewDistributionFill;
    self.tempStackView.alignment = UIStackViewAlignmentCenter;
    self.tempStackView.spacing = 8;
    self.tempStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.tempStackView];
    
//    self.sunnyActivity = [[UIButton alloc]init];
//    [self.sunnyActivity setTitle:@"cafe" forState:UIControlStateNormal];
//    [self.sunnyActivity setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//    [self.sunnyActivity sizeToFit];
//    self.sunnyActivity.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.sunnyActivity addTarget:self action:@selector(onSelectActivity:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.sunnyActivity];
    
    self.bottomConstraint = [self.iconImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4];
    self.bottomConstraint.active = YES;
    
    activityNames = @[@"cafe", @"bike", @"movie", @"park"];
    [self initActivityButtons];
    [self setConstraints];
    
    return self;
}

-(IBAction)onSelectActivity:(id)sender{
    UIButton *activity = (UIButton*)sender;
    NSString *activityName = activity.titleLabel.text;
    
    [self.delegate displayPopoverWithType:activityName Location:self.location AtRow:self.rowNum Height:self.rowHeight];
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
    
    self.activityStack.hidden = !self.displayActivity;
    
    if(!self.displayActivity){
        [self.activityStack removeFromSuperview];
        self.bottomConstraint.active = YES;
    }
    else{
        self.bottomConstraint.active = NO;
        [self.contentView addSubview:self.activityStack];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconView]-10-[activityView]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"iconView":self.iconImageView, @"activityView":self.activityStack}]];
    }
}

- (void) setConstraints {
    [self.dateLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    
    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.iconImageView.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    
    [self.tempStackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.tempStackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
}

-(void)initActivityButtons{
    self.activityStack = [[UIStackView alloc] init];
    self.activityStack.axis = UILayoutConstraintAxisHorizontal;
    self.activityStack.distribution = UIStackViewDistributionFill;
    self.activityStack.alignment = UIStackViewAlignmentCenter;
    self.activityStack.spacing = 8;
    self.activityStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    for(NSString *title in activityNames){
        UIButton *activity = [[UIButton alloc] init];
        [activity setTitle:title forState:UIControlStateNormal];
        [activity setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [activity sizeToFit];
        activity.translatesAutoresizingMaskIntoConstraints = NO;
        [activity addTarget:self action:@selector(onSelectActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self.activityStack addArrangedSubview:activity];
    }
    [self.contentView addSubview:self.activityStack];
}

@end
