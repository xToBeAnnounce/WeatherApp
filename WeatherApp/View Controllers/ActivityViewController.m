//
//  ActivityViewController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/27/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "ActivityAPIManager.h"

@interface ActivityViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *activities;
@end

@implementation ActivityViewController

-(instancetype)initWithLocation:(NSArray*)loc Type:(NSString*)type{
    self.activities = [[NSMutableArray alloc] init];
    [self getActivityDataWithLocation:loc Type:type];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setTableViewConstraint];
    return self;
}

-(void)getActivityDataWithLocation:(NSArray*)loc Type:(NSString*)type{
    //Parameters not placed in use yet
    ActivityAPIManager *activityAPI = [ActivityAPIManager shared];
    [activityAPI getActivityDataWithLocation:loc Type:type WithCompletion:^(NSDictionary *data, NSError *error) {
        if(error == nil){
            for(NSMutableDictionary *dict in data){
                [self.activities addObject:[[Activity alloc] initWithDictionary:dict]];
            }
            [self.tableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    Activity *activity = self.activities[indexPath.row];
    cell.textLabel.text = activity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity *activity = self.activities[indexPath.row];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *baseURL = @"comgooglemaps://";
        NSString *activityName = [activity.name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *url = [NSString stringWithFormat:@"%@?q=%@&center=%@,%@", baseURL,activityName, activity.location[0], activity.location[1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    else{
        NSLog(@"Unable to open Google Maps");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setTableViewConstraint{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
