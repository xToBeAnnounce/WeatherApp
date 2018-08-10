//
//  HourlyCollectionCell.m
//  WeatherApp
//
//  Created by Tiffany Ma on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HourlyCollectionCell.h"

@implementation HourlyCollectionCell

{
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UILabel *_temperatureLabel;
    UIStackView *_hourlyStackView;
    UIVisualEffectView *_blureffectView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizeLabels];
        [self setCellBackground];
        [self setLabelConstraints];
    }
    return self;
}

-(void)initalizeLabels{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _iconView = [[UIImageView alloc] init];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _temperatureLabel = [[UILabel alloc] init];
    _temperatureLabel.font = [UIFont systemFontOfSize:20];
    _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)setLabelConstraints{
    [_iconView.heightAnchor constraintEqualToConstant:50].active = YES;
    [_iconView.widthAnchor constraintEqualToConstant:50].active = YES;
    
    NSArray *arrangedViews = @[_timeLabel, _iconView, _temperatureLabel];
    _hourlyStackView = [[UIStackView alloc] initWithArrangedSubviews: arrangedViews];
    _hourlyStackView.axis = UILayoutConstraintAxisVertical;
    _hourlyStackView.distribution = UIStackViewDistributionFillProportionally;
    _hourlyStackView.alignment = UIStackViewAlignmentCenter;
    _hourlyStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_hourlyStackView];
    
    [_hourlyStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_hourlyStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
}

-(void)setCellBackground{
    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blureffectView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
    _blureffectView.alpha = 0.3;
    _blureffectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _blureffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_blureffectView];
    
    [_blureffectView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_blureffectView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
//    [_blureffectView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
//    [_blureffectView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
}

- (void)setWeather:(Weather *)weather{
    _weather = weather;
    _timeLabel.text = [weather getHourInDayWithTime:weather.time];
    [_timeLabel sizeToFit];
    
    _iconView.image = [UIImage imageNamed:weather.icon];
    
    _temperatureLabel.text = [weather getTempInString:weather.temperature];
    [_temperatureLabel sizeToFit];
    
    [_blureffectView.widthAnchor constraintEqualToAnchor:_hourlyStackView.widthAnchor].active = YES;
    [_blureffectView.heightAnchor constraintEqualToAnchor:_hourlyStackView.heightAnchor].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor:_hourlyStackView.widthAnchor].active = YES;
    [self.contentView.heightAnchor constraintEqualToAnchor:_hourlyStackView.heightAnchor].active = YES;

//    NSArray<__kindof NSLayoutConstraint *> *widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stackView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"stackView":_hourlyStackView}];
//    NSArray<__kindof NSLayoutConstraint *> *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[stackView]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"stackView":_hourlyStackView}];
//
//    [self.contentView addConstraints:widthConstraint];
//    [self.contentView addConstraints:heightConstraint];
}

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
//
//    UICollectionViewLayoutAttributes *autoLayoutAttributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
//    CGSize targetSize = CGSizeMake(_hourlyStackView.frame.size.width, _hourlyStackView.frame.size.height);
//    CGSize autoLayoutSize = [self.contentView systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow];
//    CGRect autoLayoutFrame = CGRectMake(autoLayoutAttributes.frame.origin.x, autoLayoutAttributes.frame.origin.y, autoLayoutSize.width, autoLayoutSize.height);
//    autoLayoutAttributes.frame = autoLayoutFrame;
//    return autoLayoutAttributes;
//}

@end
