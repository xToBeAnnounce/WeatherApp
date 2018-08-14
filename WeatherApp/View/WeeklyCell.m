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
{
    UIView *_lineView;
}

static NSArray *activityNames;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) [self bringSubviewToFront:self.HumidWindStackView];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.clipsToBounds = YES;
    
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
    self.highTempLabel.textColor = [UIColor colorWithRed:1.00 green:0.83 blue:0.92 alpha:1.0];
    self.highTempLabel.font = [UIFont systemFontOfSize:17];

    //Low temperature display at right
    self.lowTempLabel = [[UILabel alloc] init];
    self.lowTempLabel.textColor = [UIColor colorWithRed:0.83 green:0.92 blue:1.00 alpha:1.0];
    self.lowTempLabel.font = [UIFont systemFontOfSize:17];
    
    self.tempStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.highTempLabel,self.lowTempLabel]];
    self.tempStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tempStackView.alignment = UIStackViewAlignmentCenter;
    self.tempStackView.axis = UILayoutConstraintAxisHorizontal;
    self.tempStackView.spacing = 8;
    [self.contentView addSubview:self.tempStackView];
    
    [self setExpandedView];
    [self setConstraints];
    
    return self;
}

-(void)setExpandedView{
    //Expanded View UI
    self.ExpandedView = [[UIView alloc] init];
//    self.ExpandedView.backgroundColor = UIColor.blackColor;
    self.ExpandedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.ExpandedView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.2];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ExpandedView addSubview:_lineView];
    
    // Humidity
    UILabel *HumidityTitle = [[UILabel alloc]init];
    HumidityTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    HumidityTitle.textColor = UIColor.whiteColor;
    HumidityTitle.text = @"HUMIDITY:";
    [HumidityTitle sizeToFit];
    self.humidityLabel = [[UILabel alloc]init];
    self.humidityLabel.font = [UIFont systemFontOfSize:17];
    self.humidityLabel.textColor = UIColor.whiteColor;
    self.humidityLabel.text = @"--%";
    
    // WInd Speed
    UILabel *WindSpeedTitle = [[UILabel alloc]init];
    WindSpeedTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    WindSpeedTitle.textColor = UIColor.whiteColor;
    WindSpeedTitle.text = @"WIND SPEED:";
    [WindSpeedTitle sizeToFit];
    self.windspeedLabel = [[UILabel alloc]init];
    self.windspeedLabel.font = [UIFont systemFontOfSize:17];
    self.windspeedLabel.textColor = UIColor.whiteColor;
    self.windspeedLabel.text = @"-- mph";
    
    self.summaryLabel = [[UILabel alloc]init];
    self.summaryLabel.font = [UIFont systemFontOfSize:17];
    self.summaryLabel.textColor = UIColor.whiteColor;
//    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.humidityStack = [[UIStackView alloc]initWithArrangedSubviews:@[HumidityTitle, self.humidityLabel]];
    self.humidityStack.distribution = UIStackViewDistributionEqualSpacing;
    self.humidityStack.axis = UILayoutConstraintAxisHorizontal;
    self.humidityStack.alignment = UIStackViewAlignmentCenter;
    self.humidityStack.spacing = 24;
    
    self.windspeedStack = [[UIStackView alloc]initWithArrangedSubviews:@[WindSpeedTitle, self.windspeedLabel]];
    self.windspeedStack.distribution = UIStackViewDistributionEqualSpacing;
    self.windspeedStack.axis = UILayoutConstraintAxisHorizontal;
    self.windspeedStack.alignment = UIStackViewAlignmentCenter;
    self.windspeedStack.spacing = 10;
    
    self.HumidWindStackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.humidityStack, self.windspeedStack, self.summaryLabel]];
    self.HumidWindStackView.distribution = UIStackViewDistributionFill;
    self.HumidWindStackView.axis = UILayoutConstraintAxisVertical;
    self.HumidWindStackView.alignment = UIStackViewAlignmentLeading;
    self.HumidWindStackView.spacing = 5;
    self.HumidWindStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ExpandedView addSubview:self.HumidWindStackView];
    
    self.activityButton = [[UIButton alloc]init];
    [self.activityButton setImage:[[UIImage imageNamed:@"activities"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.activityButton.contentMode = UIViewContentModeScaleAspectFit;
    self.activityButton.clipsToBounds = YES;
    self.activityButton.tintColor = UIColor.whiteColor;
    self.activityButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityButton addTarget:self action:@selector(didTapActivites:) forControlEvents:UIControlEventTouchUpInside];
    [self.ExpandedView addSubview:self.activityButton];
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
    
    self.windspeedLabel.text = [dayWeather getWindSpeedInString:dayWeather.windSpeed];
    [self.windspeedLabel sizeToFit];
    
    self.summaryLabel.text = dayWeather.summary;
    [self.summaryLabel sizeToFit];
    self.summaryLabel.numberOfLines = 0;
    [self.summaryLabel sizeToFit];
    [self.summaryLabel.heightAnchor constraintLessThanOrEqualToConstant:self.summaryLabel.frame.size.height+80].active = YES;
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

-(void)setConstraints{
    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [self.dateLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active=YES;
    [self.iconImageView.heightAnchor constraintEqualToConstant:37].active=YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor].active=YES;
    [self.iconImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.tempStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active =YES;
    [self.tempStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active=YES;
    
    //Constraints for Expanded View
    [self.ExpandedView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.ExpandedView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    
    // Activity Button constraints
    [self.activityButton.heightAnchor constraintEqualToConstant:25].active=YES;
    [self.activityButton.widthAnchor constraintEqualToAnchor:self.activityButton.heightAnchor].active=YES;
    [self.activityButton.trailingAnchor constraintEqualToAnchor:self.ExpandedView.trailingAnchor constant:-8].active = YES;
    [self.activityButton.topAnchor constraintEqualToAnchor:self.ExpandedView.topAnchor constant:8].active = YES;
//    [self.activityButton.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.ExpandedView.bottomAnchor constant:-8].active = YES;
    
    [self.summaryLabel.leadingAnchor constraintEqualToAnchor:self.ExpandedView.leadingAnchor constant:8].active = YES;
    [self.summaryLabel.trailingAnchor constraintEqualToAnchor:self.ExpandedView.trailingAnchor constant:-8].active = YES;
    
    [self.HumidWindStackView.leadingAnchor constraintEqualToAnchor:self.ExpandedView.leadingAnchor constant:8].active = YES;
    [self.HumidWindStackView.trailingAnchor constraintEqualToAnchor:self.ExpandedView.trailingAnchor constant:-8].active = YES;
    [self.HumidWindStackView.topAnchor constraintEqualToAnchor:self.ExpandedView.topAnchor constant:5].active = YES;
    [self.HumidWindStackView.bottomAnchor constraintEqualToAnchor:self.ExpandedView.bottomAnchor constant:-5].active = YES;
    
    // line
    [_lineView.topAnchor constraintEqualToAnchor:self.ExpandedView.topAnchor].active = YES;
    [_lineView.leadingAnchor constraintEqualToAnchor:self.ExpandedView.leadingAnchor constant:35].active = YES;
    [_lineView.trailingAnchor constraintEqualToAnchor:self.ExpandedView.trailingAnchor constant:-35].active = YES;
    [_lineView.heightAnchor constraintEqualToConstant:1].active = YES;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconImageView]-8-[expandedView]" options:0 metrics:nil views:@{@"iconImageView":_iconImageView, @"expandedView":self.ExpandedView}]];
}

- (IBAction)didTapActivites:(id)sender {
    [self.activitDelegate displayPopoverWithLocation:self.location weather:self.dayWeather index:0];
}

@end
