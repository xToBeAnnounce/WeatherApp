//
//  DailyView.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyView.h"
#import "DailyViewController.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"
#import "Location.h"


@implementation DailyView
static bool loadDailyData = NO;
static NSString *DailycellIdentifier = @"DailyTableViewCell";


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self setDailyUI:self.location];
    [self displayCurrentWeather:self.location];
    
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadDailyData = YES;
            [self displayCurrentWeather:self.location];
            [self.DailytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    self.DailytableView.dataSource = self;
    self.DailytableView.delegate = self;
    
   
}

-(void)setDailyUI:(Location *)location{
    //sets table view
    CGFloat yorigin = self.frame.origin.y + self.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.frame.origin.x, yorigin, self.frame.size.width, self.frame.size.height/2 - 50);
    self.DailytableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    [self.DailytableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"DailyTableViewCell"];
    
    self.DailytableView.estimatedRowHeight = 44.0;
    self.DailytableView.rowHeight = UITableViewAutomaticDimension;
    self.DailytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.DailytableView];
    
    self.currentWeatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
    [self addSubview:self.currentWeatherView];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.currentWeatherView.frame];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    self.backgroundImageView.image = [UIImage imageNamed:@"sunnybackground"];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.currentWeatherView addSubview:self.backgroundImageView];
    
    //setting up customNameLabel
    self.customNameLabel = [[UILabel alloc]init];
    self.customNameLabel.font = [UIFont systemFontOfSize:35];
    self.customNameLabel.text = location.customName;
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:17];
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

- (void) setConstraints {
    // background image constraints
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.currentWeatherView.topAnchor].active = YES;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.currentWeatherView.bottomAnchor].active = YES;
    [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.currentWeatherView.leadingAnchor].active = YES;
    [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.currentWeatherView.trailingAnchor].active = YES;
    
    // stack view constraints
    [self.weatherDisplayStackView.centerXAnchor constraintEqualToAnchor:self.currentWeatherView.centerXAnchor].active = YES;
    [self.weatherDisplayStackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.weatherDisplayStackView.bottomAnchor constraintEqualToAnchor:self.currentWeatherView.bottomAnchor constant:-8].active = YES;
    
    // icon contstraints
    [self.iconImageView.heightAnchor constraintEqualToAnchor:self.currentWeatherView.heightAnchor multiplier:3.0/7.0].active = YES;
    [self.iconImageView.widthAnchor constraintEqualToAnchor:self.iconImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    
    // constraint between tableview and current weather view
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[weatherView]-0-[tableView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"weatherView":self.currentWeatherView, @"tableView":self.DailytableView}]];
    
    // table view constraints
    [self.DailytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.DailytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.DailytableView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

-(void)displayCurrentWeather:(Location *)location{
    Weather *currentWeather;
    if (location.dailyData.count) currentWeather = location.dailyData[0];
    
    self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    self.temperatureLabel.text = [currentWeather getTempInString:currentWeather.temperature withType:self.tempType];
    [self.temperatureLabel sizeToFit];
    
    if ([location.customName isEqualToString:@"Current Location"]) {
        [location updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
            if (data) {
                self.locationLabel.text = location.placeName;
                [self.locationLabel sizeToFit];
            }
        }];
    }
    else if ([location.placeName isEqualToString:location.customName]) {
        self.customNameLabel.font = [UIFont systemFontOfSize:45];
        [self.locationLabel removeFromSuperview];
    }
    else {
        self.locationLabel.text = location.placeName;
        [self.locationLabel sizeToFit];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [self.DailytableView dequeueReusableCellWithIdentifier:DailycellIdentifier];
    if(cell == nil){
        cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DailycellIdentifier];
    }
    if(loadDailyData){
        cell.tempType = self.tempType;
        Weather *hourlyWeather = self.location.dailyData[indexPath.row];
        cell.hourWeather = hourlyWeather;
    }
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.location.dailyData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.DailytableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setLocation:(Location *)location{
    _location = location;
}


@end