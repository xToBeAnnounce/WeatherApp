//
//  LocationWeatherViewController.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Activity.h"
#import "NavigationController.h"
#import "BannerView.h"

@interface LocationWeatherViewController : UIViewController <ActivityDelegate>

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *tempTypeString;
@property (strong, nonatomic) id<NavigationDelegate>navDelegate;

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton;
- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion;
@end
