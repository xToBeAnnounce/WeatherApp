//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "HourlyForecastCell.h"

@implementation WeatherView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) style:UITableViewStylePlain];
    self.maintableView.rowHeight = UITableViewAutomaticDimension;
    self.maintableView.translatesAutoresizingMaskIntoConstraints = NO;

    self.maintableView.dataSource = self;
    self.maintableView.delegate = self;
    
    [self addSubview:self.maintableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        HourlyForecastCell *hourlyForecastCell = [[HourlyForecastCell alloc] init];
        hourlyForecastCell.location = self.location;
        return hourlyForecastCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



@end
