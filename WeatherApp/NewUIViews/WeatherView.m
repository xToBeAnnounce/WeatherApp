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
#import "TodayActivitiesView.h"
#import "WeeklyView.h"
#import "DailyView.h"
#import "WeatherCardCell.h"
#import "BannerView.h"
#import <Parse/PFImageView.h>
#import "HourlyForecastView.h"

@implementation WeatherView
{
    PFImageView *_backdropImageView;
    TodayWeatherView *_todayWeatherView;
    TodayActivitiesView *_todayActivityView;
    WeeklyView *_weeklyView;
    UIWindow *_bannerWindow;
    BannerView *_bannerView;
    NSLayoutConstraint *_collectionHeightConstraint;
    HourlyForecastView *_hourlyView;
    CGRect _oldCollectionViewFrame;
    CGRect _oldTodayWeatherFrame;
    BOOL _getTodayViewFrame;
}
NSString *defaultBackdrop;
CGFloat _originalPos = 500;
UICollectionViewFlowLayout *layout;
NSString *cellID = @"weatherCardCell";
bool dataLoaded = NO;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        defaultBackdrop = @"golden_san_fran";
        _backdropImageView = [[PFImageView alloc] initWithFrame:self.frame];
        _backdropImageView.image = [UIImage imageNamed:defaultBackdrop];
        _backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backdropImageView.clipsToBounds = YES;
        [self addSubview:_backdropImageView];
        
        [self setCollectionViewUI];
        [self setViewsUI];
        [self setConstraints];
    }
    return self;
}

- (void) updateDataIfNeeded {
    if (self.location.weeklyData.count == 0 || self.location.dailyData.count == 0) {
        [self.location fetchDataType:@"all" WithCompletion:^(NSDictionary *data, NSError *error) {
            if (data) {
                Weather *currentWeather = self.location.dailyData[0];
                self->_todayWeatherView.currentWeather = currentWeather;
                self->_todayActivityView.currentWeather = currentWeather;
                
                Weather *todayWeather = self.location.weeklyData[0];
                self->_todayWeatherView.todayWeather = todayWeather;
                [self.mainCollectionView reloadData];
                
                self.location = self.location; //Sets the locations of the views in setLocation
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void) setViewsUI {
    
    _todayWeatherView = [[TodayWeatherView alloc] init];
    _getTodayViewFrame = NO;
    _todayWeatherView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_todayWeatherView];
  
    _todayActivityView = [[TodayActivitiesView alloc] init];
    _weeklyView = [[WeeklyView alloc] init];
    _hourlyView = [[HourlyForecastView alloc]init];
  
//     _weeklyView = [[WeeklyView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 350)];
    
//    _bannerWindow = UIApplication.sharedApplication.keyWindow;
//
//    _bannerView = [[BannerView alloc] initWithMessage:@"Placeholder message so I can see its behavior and all that jazz."];
//    _bannerView.backgroundColor = [UIColor redColor];
//    [_bannerWindow addSubview:_bannerView];
//    [_bannerView setUpBannerForSuperview];
}

- (void)setActivityDelegate:(id<ActivityDelegate>)activityDelegate {
    _activityDelegate = activityDelegate;
    _todayActivityView.activityDelegate = activityDelegate;
}

// sets the UI of table view and background
- (void) setCollectionViewUI {
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
//    layout.estimatedItemSize = CGSizeMake(350, 150);
    
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.5];
    self.mainCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainCollectionView registerClass:WeatherCardCell.class forCellWithReuseIdentifier:cellID];
    [self addSubview:self.mainCollectionView];
    
    _collectionHeightConstraint = [self.mainCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:300];
    _collectionHeightConstraint.active = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    WeatherCardCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIView *placeholderView = UIView.new;
    if(indexPath.row == 0){
        [cell setTitle:@"Hourly Forecast" withView:_hourlyView Width:self.mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 1) {
        [cell setTitle:@"Today's Summary" withView:placeholderView Width:self.mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 2) {
        [cell setTitle:@"Today's Activities" withView:_todayActivityView Width:self.mainCollectionView.frame.size.width];
    }
    else if (indexPath.row == 3) {
        [cell setTitle:@"Daily Forecast" withView:_weeklyView Width:self.mainCollectionView.frame.size.width];
    }
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.frame.size.width, 350);
//}

- (void) setConstraints {
    [self.mainCollectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.mainCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.mainCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    [_todayWeatherView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_todayWeatherView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[todayWeatherView][collectionView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"todayWeatherView":_todayWeatherView, @"collectionView":self.mainCollectionView}]];
    
    _oldCollectionViewFrame = self.mainCollectionView.frame;
}

- (void)setLocation:(Location *)location {
    _location = location;
    [self updateDataIfNeeded];
    
    if (location.backdropImage) {
        _backdropImageView.file = location.backdropImage;
        [_backdropImageView loadInBackground];
    }
    else {
        _backdropImageView.image = [UIImage imageNamed:defaultBackdrop];
    }
    
    _weeklyView.location = location;
    _todayActivityView.location = location;
    _hourlyView.location = location;
//    [_hourlyView setViewHeight];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_getTodayViewFrame){
        _oldTodayWeatherFrame = _todayWeatherView.frame;
        _getTodayViewFrame = YES;
    }
    
    CGFloat contentOffset = self.mainCollectionView.contentOffset.y;
    if((contentOffset < 10 && self.mainCollectionView.frame.origin.y <= _oldCollectionViewFrame.origin.y) || ((_todayWeatherView.frame.origin.y > self.safeAreaInsets.top) && self.mainCollectionView.frame.origin.y - contentOffset <= _oldCollectionViewFrame.origin.y)){
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:50 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_collectionHeightConstraint.active = NO;
            CGFloat newTodayWeatherY = self->_oldTodayWeatherFrame.origin.y - contentOffset;
            CGFloat newCollectionY = self->_oldCollectionViewFrame.origin.y - contentOffset;
            
            CGRect newTodayFrame = CGRectMake(self->_oldTodayWeatherFrame.origin.x, newTodayWeatherY, self->_oldTodayWeatherFrame.size.width, self->_oldTodayWeatherFrame.size.height);
            CGRect newCollectionFrame = CGRectMake(self->_oldCollectionViewFrame.origin.x, newCollectionY, self->_oldCollectionViewFrame.size.width, self->_oldCollectionViewFrame.size.height);
            
            self->_todayWeatherView.frame = newTodayFrame;
            self.mainCollectionView.frame = newCollectionFrame;
            
            self->_collectionHeightConstraint.constant = self->_collectionHeightConstraint.constant - contentOffset;
            self->_collectionHeightConstraint.active = YES;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {}];
    }
}
@end
