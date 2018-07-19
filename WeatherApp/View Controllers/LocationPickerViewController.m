//
//  LocationPickerViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationPickerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationPickerViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    UIButton *getLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [getLocationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [getLocationButton setTitle:@"GET LOCATION" forState:UIControlStateNormal];
    [getLocationButton addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getLocationButton];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(CLLocationCoordinate2D) getLocation{
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSLog(@"Here's the coordinate: %f %f", coordinate.longitude, coordinate.latitude);
    return coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Updated lol");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getLocation];
    }];
    [errorAlert addAction:retryAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

@end
