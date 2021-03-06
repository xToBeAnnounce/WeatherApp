//
//  Weekly.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "LocationWeatherViewController.h"
#import "BannerView.h"

@interface WeeklyView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *WeeklytableView;
@property (strong,nonatomic) Location *location;
@property (strong, nonatomic) NSString *tempType;
@property (strong,nonatomic) UIVisualEffectView *BlurView;

@property (strong, nonatomic) NSString *bannerMessage;

@property (strong, nonatomic) NSIndexPath *selectedCell;

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion;

/* Activity Properties */
@property (strong, nonatomic) id<ActivityDelegate> activityDelegate;
@end
