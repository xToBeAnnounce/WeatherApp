//
//  LocationWeatherViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationWeatherViewController.h"
#import "NavigationController.h"
#import "User.h"
#import "ActivityViewController.h"
#import "DailyView.h"
#import "WeeklyView.h"
#import "WeatherView.h"

@interface LocationWeatherViewController () <UIPopoverPresentationControllerDelegate>
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong, nonatomic) UIButton *locationDetailsButton;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;
@property (strong,nonatomic) WeatherView *weatherView;
@end

@implementation LocationWeatherViewController
{
    UIVisualEffectView *_blurEffectView;
}

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton{
    [self setSubviews];
    self.location = location;
    
    self.DailyWeeklySC = DailyWeeklySC;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    [self selectedIndex];
    
    self.locationDetailsButton = locationsDetailsButton;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.bounds;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.weeklyView.selectedCell = nil;
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempTypeString = pref.tempTypeString;
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.locationDetailsButton.hidden = !self.location.objectId;
    
    if (!self.weeklyView.hidden) {
        [self showBannerIfNeededWithCompletion:nil];
    }
}

- (void)setTempTypeString:(NSString *)tempTypeString {
    _tempTypeString = tempTypeString;
    self.dailyView.tempType = tempTypeString;
    self.weeklyView.tempType = tempTypeString;
}

- (void) setSubviews {
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
//
//    self.dailyView = [[DailyView alloc]initWithFrame:self.view.frame];
//    self.dailyView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.dailyView];
//
//    self.weeklyView = [[WeeklyView alloc]initWithFrame:self.view.frame];
//    self.weeklyView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.weeklyView.delegate = self;
//    [self.view addSubview:self.weeklyView];
//
//    [self setConstraintsForView:self.dailyView];
//    [self setConstraintsForView:self.weeklyView];
    
    self.weatherView = [[WeatherView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.weatherView];
    
    
}

- (void)setLocation:(Location *)location {
    _location = location;
//    self.dailyView.location = location;
//    self.weeklyView.location = location;
    self.weatherView.location = location;
}

-(void)displayPopoverWithLocation:(Location*)loc Weather:(Weather*)weather{
    ActivityViewController *popoverView = [[ActivityViewController alloc] initWithLocation:loc Weather:weather];
    popoverView.modalPresentationStyle = UIModalPresentationPopover;
    popoverView.preferredContentSize = CGSizeMake(self.weeklyView.bounds.size.width-50, self.weeklyView.bounds.size.height-150);
    
    UIPopoverPresentationController *popController = popoverView.popoverPresentationController;
    popController.delegate = self;
    popController.sourceView = (UIView*)self.weeklyView;
    popController.sourceRect = CGRectMake(self.weeklyView.bounds.size.width/2, self.weeklyView.bounds.size.height/2, 1, 1);
    popController.permittedArrowDirections = 0;
    
    [self.view addSubview:_blurEffectView];
    [self presentViewController:popoverView animated:YES completion:nil];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [_blurEffectView removeFromSuperview];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(void)selectedIndex {
    self.dailyView.hidden = self.DailyWeeklySC.selectedSegmentIndex;
    self.weeklyView.hidden = !self.dailyView.hidden;
}

- (void) setConstraintsForView:(UIView *)view{
    [view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion{
    [self.weeklyView showBannerIfNeededWithCompletion:completion];
}
@end
