//
//  DailyView.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface DailyView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIView *currentWeatherView;
@property (strong, nonatomic) NSString *tempType;
@property (strong,nonatomic) UITableView *DailytableView;
@property (strong, nonatomic) UIStackView *weatherDisplayStackView;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UILabel *customNameLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;

@property (strong,nonatomic) Location *location;

-(void)setDailyUI:(Location *)location;
-(void)displayCurrentWeather:(Location *)location;

@end
