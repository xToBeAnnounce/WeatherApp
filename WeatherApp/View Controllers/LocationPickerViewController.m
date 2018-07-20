//
//  LocationPickerViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationPickerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "GeoAPIManager.h"

@interface LocationPickerViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation LocationPickerViewController

static BOOL loadingData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    loadingData = NO;
    
    UIButton *getLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [getLocationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [getLocationButton setTitle:@"GET LOCATION" forState:UIControlStateNormal];
    [getLocationButton addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getLocationButton];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 175, 150, 50)];
    [searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchButton setTitle:@"Search!" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(onTapSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 250, 40)];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.searchTextField addTarget:self action:@selector(onTapSearch) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.searchTextField];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
//    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
//    Location *currentLoc = Location.currentLocation;
//    [currentLoc updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
//        if (data) {
//            NSLog(@"%@", currentLoc.placeName);
//        }
//        else {
//            NSLog(@"Error");
//        }
//    }];
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
//    [Location saveLocationWithLongitude:coordinate.longitude lattitude:coordinate.latitude attributes:@{@"customName":@"Building 29"} withBlock:^(Location *loc, NSError *error) {
//        if (loc) NSLog(@"You're in %@", loc.placeName);
//        else NSLog(@"Error: %@", error.localizedDescription);
//    }];
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

- (void) onTapSearch {
    if (!loadingData) {
        loadingData = YES;
        [[GeoAPIManager shared] searchForLocationByName:self.searchTextField.text withOffset:0 withCompletion:^(NSDictionary *data, NSError *error) {
            if (data) {
                NSString *results = @"";
                NSArray *geonamesArray = data[@"geonames"];
                for (NSDictionary *geoname in geonamesArray) {
                    Location *loc = [Location initWithSearchDictionary:geoname];
                    results = [results stringByAppendingString:[NSString stringWithFormat:@"%@ with lat: %f lng: %f\n", loc.fullPlaceName, loc.lattitude, loc.longitude]];
                }
                NSLog(@"%@", data[@"totalResultsCount"]);
                NSLog(@"%@", results);

                loadingData = NO;
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

@end
