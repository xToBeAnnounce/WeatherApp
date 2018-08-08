//
//  WeatherCardCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherCardCell.h"

@implementation WeatherCardCell
{
    UILabel *_titleLabel;
}

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view {
    self = [super init];
    if (self) {
        [self initalizeCard];
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        
        [self.customView addSubview:view];
    }
    return self;
}

// initalizes title label properties and custom view properties
- (void) initalizeCard {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    self.customView = [[UIView alloc] init];
    self.customView.backgroundColor = nil;
    [self addSubview:self.customView];
}
@end
