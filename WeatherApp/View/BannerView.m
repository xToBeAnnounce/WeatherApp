//
//  BannerView.m
//  WeatherApp
//
//  Created by Jamie Tan on 8/1/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "BannerView.h"

@implementation BannerView
{
    NSLayoutConstraint *_bannerHeightConstraint;
    NSLayoutConstraint *_bannerHideConstraint;
    NSLayoutConstraint *_bannerShowConstraint;
    
    NSLayoutConstraint *_labelWidthConstraint;
    NSLayoutConstraint *_labelStartConstraint;
    NSLayoutConstraint *_labelEndConstraint;
}

double readingTime;

/*------------------INIT FUNCTIONS------------------*/
// initalizes bannerlabel and sets some view properties
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bannerLabel = [[UILabel alloc] init];
        self.bannerLabel.font = [UIFont systemFontOfSize:20];
        self.bannerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bannerLabel];
        
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self setInternalConstraints];
        [self showAlert:NO];
    }
    return self;
}

// sets message of banner label after init
- (instancetype) initWithMessage:(NSString *)message{
    self = [self init];
    [self setBannerMessage:message];
    return self;
}

/*------------------CONSTRAINT METHODS------------------*/
// Set internal constraints for label and view
- (void) setInternalConstraints {
    // set banner height to adjust to label height
    _bannerHeightConstraint = [self.heightAnchor constraintEqualToAnchor:self.bannerLabel.heightAnchor constant:10];
    _bannerHeightConstraint.active = YES;
    
    [self.bannerLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    _labelStartConstraint = [self.bannerLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8];
    _labelStartConstraint.active = YES;
    
    _labelEndConstraint = [self.bannerLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8];
    _labelEndConstraint.active = NO;
}

// set banner constraints with regards to superview
- (void) setDefaultSuperviewConstraints{
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    
    _bannerHideConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
    _bannerShowConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
}

// Change constraints based on height of label
- (void) adjustLabelBasedConstraints {
    NSLayoutConstraint *oldWidthConstraint = _labelWidthConstraint;
    if (self.bannerLabel.frame.size.width > self.superview.frame.size.width-16) {
        self.bannerLabel.textAlignment = NSTextAlignmentLeft;
        _labelWidthConstraint = [self.bannerLabel.widthAnchor constraintEqualToConstant:self.bannerLabel.frame.size.width];
    }
    else {
        self.bannerLabel.textAlignment = NSTextAlignmentCenter;
        _labelWidthConstraint = [self.bannerLabel.widthAnchor constraintEqualToConstant:self.superview.frame.size.width-16];
    }
    oldWidthConstraint.active = NO;
    _labelWidthConstraint.active = YES;
}

/*------------------DISPLAY METHODS------------------*/
// sets text of bannerLabel and adjusts constraints/view accordingly
- (void) setBannerMessage:(NSString *)message{
    self.bannerLabel.text = message;
    [self.bannerLabel sizeToFit];
    
    readingTime = self.bannerLabel.frame.size.width/250;
    if (readingTime < 1.5) readingTime = 1.5;
    
    [self adjustLabelBasedConstraints];
}

// shows or hides the banner
- (void) showAlert:(BOOL)show {
    if (show) {
        _bannerHideConstraint.active = NO;
        _bannerShowConstraint.active = YES;
    }
    else {
        _bannerShowConstraint.active = NO;
        _bannerHideConstraint.active = YES;
    }
    self.alpha = (int)show;
    [self.superview layoutIfNeeded];
}

// Animates the banner
- (void)animateBannerWithCompletion:(void(^)(BOOL finished))completion {
    [self adjustLabelBasedConstraints];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self showAlert:YES];
        
    } completion:^(BOOL finished) {
        if (finished) {
            // After banner has appeared
            [UIView animateWithDuration:readingTime delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self->_labelStartConstraint.active = NO;
                self->_labelEndConstraint.active = YES;
                [self.superview layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                if (finished) {
                    // After label has finished
                    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        [self showAlert:NO];
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            self->_labelEndConstraint.active = NO;
                            self->_labelStartConstraint.active = YES;
                        }
                        if (completion) completion(finished);
                    }];
                }
            }];
        }
    }];
}
@end
