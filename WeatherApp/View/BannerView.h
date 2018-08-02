//
//  BannerView.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/1/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property (strong, nonatomic) UILabel *bannerLabel;

@property (strong, nonatomic) NSLayoutConstraint *bannerHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bannerHideConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bannerShowConstraint;

@property (strong, nonatomic) NSLayoutConstraint *labelWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *labelStartConstraint;
@property (strong, nonatomic) NSLayoutConstraint *labelEndConstraint;

- (instancetype) initWithMessage:(NSString *)message;
- (void) setBannerMessage:(NSString *)message;
- (void) setDefaultSuperviewConstraints;
- (void)animateBannerWithCompletion:(void(^)(BOOL finished))completion;
@end
