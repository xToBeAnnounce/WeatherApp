//
//  DailyViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyViewController.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"

@interface DailyViewController () 

@property (strong, nonatomic) UIView *currentWeatherView;
@property (strong, nonatomic) UITableView *WeeklytableView;
@property (strong, nonatomic) NSString *tempType;
@property (strong,nonatomic) UITableView *DailytableView;
@property (strong, nonatomic) UIStackView *weatherDisplayStackView;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UILabel *customNameLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@end



@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.location = [Location currentLocation];

}



- (void)viewDidAppear:(BOOL)animated {
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            //[self displayCurrentWeather];
            [self.DailytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempType = pref.tempTypeString;
            [self.WeeklytableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}







@end
