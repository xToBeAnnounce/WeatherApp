//
//  DailyView.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyView.h"
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
static int currentWeatherViewHeight;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setDailyUI];
    [self displayCurrentWeather];
    self.DailytableView.dataSource = self;
    self.DailytableView.delegate = self;
    
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadDailyData = YES;
            [self displayCurrentWeather];
            [self.DailytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

- (void) updateDataIfNeeded {
    if (self.location.dailyData.count == 0) {
        [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                loadDailyData = YES;
                [self displayCurrentWeather];
                [self.DailytableView reloadData];
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat TableViewOffset = self.DailytableView.contentOffset.y;
    if(TableViewOffset > 0 && self.oldframe.size.height-TableViewOffset > currentWeatherViewHeight){
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:50 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect newFrame = CGRectMake(self.oldframe.origin.x, self.oldframe.origin.y, self.oldframe.size.width, self.oldframe.size.height-TableViewOffset);
            self.currentWeatherView.frame = newFrame;
            if(fabs(self.oldframe.size.height - self.currentWeatherView.frame.size.height) <= 10){
                self.temperatureLabel.alpha = 1;
            }
            else if (TableViewOffset > currentWeatherViewHeight){
                self.temperatureLabel.alpha = 0;
            }
            else{
                self.temperatureLabel.alpha = 1 - (currentWeatherViewHeight / (self.oldframe.size.height-TableViewOffset));
            }
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void) setLocation:(Location *)location {
    _location = location;
    if ([self.location.placeName isEqualToString:self.location.customName]) {
        self.customNameLabel.font = [UIFont systemFontOfSize:45];
        self.locationLabel.hidden = YES;
    }
    else {
        self.locationLabel.hidden = NO;
        self.customNameLabel.font = [UIFont systemFontOfSize:35];
        self.locationLabel.text = self.location.placeName;
        [self.locationLabel sizeToFit];
    }
    self.customNameLabel.text = self.location.customName;
    
    [self updateDataIfNeeded];
    [self refreshView];
}

- (void)setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self refreshView];
}

- (void) setDailyUI {
    self.DailytableView = [[UITableView alloc] init];
    [self.DailytableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"DailyTableViewCell"];
    self.DailytableView.estimatedRowHeight = 44.0;
    self.DailytableView.rowHeight = UITableViewAutomaticDimension;
    self.DailytableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.DailytableView.dataSource = self;
    self.DailytableView.delegate = self;
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
    self.customNameLabel.text = self.location.customName;
    
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
    self.oldframe = self.currentWeatherView.frame;
    currentWeatherViewHeight = self.oldframe.size.height / 2;
    
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

-(void)displayCurrentWeather{
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
        self.locationLabel.hidden = YES;
    }
    else {
        self.locationLabel.text = self.location.placeName;
        [self.locationLabel sizeToFit];
    }
}

- (void) refreshView {
    [self displayCurrentWeather];
    [self.DailytableView reloadData];
}

/*--------TABLE VIEW DELEGATE METHODS----------*/
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


@end
