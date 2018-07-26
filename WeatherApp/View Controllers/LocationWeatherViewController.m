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
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;
@property (strong,nonatomic) NavigationController *navController;


@end

@implementation LocationWeatherViewController


- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC {
    self.location = location;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.DailyWeeklySC = DailyWeeklySC;
    self.DailyWeeklySC.selectedSegmentIndex = 0;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    
    [self setUI];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    self.navController = [[NavigationController alloc]init];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void) setUI {
    
    self.dailyView = [[DailyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.weeklyView = [[WeeklyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.weeklyView.location = self.location;
    self.dailyView.location = self.location;
    
    [self.view addSubview:self.dailyView];
    [self.view addSubview:self.weeklyView];
    
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
@end
