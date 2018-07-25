//
//  DailyViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyViewController.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"

@interface DailyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *currentWeatherView;
@property (strong, nonatomic) UITableView *WeeklytableView;
@property (strong, nonatomic) NSString *tempType;
@property (strong,nonatomic) UITableView *DailytableView;
@property (strong, nonatomic) UIStackView *weatherDisplayStackView;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UILabel *customNameLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property BOOL selectedView;
@end

static bool loadData = NO;
static NSString *cellIdentifier = @"WeeklyCell";
static bool loadWeeklyData = NO;

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWeeklyUI];
    self.WeeklytableView.hidden = YES;
    self.DailyWeeklySC = (UISegmentedControl *)self.navigationController.navigationBar.topItem.titleView;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
   
    self.location = [Location currentLocation];
    [self setUI];
    
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadData = YES;
            [self displayCurrentWeather];
            [self.DailytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadWeeklyData = YES;
            [self.WeeklytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    [self setWeeklyConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            [self displayCurrentWeather];
            [self.DailytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            [self.WeeklytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*--------------------SETS DAILY UI--------------------*/
-(void)setUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //sets table view
    CGFloat yorigin = self.view.frame.origin.y + self.view.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.view.frame.origin.x, yorigin, self.view.frame.size.width, self.view.frame.size.height/2 - 50);
    self.DailytableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    self.DailytableView.delegate = self;
    self.DailytableView.dataSource = self;
    [self.DailytableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"DailyTableViewCell"];
    
    self.DailytableView.estimatedRowHeight = 44.0;
    self.DailytableView.rowHeight = UITableViewAutomaticDimension;
    self.DailytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.DailytableView];
    
    self.currentWeatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    [self.view addSubview:self.currentWeatherView];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.currentWeatherView.frame];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;

    self.backgroundImageView.image = [UIImage imageNamed:@"sunnybackground"];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeatherView addSubview:self.backgroundImageView];
    
    //setting up customNameLabel
    self.customNameLabel = [[UILabel alloc]init];
    self.customNameLabel.font = [UIFont systemFontOfSize:35];
    self.customNameLabel.text = self.location.customName;
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:17];
//    self.locationLabel.textColor = [UIColor whiteColor];
//    self.locationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.locationLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    self.locationLabel.layer.shadowOpacity = 0.6;
//    self.locationLabel.layer.shadowRadius = 2.0;
//    self.locationLabel.layer.masksToBounds = NO;
    self.locationLabel.text = @"---";
    
    //setting up icon image view
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //setting up temperatureLabel
    self.temperatureLabel = [[UILabel alloc]init];
    self.temperatureLabel.font = [UIFont systemFontOfSize:60 weight:UIFontWeightThin];
    self.temperatureLabel.text = @"--°";
    
    NSArray *weatherDisplayArray = @[self.customNameLabel,self.locationLabel, self.iconImageView, self.temperatureLabel];
    self.weatherDisplayStackView = [[UIStackView alloc] initWithArrangedSubviews:weatherDisplayArray];
    self.weatherDisplayStackView.axis = UILayoutConstraintAxisVertical;
    self.weatherDisplayStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.weatherDisplayStackView.alignment = UIStackViewAlignmentCenter;
    self.weatherDisplayStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeatherView addSubview:self.weatherDisplayStackView];

    [self setConstraints];
}

- (void) displayCurrentWeather {
    Weather *currentWeather;
    if (self.location.dailyData.count) currentWeather = self.location.dailyData[0];
    
    self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    self.temperatureLabel.text = [currentWeather getTempInString:currentWeather.temperature withType:self.tempType];
    [self.temperatureLabel sizeToFit];
    
    if ([self.location.customName isEqualToString:@"Current Location"]) {
        [self.location updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
            if (data) {
                self.locationLabel.text = self.location.placeName;
                [self.locationLabel sizeToFit];
            }
        }];
    }
    else if ([self.location.placeName isEqualToString:self.location.customName]) {
        self.customNameLabel.font = [UIFont systemFontOfSize:45];
        [self.locationLabel removeFromSuperview];
    }
    else {
        self.locationLabel.text = self.location.placeName;
        [self.locationLabel sizeToFit];
    }
}

- (void) setConstraints {
    // background image constraints
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.currentWeatherView.topAnchor].active = YES;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.currentWeatherView.bottomAnchor].active = YES;
    [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.currentWeatherView.leadingAnchor].active = YES;
    [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.currentWeatherView.trailingAnchor].active = YES;
    
    // stack view constraints
    [self.weatherDisplayStackView.centerXAnchor constraintEqualToAnchor:self.currentWeatherView.centerXAnchor].active = YES;
    [self.weatherDisplayStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.weatherDisplayStackView.bottomAnchor constraintEqualToAnchor:self.currentWeatherView.bottomAnchor constant:-8].active = YES;

    // icon contstraints
    [self.iconImageView.heightAnchor constraintEqualToAnchor:self.currentWeatherView.heightAnchor multiplier:3.0/7.0].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    
    // constraint between tableview and current weather view
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[weatherView]-0-[tableView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"weatherView":self.currentWeatherView, @"tableView":self.DailytableView}]];
    
    // table view constraints
    [self.DailytableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.DailytableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.DailytableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

/*-----------------TABLE VIEW DELEGATE METHODS-----------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.DailytableView]) {
        DailyTableViewCell *cell = [self.DailytableView dequeueReusableCellWithIdentifier:@"DailyTableViewCell"];
            if(cell == nil){
                cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DailyTableViewCell"];
            }
            if(loadData){
                cell.tempType = self.tempType;
                Weather *hourlyWeather = self.location.dailyData[indexPath.row];
                cell.hourWeather = hourlyWeather;
            }
        return cell;
    
    }
    else if ([tableView isEqual:self.WeeklytableView]) {
        WeeklyCell *weeklycell = [self.WeeklytableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(weeklycell == nil){
            weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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

- (void)reloadDataTableView{
    loadWeeklyData = YES;
    [self.WeeklytableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.DailytableView] ){
        return self.location.dailyData.count;
    }
    return self.location.weeklyData.count;
}

-(void)selectedIndex{
    if(self.DailyWeeklySC.selectedSegmentIndex == 0 ){
        NSLog(@"Daily");
        [self HideWeeklyData];
    } else {
         NSLog(@"Weekly");
        [self HideDailyData];
    }
}


/*-----------------------------SETS WEEKLY UI-----------------------------------------*/
-(void)setWeeklyUI{
    self.WeeklytableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.WeeklytableView.dataSource = self;
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.estimatedRowHeight = 50;
    self.WeeklytableView.rowHeight = UITableViewAutomaticDimension;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:cellIdentifier];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.DailytableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

-(void)HideDailyData{
    self.temperatureLabel.hidden = YES;
    self.backgroundImageView.hidden = YES;
    self.customNameLabel.hidden = YES;
    self.locationLabel.hidden = YES;
    self.iconImageView.hidden = YES;
    self.currentWeatherView.hidden = YES;
    self.DailytableView.hidden = YES;
    self.weatherDisplayStackView.hidden = YES;
    self.WeeklytableView.hidden = NO;
    [self reloadDataTableView];
    [self.WeeklytableView reloadData];
}

-(void)HideWeeklyData{
    self.temperatureLabel.hidden = NO;
    self.backgroundImageView.hidden = NO;
    self.customNameLabel.hidden = NO;
    self.locationLabel.hidden = NO;
    self.iconImageView.hidden = NO;
    self.currentWeatherView.hidden = NO;
    self.DailytableView.hidden = NO;
    self.weatherDisplayStackView.hidden = NO;
    self.WeeklytableView.hidden = YES;
    [self.DailytableView reloadData];
}



@end
