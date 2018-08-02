//
//  BannerView.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/1/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "BannerView.h"

@implementation BannerView

double readingTime;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bannerLabel = [[UILabel alloc] init];
        self.bannerLabel.font = [UIFont systemFontOfSize:20];
        self.bannerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bannerLabel];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self setInternalConstraints];
        [self showAlert:NO];
    }
    return self;
}

- (instancetype) initWithMessage:(NSString *)message{
    self = [self init];
    [self setBannerMessage:message];
    return self;
}

- (void) setBannerMessage:(NSString *)message{
    self.bannerLabel.text = message;
    [self.bannerLabel sizeToFit];
    
    readingTime = self.bannerLabel.frame.size.width/300;
    if (readingTime < 1.5) readingTime = 1.5;
    
    [self adjustLabelBasedConstraints];
}

- (void) setInternalConstraints {
    [self.bannerLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.bannerHeightConstraint = [self.heightAnchor constraintEqualToAnchor:self.bannerLabel.heightAnchor constant:10];
    self.bannerHeightConstraint.active = YES;
    
    self.labelStartConstraint = [self.bannerLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8];
    self.labelStartConstraint.active = YES;
    
    self.labelEndConstraint = [self.bannerLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8];
    self.labelEndConstraint.active = NO;
}


- (void) setDefaultSuperviewConstraints{
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    
    self.bannerHideConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
    self.bannerShowConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
}

- (void) adjustLabelBasedConstraints {
    NSLayoutConstraint *oldWidthConstraint = self.labelWidthConstraint;
    if (self.bannerLabel.frame.size.width > self.superview.frame.size.width-16) {
        self.bannerLabel.textAlignment = NSTextAlignmentLeft;
        self.labelWidthConstraint = [self.bannerLabel.widthAnchor constraintEqualToConstant:self.bannerLabel.frame.size.width];
    }
    else {
        self.bannerLabel.textAlignment = NSTextAlignmentCenter;
        self.labelWidthConstraint = [self.bannerLabel.widthAnchor constraintEqualToConstant:self.superview.frame.size.width-16];
    }
    oldWidthConstraint.active = NO;
    self.labelWidthConstraint.active = YES;
}

- (void) showAlert:(BOOL)show {
    if (show) {
        self.bannerHideConstraint.active = NO;
        self.bannerShowConstraint.active = YES;
    }
    else {
        self.bannerShowConstraint.active = NO;
        self.bannerHideConstraint.active = YES;
    }
    self.alpha = (int)show;
    [self.superview layoutIfNeeded];
}

- (void)animateBannerWithCompletion:(void(^)(BOOL finished))completion {
    [self adjustLabelBasedConstraints];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self showAlert:YES];
        
    } completion:^(BOOL finished) {
        if (finished) {
            // After banner has appeared
            [UIView animateWithDuration:readingTime delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.labelStartConstraint.active = NO;
                self.labelEndConstraint.active = YES;
                [self.superview layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                if (finished) {
                    // After label has finished
                    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        [self showAlert:NO];
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            self.labelEndConstraint.active = NO;
                            self.labelStartConstraint.active = YES;
                        }
                        if (completion) completion(finished);
                    }];
                }
            }];
        }
    }];
}
@end
