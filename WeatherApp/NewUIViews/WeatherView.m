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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5;
//}
@end
