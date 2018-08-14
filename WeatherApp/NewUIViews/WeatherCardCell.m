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
    CGFloat _mainViewWidth;
    UIVisualEffectView *_blureffectView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = nil;
        [self initalizeCard];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
}

- (void)setTitle:(NSString *)title withView:(UIView *)view {
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    for (UIView *subview in self.customView.subviews) {
        [subview removeFromSuperview];
    }
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view setNeedsLayout];
    [self.customView addSubview:view];
    
    [self.customView.heightAnchor constraintEqualToAnchor:view.heightAnchor].active = YES;
    
    [view.topAnchor constraintEqualToAnchor:self.customView.topAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.customView.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.customView.trailingAnchor].active = YES;
}

- (void)setTitle:(NSString *)title withView:(UIView *)view Width:(CGFloat)width{
    _mainViewWidth = width;
    [self setTitle:title withView:view];
    [self.contentView.widthAnchor constraintEqualToConstant:_mainViewWidth].active = YES;
}

// initalizes title label properties and custom view properties
- (void) initalizeCard {
    _cardView = [[UIView alloc] init];
    _cardView.translatesAutoresizingMaskIntoConstraints = NO;

    _cardView.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
    _cardView.layer.cornerRadius = 10;
    [self.contentView addSubview:_cardView];
    
    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blureffectView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
    _blureffectView.alpha = 0.7;
    _blureffectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _blureffectView.translatesAutoresizingMaskIntoConstraints = NO;
    _blureffectView.layer.cornerRadius = 10;
    [_cardView addSubview:_blureffectView];
    
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
    self.customView.layer.cornerRadius = 10;
    self.customView.clipsToBounds = YES;
    self.customView.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardView addSubview:self.customView];
    
    [self setConstraints];
}

- (void) setConstraints {
    // card
    [_cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [_cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
    
    [_blureffectView.topAnchor constraintEqualToAnchor:_cardView.topAnchor].active = YES;
    [_blureffectView.bottomAnchor constraintEqualToAnchor:_cardView.bottomAnchor].active = YES;
    [_blureffectView.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor].active = YES;
    [_blureffectView.trailingAnchor constraintEqualToAnchor:_cardView.trailingAnchor].active = YES;

    // title
    [_titleLabel.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    
    // line
    [_lineView.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    [_lineView.trailingAnchor constraintEqualToAnchor:_cardView.trailingAnchor constant:-8].active = YES;
    [_lineView.heightAnchor constraintEqualToConstant:2].active = YES;
    
    // customview
    [self.customView.leadingAnchor constraintEqualToAnchor:_cardView.leadingAnchor constant:8].active = YES;
    [self.customView.trailingAnchor constraintEqualToAnchor:_cardView.trailingAnchor constant:-8].active = YES;
    
    [_cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel]-5-[lineView]-5-[customView]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"titleLabel":_titleLabel, @"lineView":_lineView, @"customView":self.customView}]];
}

- (void)setCardBackgroundColor:(UIColor *)backgroundColor {
    _cardView.backgroundColor = backgroundColor;
}
          
@end
