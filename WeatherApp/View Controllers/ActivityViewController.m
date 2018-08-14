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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        self.currentActivityList = [[NSMutableArray alloc] init];
        [self setTableViewConstraint];
    }
    return self;
}

-(instancetype)initWithLocation:(Location*)loc weather:(Weather*)weather index:(int)idx{
    self = [self init];
    
    self.lat = loc.lattitude;
    self.lng = loc.longitude;
    self.weather = weather;
    self.category = [Activity getActivityCategoryWithWeatherType:weather.icon];
    
    [self initActivityButtons];
    [self setStackViewConstraint];
    
    UIButton *activityButton = self.activityButtons[idx];
    [activityButton setBackgroundColor:[UIColor.blueColor colorWithAlphaComponent:0.3]];
    [self getActivityDataType:self.category[idx]];
    
    return self;
}

-(void)getActivityDataType:(NSString*)type{
    [self.currentActivityList removeAllObjects];
    ActivityAPIManager *activityAPI = [ActivityAPIManager shared];
    [activityAPI getActivityDataWithLocation:@[@(self.lat), @(self.lng)] Type:type WithCompletion:^(NSDictionary *data, NSError *error) {
        if(error == nil){
            if (data.count == 0) {
                Activity *noResults = [[Activity alloc] init];
                noResults.name = @"Nothing Found";
                [self.currentActivityList addObject:noResults];
            }
            for(NSMutableDictionary *dict in data){
                [self.currentActivityList addObject:[[Activity alloc] initWithDictionary:dict]];
            }
            [self.tableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)initActivityButtons{
    int rowCount = 6;
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
            [activity.heightAnchor constraintLessThanOrEqualToConstant:buttonHeight].active = YES;
            [activity.widthAnchor constraintEqualToAnchor:activity.heightAnchor].active = YES;
            
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
        else [activity setBackgroundColor:[UIColor.blueColor colorWithAlphaComponent:0.3]];
    }
    [self getActivityDataType:selectedActivity.titleLabel.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentActivityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"activityCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    
    Activity *activity = self.currentActivityList[indexPath.row];
    cell.textLabel.text = activity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity *activity = self.currentActivityList[indexPath.row];
    if(activity.location && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *baseURL = @"comgooglemaps://";
        NSString *activityName = [activity.name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *url = [NSString stringWithFormat:@"%@?q=%@&center=%@,%@", baseURL,activityName, activity.location[0], activity.location[1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    else{
        NSLog(@"Unable to open Google Maps");
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[activityView]-8-[tableView]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"activityView":self.activityStack, @"tableView": self.tableView}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
