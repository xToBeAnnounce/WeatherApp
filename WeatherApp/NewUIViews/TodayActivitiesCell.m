//
//  TodayActivitiesCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayActivitiesCell.h"

@implementation TodayActivitiesCell
{
    UIView *_activitiesView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activitiesView = [[UIView alloc] init];
        _activitiesView.backgroundColor = UIColor.greenColor;
        [self addSubview:_activitiesView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    _activitiesView.frame = self.bounds;
    [super layoutSubviews];
}

@end
