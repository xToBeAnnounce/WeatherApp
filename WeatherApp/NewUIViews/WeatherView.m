//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "HourlyForecastCell.h"
#import "TodayWeatherView.h"
#import "TodayActivitiesCell.h"
#import "WeeklyView.h"
#import "WeatherCardCell.h"

@implementation WeatherView
{
    TodayWeatherView *_todayWeatherView;
    WeeklyView *_weeklyView;
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
        [self setCollectionViewUI];
        [self setViewsUI];
        [self setConstraints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.location fetchDataType:@"current" WithCompletion:^(NSDictionary *data, NSError *error) {
        if (data) {
            self->_todayWeatherView.currentWeather = self.location.dailyData[0];
            self->_todayWeatherView.todayWeather = self.location.weeklyData[0];
            [self.mainCollectionView reloadData];
        }
        else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
}

- (void) setViewsUI {
    _todayWeatherView = [[TodayWeatherView alloc] init];
    _todayWeatherView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_todayWeatherView];
    
    _weeklyView = [[WeeklyView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 350)];
}

// sets the UI of table view and background
- (void) setCollectionViewUI {
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
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
        [cell setTitle:@"Hourly Forecast" withView:placeholderView];
    }
    else if (indexPath.row == 1) {
        [cell setTitle:@"Today's Summary" withView:placeholderView];
    }
    else if (indexPath.row == 2) {
        [cell setTitle:@"Suggested Activities" withView:placeholderView];
    }
    else if (indexPath.row == 3) {
        _weeklyView.location = self.location;
        [cell setTitle:@"Daily Forecast" withView:_weeklyView];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, 350);
}

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
