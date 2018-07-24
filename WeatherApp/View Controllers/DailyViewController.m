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

@interface DailyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *currentWeatherView;
@property (strong, nonatomic) UIStackView *weatherDisplayStackView;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UILabel *customNameLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) NSString *tempType;

@end

static bool loadData = NO;

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.location = [Location currentLocation];
    [self setUI];
    
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadData = YES;
            [self displayCurrentWeather];
            [self.ourtableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            [self displayCurrentWeather];
            [self.ourtableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //sets table view
    CGFloat yorigin = self.view.frame.origin.y + self.view.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.view.frame.origin.x, yorigin, self.view.frame.size.width, self.view.frame.size.height/2 - 50);
    self.ourtableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    self.ourtableView.delegate = self;
    self.ourtableView.dataSource = self;
    [self.ourtableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"DailyTableViewCell"];
    
    self.ourtableView.estimatedRowHeight = 44.0;
    self.ourtableView.rowHeight = UITableViewAutomaticDimension;
    self.ourtableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.ourtableView];
    
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[weatherView]-0-[tableView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"weatherView":self.currentWeatherView, @"tableView":self.ourtableView}]];
    
    // table view constraints
    [self.ourtableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.ourtableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.ourtableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

/*-----------------TABLE VIEW DELEGATE METHODS-----------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [self.ourtableView dequeueReusableCellWithIdentifier:@"DailyTableViewCell"];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.location.dailyData.count;
}

@end
