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
#import <QuartzCore/QuartzCore.h>

@interface ActivityViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *currentActivityList;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSMutableArray *activityButtons;
@property (nonatomic) double lat;
@property (nonatomic) double lng;

@property (strong, nonatomic) Weather *weather;
@property (strong, nonatomic) UIStackView *activityStack;
@end

@implementation ActivityViewController

int buttonHeight = 45;

-(instancetype)initWithLocation:(Location*)loc Weather:(Weather*)weather{
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.lat = loc.lattitude;
    self.lng = loc.longitude;
    self.weather = weather;
    self.category = [[NSArray alloc] init];
    self.currentActivityList = [[NSMutableArray alloc] init];
    
    [self setActivityCategoryWithWeatherType:weather.icon];
    [self getActivityDataType:self.category[0]];
    
    [self initActivityButtons];
    [self setTableViewConstraint];
    [self setStackViewConstraint];
    
    return self;
}

-(void)setActivityCategoryWithWeatherType:(NSString*)weatherCondition{
    if([weatherCondition rangeOfString:@"clear"].location != NSNotFound){
        self.category = @[@"attractions", @"park", @"trails", @"resturant", @"cafe"];
    }
    else if([weatherCondition rangeOfString:@"cloud"].location != NSNotFound ||
            [weatherCondition rangeOfString:@"rain"].location != NSNotFound){
        self.category = @[@"clothing_store", @"library", @"movie_theater", @"shopping_mall", @"cafe", @"resturant"];
    }
}

-(void)getActivityDataType:(NSString*)type{
    [self.currentActivityList removeAllObjects];
    ActivityAPIManager *activityAPI = [ActivityAPIManager shared];
    [activityAPI getActivityDataWithLocation:@[@(self.lat), @(self.lng)] Type:type WithCompletion:^(NSDictionary *data, NSError *error) {
        if(error == nil){
            for(NSMutableDictionary *dict in data){
                [self.currentActivityList addObject:[[Activity alloc] initWithDictionary:dict]];
            }
            [self.tableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)initActivityButtons{
    int rowCount = 5;
    self.activityStack = [[UIStackView alloc] init];
    self.activityStack.axis = UILayoutConstraintAxisVertical;
    self.activityStack.distribution = UIStackViewDistributionFill;
    self.activityStack.alignment = UIStackViewAlignmentCenter;
    self.activityStack.spacing = 5;
    self.activityButtons = [[NSMutableArray alloc] init];
    
    for(int i=0; i<((self.category.count + rowCount-1) / rowCount); i++){
        UIStackView *rowStack = [[UIStackView alloc] init];
        rowStack.translatesAutoresizingMaskIntoConstraints = NO;
        rowStack.axis = UILayoutConstraintAxisHorizontal;
        rowStack.distribution = UIStackViewDistributionEqualSpacing;
        rowStack.alignment = UIStackViewAlignmentCenter;
        rowStack.spacing = 15;
        
        for(int j=0; j<rowCount; j++){
            if(rowCount*i + j == self.category.count) break;
            NSString *title = self.category[rowCount*i + j];
            UIButton *activity = [[UIButton alloc] init];
            
            [activity setTitle:title forState:UIControlStateNormal];
            activity.translatesAutoresizingMaskIntoConstraints = NO;
            [activity.heightAnchor constraintEqualToConstant:buttonHeight].active = YES;
            [activity.widthAnchor constraintEqualToConstant:buttonHeight].active = YES;
            
            [activity setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
            activity.layer.borderWidth = 2.0f;
            activity.layer.borderColor = UIColor.whiteColor.CGColor;
            activity.layer.cornerRadius = buttonHeight/2;
            
            activity.clipsToBounds = YES;
            activity.contentMode = UIViewContentModeScaleAspectFit;
            float edgeInsets = activity.layer.cornerRadius / 3;
            activity.imageEdgeInsets = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets);
            
            [activity addTarget:self action:@selector(onSelectActivity:) forControlEvents:UIControlEventTouchUpInside];
            [rowStack addArrangedSubview:activity];
            [self.activityButtons addObject:activity];
        }
        [self.activityStack addArrangedSubview:rowStack];
    }
    [self.view addSubview:self.activityStack];
}

-(IBAction)onSelectActivity:(id)sender{
    UIButton *selectedActivity = (UIButton*)sender;
    for(UIButton *activity in self.activityButtons){
        if(![activity isEqual:selectedActivity])
            [activity setBackgroundColor:UIColor.clearColor];
        else
            [activity setBackgroundColor:UIColor.blueColor];
    }
    [self getActivityDataType:selectedActivity.titleLabel.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentActivityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    Activity *activity = self.currentActivityList[indexPath.row];
    cell.textLabel.text = activity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity *activity = self.currentActivityList[indexPath.row];
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
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

-(void)setStackViewConstraint{
    self.activityStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.activityStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[activityView]-10-[tableView]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"activityView":self.activityStack, @"tableView": self.tableView}]];
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
