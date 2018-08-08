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

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) style:UITableViewStylePlain];
    self.maintableView.backgroundColor = nil;
    self.maintableView.dataSource = self;
    self.maintableView.delegate = self;
    
    [self addSubview:self.maintableView];
    [self.maintableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TodayWeatherCell *todayWeatherCell = [[TodayWeatherCell alloc] init];
        return todayWeatherCell;
    }
    else if(indexPath.row == 1){
        HourlyForecastCell *hourlyForecastCell = [[HourlyForecastCell alloc] init];
        return hourlyForecastCell;
    }
    return UITableViewCell.new;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5;
//}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
