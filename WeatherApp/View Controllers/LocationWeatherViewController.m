//
//  LocationWeatherViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationWeatherViewController.h"
#import "DailyViewController.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"
#import "DailyView.h"
#import "WeeklyView.h"
#import "NavigationController.h"

@interface LocationWeatherViewController ()
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong, nonatomic) UIButton *locationDetailsButton;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;


@end

@implementation LocationWeatherViewController
//DOESNOTHING

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton{
    [self setUI];
    self.location = location;
    
    self.DailyWeeklySC = DailyWeeklySC;
    self.DailyWeeklySC.selectedSegmentIndex = 0;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    [self selectedIndex];
    
    self.locationDetailsButton = locationsDetailsButton;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
}

- (void)setTempTypeString:(NSString *)tempTypeString {
    self.dailyView.tempType = tempTypeString;
    self.weeklyView.tempType = tempTypeString;
}

- (void) setUI {
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    self.dailyView = [[DailyView alloc]initWithFrame:self.view.frame];
    self.dailyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dailyView];
    
    self.weeklyView = [[WeeklyView alloc]initWithFrame:self.view.frame];
    self.weeklyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.weeklyView];
    
    [self setConstraintsForView:self.dailyView];
    [self setConstraintsForView:self.weeklyView];
}

- (void)setLocation:(Location *)location {
    _location = location;
    self.dailyView.location = location;
    self.weeklyView.location = location;
}

-(void)selectedIndex{
    self.dailyView.hidden = self.DailyWeeklySC.selectedSegmentIndex;
    self.weeklyView.hidden = !self.dailyView.hidden;
}

- (void) setConstraintsForView:(UIView *)view{
    [view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}
@end
