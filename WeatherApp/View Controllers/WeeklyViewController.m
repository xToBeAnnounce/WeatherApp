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

@interface WeeklyViewController () <UITableViewDelegate, UITableViewDataSource>
@property UITableView *tableView;
@property NSMutableArray *weeklyWeather;
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
    [self fetchWeeklyData:0];
 
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass: WeeklyCell.class forCellReuseIdentifier:cellIdentifier];
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
    [apiManager setURLWithLatitude:lat Longitude:lng Time:[currDate dateByAddingTimeInterval:(60*60*24*count)] Range:@"weekly"];
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
        NSDictionary *dailyDictionary = self.weeklyWeather[indexPath.row];
        NSArray *dailyData = dailyDictionary[@"daily"][@"data"];
        [cell setWeeklyCell:dailyData[0]];
    }
    return cell;
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
