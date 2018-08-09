//
//  TodayActivitiesCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayActivitiesView.h"
#include <stdlib.h>

@implementation TodayActivitiesView
{
    UILabel *_suggestLabel;
    UIStackView *_activityIconStackView;
    NSArray *_activityCategory;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self initalizeProperties];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)setCurrentWeather:(Weather *)currentWeather {
    _currentWeather = currentWeather;
    _activityCategory = [Activity getActivityCategoryWithWeatherType:currentWeather.icon];
    
    if (_activityCategory) {
        int randIdx = arc4random_uniform((int)_activityCategory.count);
        NSString *randomActivity = _activityCategory[randIdx];
        _suggestLabel.text = [NSString stringWithFormat:@"It's a great day for a %@!", randomActivity];
    }
    else {
        
        _suggestLabel.text = @"Nothing to do...";
    }
    [_suggestLabel sizeToFit];
    
    [self refreshActivityStackView];
}

- (void) initalizeProperties {
    _suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 0, 0)];
    _suggestLabel.textColor = UIColor.whiteColor;
    _suggestLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_suggestLabel];
    
    _activityIconStackView = [[UIStackView alloc] init];
    _activityIconStackView.axis = UILayoutConstraintAxisHorizontal;
    _activityIconStackView.distribution = UIStackViewDistributionFillEqually;
    _activityIconStackView.alignment = UIStackViewAlignmentCenter;
    _activityIconStackView.spacing = 5;
    _activityIconStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_activityIconStackView];
    
    [self setConstraints];
}

-(void)refreshActivityStackView{
    // initalizing activity stack view
    if (_activityIconStackView.arrangedSubviews.count != 0) {
        for (UIView *arrSubView in _activityIconStackView.arrangedSubviews) {
            [arrSubView removeFromSuperview];
        }
    }
    
    for (NSString *category in _activityCategory) {
        UIButton *activityButton = [[UIButton alloc] init];
        activityButton.translatesAutoresizingMaskIntoConstraints = NO;
        [activityButton.heightAnchor constraintGreaterThanOrEqualToConstant:35].active = YES;
        [activityButton.widthAnchor constraintEqualToAnchor:activityButton.heightAnchor].active = YES;
        
        // Set button image
        UIImage *buttonImage =[[UIImage imageNamed:category] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        activityButton.clipsToBounds = YES;
        activityButton.tintColor = UIColor.whiteColor;
        activityButton.contentMode = UIViewContentModeScaleAspectFit;
        [activityButton setImage:buttonImage forState:UIControlStateNormal];
        
        // Set button border
        activityButton.layer.cornerRadius = 35.0/2.0;
        activityButton.layer.borderWidth = 2.0f;
        activityButton.layer.borderColor = UIColor.whiteColor.CGColor;
        
        // Set button insets
        float edgeInsets = activityButton.layer.cornerRadius /3;
        activityButton.imageEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);
        
        [activityButton addTarget:self action:@selector(onTapActivity:) forControlEvents:UIControlEventTouchUpInside];
        [_activityIconStackView addArrangedSubview:activityButton];
    }
}

- (void) setConstraints {
    [_suggestLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
    
    [_activityIconStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
    [_activityIconStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8].active = YES;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[suggestLabel]-8-[activityIconStackView]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"suggestLabel":_suggestLabel, @"activityIconStackView":_activityIconStackView}]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (IBAction)onTapActivity: (id)sender {
    int idx = (int)[_activityIconStackView.arrangedSubviews indexOfObject:sender];
    NSLog(@"%@ Tapped!", _activityCategory[idx]);
    [self.activityDelegate displayPopoverWithLocation:self.location weather:self.currentWeather index:idx];
}

@end
