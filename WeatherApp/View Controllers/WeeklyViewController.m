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

@interface WeeklyViewController () <UITableViewDelegate, UITableViewDataSource>

@property UITableView *tableView;
@property NSMutableArray *weeklyWeather;
@property Location *location;

@end

static int const numDaysInWeek = 7;
static NSString *cellIdentifier = @"WeeklyCell";

static bool loadData = NO;

@implementation WeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weeklyWeather = [[NSMutableArray alloc] init];
    
    self.location = [Location currentLocation]; //For testing purpose
    [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            [self.location setWeeklyDataWithDictionary:data];
            loadData = YES;
            [self.tableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];

    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass: WeeklyCell.class forCellReuseIdentifier:cellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
