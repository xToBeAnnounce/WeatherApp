//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "HourlyForecastCell.h"
#import "TodayWeatherCell.h"
#import "TodayActivitiesCell.h"
#import "WeeklyView.h"

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
        self.backgroundColor = UIColor.purpleColor;
        [self setUpCells];
        [self setViewsUI];
    }
    return self;
}

UICollectionViewFlowLayout *layout;
NSString *cellID = @"cellIDD";

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.location fetchDataType:@"current" WithCompletion:^(NSDictionary *data, NSError *error) {
        if (data) {
            self->_todayWeatherCell.weatherView.currentWeather = self.location.dailyData[0];
            self->_todayWeatherCell.weatherView.todayWeather = self.location.weeklyData[0];
            [self.maintableView reloadData];
        }
        else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    
    layout = [[UICollectionViewFlowLayout alloc]init];
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = UIColor.cyanColor;
    [self.mainCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:cellID];
    [self addSubview:self.mainCollectionView];
    
}

// initalizes cell properties
- (void) setUpCells {
    _todayWeatherCell = [[TodayWeatherCell alloc] init];
}

// sets the UI of table view and background
- (void) setViewsUI {
    // Table view
    self.maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) style:UITableViewStylePlain];
    self.maintableView.backgroundColor = nil;
    self.maintableView.dataSource = self;
    self.maintableView.delegate = self;
    
    [self addSubview:self.maintableView];
    [self.maintableView reloadData];
    
//    _screenView = [[UIView alloc] init];
//    _screenView.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.5];
//    _screenView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_screenView];
//
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[todayWeatherCell][screenView]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"todayWeatherCell":_todayWeatherCell, @"screenView":_screenView}]];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 1){
        //        HourlyForecastCell *hourlyForecastCell = [[HourlyForecastCell alloc] init];
        //        return hourlyForecastCell;
    }
    if(indexPath.row == 0){
        UICollectionViewCell *Dailycell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        WeeklyView *weeklyView = [[WeeklyView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 350)];
        weeklyView.location = self.location;
        [Dailycell addSubview:weeklyView];
        return Dailycell;
    }
    
    UICollectionViewCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = UIColor.blueColor;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, 350);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = UITableViewCell.new;
    
    if (indexPath.row == 0) {
        cell = _todayWeatherCell;
    }
    else if(indexPath.row == 1){
        cell = [[HourlyForecastCell alloc] init];
    }
    else if (indexPath.row == 3) {
        cell = [[TodayActivitiesCell alloc] init];
    }
    
    if (indexPath.row != 0) cell.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.8];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.maintableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell layoutIfNeeded];
}
@end
