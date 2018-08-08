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
    UIView *_cardView;
    UILabel *_titleLabel;
    UIView *_lineView;
}

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view {
    self = [super init];
    if (self) {
        self.backgroundColor = nil;
        [self initalizeCard];
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        
        [self.customView addSubview:view];
    }
    return self;
}

- (void)setTitle:(NSString *)title withView:(UIView *)view {
    self.backgroundColor = nil;
    [self initalizeCard];
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.customView addSubview:view];
    
    [view.topAnchor constraintEqualToAnchor:self.customView.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:self.customView.bottomAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.customView.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.customView.trailingAnchor].active = YES;
    [self.customView.heightAnchor constraintEqualToAnchor:view.heightAnchor].active = YES;
    
}

// initalizes title label properties and custom view properties
- (void) initalizeCard {
    _cardView = [[UIView alloc] init];
    _cardView.translatesAutoresizingMaskIntoConstraints = NO;
    _cardView.backgroundColor = UIColor.blueColor;
    _cardView.layer.cornerRadius = 5;
    [self addSubview:_cardView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColor.whiteColor;
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardView addSubview:_lineView];
    
    self.customView = [[UIView alloc] init];
    self.customView.backgroundColor = UIColor.clearColor;
    self.customView.clipsToBounds = YES;
    self.customView.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardView addSubview:self.customView];
    
    [self setConstraints];
}

- (void) setConstraints {
    // card
    [_cardView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_cardView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_cardView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8].active = YES;
    [_cardView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8].active = YES;
    
    // title
    [_titleLabel.topAnchor constraintEqualToAnchor:_cardView.topAnchor constant:8].active = YES;
    [_titleLabel.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    
    // line
    [_lineView.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    [_lineView.trailingAnchor constraintEqualToAnchor:_cardView.trailingAnchor constant:-8].active = YES;
    [_lineView.heightAnchor constraintEqualToConstant:2].active = YES;
    
    // customview
    [self.customView.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    [self.customView.trailingAnchor constraintEqualToAnchor:_cardView.trailingAnchor constant:-8].active = YES;
    [self.customView.bottomAnchor constraintEqualToAnchor:_cardView.bottomAnchor constant:-8].active = YES;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[lineView]-5-[customView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"titleLabel":_titleLabel, @"lineView":_lineView, @"customView":self.customView,}]];
}

- (void)setCardBackgroundColor:(UIColor *)backgroundColor {
    _cardView.backgroundColor = backgroundColor;
}
@end
