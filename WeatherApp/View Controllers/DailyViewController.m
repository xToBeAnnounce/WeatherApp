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

@interface DailyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *currentWeatherView;
@property (strong, nonatomic) UIStackView *weatherDisplayStackView;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;

@end

static bool loadData = NO;

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    self.location = [Location currentLocation];
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadData = YES;
            [self displayCurrentWeather];
            [self.ourtableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //sets table view
    CGFloat yorigin = self.view.frame.origin.y + self.view.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.view.frame.origin.x, yorigin, self.view.frame.size.width, self.view.frame.size.height/2);
    self.ourtableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    self.ourtableView.delegate = self;
    self.ourtableView.dataSource = self;
    [self.ourtableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"DailyTableViewCell"];
    
    self.ourtableView.estimatedRowHeight = 44.0;
    self.ourtableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.ourtableView];
    
    self.currentWeatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    [self.view addSubview:self.currentWeatherView];
    
    //setting up background images
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.currentWeatherView.frame];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.image = [UIImage imageNamed:@"sunnybackground"];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeatherView addSubview:self.backgroundImageView];
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 10, 10)];
    self.locationLabel.font = [UIFont systemFontOfSize:35];
    self.locationLabel.text = @"--";
    
    //setting up icon image view
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 90, 166, 166)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //setting up temperatureLabel
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 250, 0, 0)];
    self.temperatureLabel.font = [UIFont systemFontOfSize:60 weight:UIFontWeightThin];
    
    NSArray *weatherDisplayArray = @[self.locationLabel, self.iconImageView, self.temperatureLabel];
    self.weatherDisplayStackView = [[UIStackView alloc] initWithArrangedSubviews:weatherDisplayArray];
    self.weatherDisplayStackView.axis = UILayoutConstraintAxisVertical;
    self.weatherDisplayStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.weatherDisplayStackView.alignment = UIStackViewAlignmentCenter;
    self.weatherDisplayStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeatherView addSubview:self.weatherDisplayStackView];
    
    [self setConstraints];
}

- (void) displayCurrentWeather {
    Weather *currentWeather = self.location.dailyData[0];
    
    self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    NSString *temp = [currentWeather getTempInString:currentWeather.temperature];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f", temp.floatValue];
    [self.temperatureLabel sizeToFit];
    
    [self.location updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            self.locationLabel.text = self.location.placeName;
            [self.locationLabel sizeToFit];
        }
    }];
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
//
//    // icon contstraints
    [self.iconImageView.heightAnchor constraintEqualToConstant:self.currentWeatherView.frame.size.height/2].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
}

/*-----------------TABLE VIEW DELEGATE METHODS-----------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [self.ourtableView dequeueReusableCellWithIdentifier:@"DailyTableViewCell"];
    
    if(cell == nil){
        cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DailyTableViewCell"];
    }
    if(loadData){
        Weather *hourlyWeather = self.location.dailyData[indexPath.row];
        cell.hourWeather = hourlyWeather;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.location.dailyData.count;
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
