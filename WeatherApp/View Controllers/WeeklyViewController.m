//
//  WeeklyViewController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeklyViewController.h"
#import "WeeklyCell.h"
#import "APIManager.h"
#import "Location.h"
#import "Weather.h"

@interface WeeklyViewController () <UITableViewDelegate, UITableViewDataSource, LocationDelegate>
@property UITableView *tableView;
@property NSMutableArray *weeklyWeather;
@property Location *location;
@end

static int const numDaysInWeek = 7;
static NSString *cellIdentifier = @"WeeklyCell";

static float lat = 42.3601;
static float lng = -71.0589;
static bool loadData = NO;

@implementation WeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weeklyWeather = [[NSMutableArray alloc] init];
    self.location = [[Location alloc] init];
    [self.location fetchWeeklyData];
    //[self fetchWeeklyData:0];

    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.location.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass: WeeklyCell.class forCellReuseIdentifier:cellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchWeeklyData:(int)count{
    if(count == 7){
        loadData = YES;
        [self.tableView reloadData];
        return;
    }
    APIManager *apiManager = [APIManager shared];

    NSDate *currDate = [NSDate date];
    NSDate *nextDate = [currDate dateByAddingTimeInterval:(60*60*24*count)];

    [apiManager setURLWithLatitude:lat Longitude:lng Time:nextDate Range:@"weekly"];
    [apiManager getDataWithCompletion:^(NSDictionary *data, NSError *error) {
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.weeklyWeather addObject:[[NSDictionary alloc]initWithDictionary:data]];
            [self fetchWeeklyData:count+1];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numDaysInWeek;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeeklyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WeeklyCell"];
    if(cell == nil){
        cell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(loadData){
        Weather *dailyWeather = self.location.weeklyData[indexPath.row];
//        NSArray *dailyData = dailyDictionary[@"daily"][@"data"];
        [cell setWeeklyCell:dailyWeather];
    }
    return cell;
}

- (void)reloadDataTableView{
    loadData = YES;
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
