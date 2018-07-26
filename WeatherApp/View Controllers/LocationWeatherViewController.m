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

@interface LocationWeatherViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;
@property (strong, nonatomic) NSString *tempType;

@end

static bool loadData = NO;
static bool loadWeeklyData = NO;
static NSString *WeeklycellIdentifier = @"WeeklyCell";
static NSString *DailycellIdentifier = @"WeeklyCell";

@implementation LocationWeatherViewController


- (instancetype) initWithLocation:(Location *)location {
    self.location = location;
    [self.dailyView setDailyUI:self.location];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromAPI];
    self.dailyView = [[DailyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.weeklyView = [[WeeklyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    
    self.dailyView.DailytableView.dataSource = self;
    self.dailyView.DailytableView.delegate = self;
    self.weeklyView.WeeklytableView.delegate = self;
    self.weeklyView.WeeklytableView.dataSource = self;
    
    
    self.DailyWeeklySC = (UISegmentedControl *)self.navigationController.navigationBar.topItem.titleView;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    
    self.dailyView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.dailyView]; 
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            [self.dailyView displayCurrentWeather:self.location];
            [self.dailyView.DailytableView reloadData];
            [self.weeklyView.WeeklytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)selectedIndex{
    if(self.DailyWeeklySC.selectedSegmentIndex == 0 ){
        NSLog(@"Daily");
        [self.weeklyView HideWeeklyData];
        [self.dailyView ShowDailyData];
    } else {
        NSLog(@"Weekly");
        [self.dailyView HideDailyData];
        [self.weeklyView ShowWeeklyData];
    }
}

-(void)getDataFromAPI{
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadData = YES;
            [self.dailyView displayCurrentWeather:self.location];
            [self.dailyView.DailytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadWeeklyData = YES;
            [self.weeklyView.WeeklytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

/*-----------------TABLE VIEW DELEGATE METHODS-----------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.dailyView.DailytableView]) {
        DailyTableViewCell *cell = [self.dailyView.DailytableView dequeueReusableCellWithIdentifier:DailycellIdentifier];
        if(cell == nil){
            cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DailycellIdentifier];
        }
        if(loadData){
            cell.tempType = self.tempType;
            Weather *hourlyWeather = self.location.dailyData[indexPath.row];
            cell.hourWeather = hourlyWeather;
        }
        return cell;
        
    }
    else if ([tableView isEqual:self.weeklyView.WeeklytableView]) {
        WeeklyCell *weeklycell = [self.weeklyView.WeeklytableView dequeueReusableCellWithIdentifier:WeeklycellIdentifier];
        if(weeklycell == nil){
            weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeeklycellIdentifier];
        }
        
        if(loadWeeklyData){
            weeklycell.tempType = self.tempType;
            Weather *dayWeather = self.location.weeklyData[indexPath.row];
            weeklycell.dayWeather = dayWeather;
        }
        
        return weeklycell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.dailyView.DailytableView] ){
        return self.location.dailyData.count;
    }
    return self.location.weeklyData.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.weeklyView.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dailyView.DailytableView deselectRowAtIndexPath:indexPath animated:YES];
}






@end
