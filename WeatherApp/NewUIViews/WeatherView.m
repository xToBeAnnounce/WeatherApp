//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "TodayWeatherCell.h"
#import "TodayActivitiesCell.h"
#import "WeeklyView.h"
#import "HourlyForecast.h"

@implementation WeatherView
{
    TodayWeatherCell *_todayWeatherCell;
//    UIView *_screenView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *tempBackground = [[UIImageView alloc] initWithFrame:self.frame];
        tempBackground.image = [UIImage imageNamed:@"Sanfranciso"];
        tempBackground.contentMode = UIViewContentModeScaleAspectFill;
        tempBackground.clipsToBounds = YES;
        [self addSubview:tempBackground];
        [self setUpCells];
        [self setViewsUI];
    }
    return self;
}

UICollectionViewFlowLayout *layout;
NSString *cellID = @"cellID";

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
    
    [self addSubview:self.maintableView];
}

// initalizes cell properties
- (void) setUpCells {
    _todayWeatherCell = [[TodayWeatherCell alloc] init];
}

// sets the UI of table view and background
- (void) setViewsUI {
    //Collection View
    layout = [[UICollectionViewFlowLayout alloc]init];
    layout.estimatedItemSize = CGSizeMake(self.frame.size.width, 100);
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = UIColor.cyanColor;
    [self.mainCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:cellID];
    [self.mainCollectionView registerClass:HourlyForecast.class forCellWithReuseIdentifier:@"hourlyCell"];
    [self addSubview:self.mainCollectionView];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        UICollectionViewCell *Dailycell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        Dailycell.translatesAutoresizingMaskIntoConstraints = NO;
        WeeklyView *weeklyView = [[WeeklyView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 350)];
        weeklyView.location = self.location;
        [Dailycell addSubview:weeklyView];

        weeklyView.translatesAutoresizingMaskIntoConstraints = NO;
        [weeklyView.topAnchor constraintEqualToAnchor:Dailycell.topAnchor].active = YES;
        [weeklyView.leadingAnchor constraintEqualToAnchor:Dailycell.leadingAnchor].active = YES;
        [weeklyView.trailingAnchor constraintEqualToAnchor:Dailycell.trailingAnchor].active = YES;
        //[weeklyView.bottomAnchor constraintEqualToAnchor:Dailycell.bottomAnchor].active = YES;
        [Dailycell.heightAnchor constraintEqualToConstant:300].active = YES;
        Dailycell.backgroundColor = UIColor.redColor;
        return Dailycell;
    }
    else if(indexPath.row == 1){
        HourlyForecast *hourlyForecastCell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:@"hourlyCell" forIndexPath:indexPath];
        hourlyForecastCell.translatesAutoresizingMaskIntoConstraints = NO;
        hourlyForecastCell.location = self.location;
        [hourlyForecastCell.heightAnchor constraintEqualToConstant:50].active = YES;
        hourlyForecastCell.backgroundColor = UIColor.yellowColor;
        return hourlyForecastCell;
    }
    else{
        UICollectionViewCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = UIColor.orangeColor;
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

@end
