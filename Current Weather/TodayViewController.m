//
//  TodayViewController.m
//  Current Weather
//
//  Created by Jamie Tan on 7/27/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "TodayViewController.h"
#import <Parse/Parse.h>
#import "Location.h"
#import "Weather.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) Location *location;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTempLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [self parseBackendSetup];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.location = Location.currentLocation;
    [self displayLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void)parseBackendSetup{
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"ttjWeatherApp";
        configuration.clientKey = @"ttjWAMasterKey";
        configuration.server = @"https://ttj-weather-app.herokuapp.com/parse";
        configuration.localDatastoreEnabled = YES;
    }];
    [Parse initializeWithConfiguration:config];
}

- (void) displayLocation {
    [self.location updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            [self.location fetchDataType:@"current" WithCompletion:^(NSDictionary *data, NSError *error) {
                if (data) {
                    self.placeNameLabel.text = self.location.fullPlaceName;
                    if (self.location.dailyData.count) {
                        Weather *currentWeather = self.location.dailyData[0];
                        self.currentTempLabel.text = [currentWeather getTempInString:currentWeather.temperature];
                        self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
                    }
                    if (self.location.weeklyData.count) {
                        Weather *todayWeather = self.location.weeklyData[0];
                        self.highLowTempLabel.text = [NSString stringWithFormat:@"%@/ %@", [todayWeather getTempInString:todayWeather.temperatureHigh],  [todayWeather getTempInString:todayWeather.temperatureLow]];
                    }
                }
            }];
        }
    }];
}

@end
