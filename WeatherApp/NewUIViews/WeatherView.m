//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "TodayWeatherCell.h"
#import "TodayWeatherView.h"
#import "TodayActivitiesCell.h"
#import "WeeklyView.h"
#import "WeatherCardCell.h"
#import "HourlyForecastView.h"

@implementation WeatherView
{
    TodayWeatherView *_todayWeatherView;
    WeeklyView *_weeklyView;
    HourlyForecastView *_hourlyView;
}

UICollectionViewFlowLayout *layout;
NSString *cellID = @"weatherCardCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *tempBackground = [[UIImageView alloc] initWithFrame:self.frame];
        tempBackground.image = [UIImage imageNamed:@"Sanfranciso"];
        tempBackground.contentMode = UIViewContentModeScaleAspectFill;
        tempBackground.clipsToBounds = YES;
        [self addSubview:tempBackground];
        self.backgroundColor = UIColor.purpleColor;
        [self setViewsUI];
        [self setCollectionViewUI];
        [self setConstraints];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self.location fetchDataType:@"current" WithCompletion:^(NSDictionary *data, NSError *error) {
//        if (data) {
//            self->_todayWeatherCell.weatherView.currentWeather = self.location.dailyData[0];
//            self->_todayWeatherCell.weatherView.todayWeather = self.location.weeklyData[0];
//        }
//        else {
//            NSLog(@"Error %@", error.localizedDescription);
//        }
//    }];
}

- (void) setViewsUI {
    _todayWeatherView = [[TodayWeatherView alloc] init];
    _todayWeatherView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_todayWeatherView];
    
    _weeklyView = [[WeeklyView alloc] init];
    _hourlyView = [[HourlyForecastView alloc]init];
}

// sets the UI of table view and background
- (void) setCollectionViewUI {
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
//    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    layout.estimatedItemSize = CGSizeMake(350, 150);
    
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.8];
//    self.mainCollectionView.backgroundColor = UIColor.cyanColor;
    self.mainCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainCollectionView registerClass:WeatherCardCell.class forCellWithReuseIdentifier:cellID];
    [self addSubview:self.mainCollectionView];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeatherCardCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIView *placeholderView = UIView.new;
    
    if(indexPath.row == 0){
        _hourlyView.location = self.location;
        [cell setTitle:@"Hourly Forecast" withView:_hourlyView Width:_mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 1) {
        [cell setTitle:@"Today's Summary" withView:placeholderView Width:_mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 2) {
        [cell setTitle:@"Suggested Activities" withView:placeholderView Width:_mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 3) {
        _weeklyView.location = self.location;
        [cell setTitle:@"Daily Forecast" withView:_weeklyView Width:_mainCollectionView.frame.size.width];
    }
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.frame.size.width, 350);
//}

- (void) setConstraints {
    [self.mainCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:300].active = YES;
    [self.mainCollectionView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [self.mainCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.mainCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    [_todayWeatherView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_todayWeatherView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[todayWeatherView][collectionView]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"todayWeatherView":_todayWeatherView, @"collectionView":self.mainCollectionView}]];
}


@end
