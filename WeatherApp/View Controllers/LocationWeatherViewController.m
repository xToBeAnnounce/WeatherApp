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

@interface LocationWeatherViewController ()
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;


@end

@implementation LocationWeatherViewController


- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC {
    self.location = location;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.DailyWeeklySC = DailyWeeklySC;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    
    [self setUI];
    
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
            self.dailyView.tempType = pref.tempTypeString;
            [self.dailyView.DailytableView reloadData];
            
            self.weeklyView.tempType = pref.tempTypeString;
            [self.weeklyView.WeeklytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) setUI {
    self.dailyView = [[DailyView alloc]initWithFrame:self.view.frame];
    self.dailyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dailyView.location = self.location;
    [self.view addSubview:self.dailyView];
    [self setConstraintsForView:self.dailyView];
    
    self.weeklyView = [[WeeklyView alloc]initWithFrame:self.view.frame];
    self.weeklyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.weeklyView.location = self.location;
    [self.view addSubview:self.weeklyView];
    [self setConstraintsForView:self.weeklyView];
    
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    [self selectedIndex];
}

-(void)selectedIndex{
    if(self.DailyWeeklySC.selectedSegmentIndex == 0 ){
        NSLog(@"Daily");
        self.weeklyView.hidden = YES;
        self.dailyView.hidden = NO;
    } else {
        NSLog(@"Weekly");
        self.weeklyView.hidden = NO;
        self.dailyView.hidden = YES;
    }
}

- (void) setConstraintsForView:(UIView *)view{
    [view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}
@end
