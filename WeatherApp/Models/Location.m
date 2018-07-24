//
//  Location.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Location.h"
#import "GeoAPIManager.h"
#import "Weather.h"
#import "APIManager.h"

@implementation Location
/*-----------------------PARSE-----------------------*/
@dynamic lattitude, longitude, customName, startDate, endDate, backdropImage, placeName, fullPlaceName;
+ (nonnull NSString *)parseClassName {
    return @"Location";
}

@synthesize locationManager;

/*-----------------------WEATHER-----------------------*/
static float lat = 42.3601;
static float lng = -71.0589;
static int const numDaysInWeek = 7;
static int const numHoursInDay = 24;
@synthesize dailyData, weeklyData;

/*-------------METHODS TO CREATE/SAVE NEW LOCATION-------------*/
// save new location
+ (void) saveLocationWithLongitude:(double)longitude lattitude:(double)lattitude attributes:(NSDictionary *)dictionary withBlock:(void(^)(Location *, NSError *))block{
    Location *newLoc = Location.new;
    newLoc.longitude = longitude;
    newLoc.lattitude = lattitude;
    newLoc.startDate = [NSDate date];
    
    if (dictionary) {
        [newLoc setValuesForKeysWithDictionary:dictionary];
    }
    
    [newLoc updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            // If no custom name given, defaults to name of place
            if (!newLoc.customName) newLoc.customName = newLoc.placeName;
            [newLoc saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    block(newLoc, nil);
                }
                else {
                    block(nil, error);
                }
            }];
        }
        else {
            NSLog(@"Saving Location Failed: %@", error.localizedDescription);
        }
    }];
}

// returns new location given dictionary search results from the geonames API (doesn't save)
+ (instancetype) initWithSearchDictionary:(NSDictionary *)searchDictionary {
    Location *newLoc = [[Location alloc] init];
    newLoc.longitude = [searchDictionary[@"lng"] doubleValue];
    newLoc.lattitude = [searchDictionary[@"lat"] doubleValue];
    newLoc.placeName = searchDictionary[@"name"];
    newLoc.fullPlaceName = [newLoc.placeName stringByAppendingString:@", "];
    if ([searchDictionary[@"countryCode"] isEqualToString:@"US"]) {
        newLoc.fullPlaceName = [newLoc.fullPlaceName stringByAppendingString:[NSString stringWithFormat:@"%@, ", searchDictionary[@"adminCodes1"][@"ISO3166_2"]]];
    }
    newLoc.fullPlaceName = [newLoc.fullPlaceName stringByAppendingString:searchDictionary[@"countryName"]];
    
    return newLoc;
}

// returns new location object with current longitude/lattitude (if loc services disallowed, (0,0)) (doesn't save)
+ (instancetype) currentLocation{
    Location *newLoc = [[Location alloc] init];
    newLoc.locationManager = [[CLLocationManager alloc] init];
    newLoc.locationManager.delegate = newLoc;
    newLoc.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    newLoc.locationManager.distanceFilter = kCLDistanceFilterNone;

    if ([newLoc.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [newLoc.locationManager requestWhenInUseAuthorization];
    }
    
    [newLoc.locationManager requestLocation];
    
    CLLocation *location = [newLoc.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    newLoc.lattitude = coordinate.latitude;
    newLoc.longitude = coordinate.longitude;
    newLoc.customName = @"Current Location";
    return newLoc;
}


/*-----------------METHODS TO UPDATE PROPERTIES OF A LOCATION-----------------*/
// Update/Set placeName and fullPlaceName (doesn't save)
- (void) updatePlaceNameWithBlock:(void(^)(NSDictionary *data, NSError *error))block{
    GeoAPIManager *geoAPIManager = [GeoAPIManager shared];
    [geoAPIManager getNearestAddressOfLattitude:self.lattitude longitude:self.longitude completion:^(NSDictionary *data, NSError *error) {
        if (data) {
            NSDictionary *address = data[@"address"];
            self.placeName = address[@"placename"];
            self.fullPlaceName = [self.placeName stringByAppendingString:[NSString stringWithFormat:@", %@, United States", address[@"adminCode1"]]];
            if (!self.placeName) {
                self.placeName = @"Unknown";
                self.fullPlaceName = self.placeName;
            }
            block (data, nil);
        }
        else {
            block(nil, error);
        }
    }];
}

// Updates startDate and endDate (saves)
- (void) updateTimeFrame:(NSDate *)startDate withEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock)completion {
    if (startDate) self.startDate = startDate;
    if (endDate) self.endDate = endDate;
    [self saveInBackgroundWithBlock:completion];
}

// Adds backdrop image (saves)
- (void) addBackdropImage:(UIImage *)image withCompletion:(PFBooleanResultBlock)completion{
    self.backdropImage = [Location getPFFileFromImage:image];
    [self saveInBackgroundWithBlock:completion];
}

// Updates multiple fields with dictionary (saves)
- (void) updateWithDictionary:(NSMutableDictionary *)dictionary withCompletion:(PFBooleanResultBlock)completion{
    [self setValuesForKeysWithDictionary:dictionary];
    if ([dictionary objectForKey:@"longitude"] || [dictionary objectForKey:@"lattitude"]) {
        [self updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
            if (data) {
                [self saveInBackgroundWithBlock:completion];
            }
        }];
    }
    else {
        [self saveInBackgroundWithBlock:completion];
    }
}

/*-------------FETCH WEATHER METHODS-------------*/
-(void)fetchDataType:(NSString*)dataType WithCompletion:(void(^)(NSDictionary*, NSError*))completion{
    if([dataType isEqualToString:@"daily"]){
        self.dailyData = [[NSMutableArray alloc] init];
        [self getDataWithLong:self.longitude Lat:self.lattitude Type:dataType Completion:^(NSDictionary *data, NSError *error) {
            if (data) {
                [self setDailyDataWithDictionary:data];
                completion(data, nil);
            }
            else {
                completion(nil, error);
            }
        }];
//        [self getDataWithLong:(int)lng Lat:(int)lat Type:dataType Completion:completion];
    }
    else if([dataType isEqualToString:@"weekly"]){
        self.weeklyData = [[NSMutableArray alloc] init];
        [self getDataWithLong:(int)lng Lat:(int)lat Type:dataType Completion:^(NSDictionary *data, NSError *error) {
            if (data) {
                [self setWeeklyDataWithDictionary:data];
                completion(data, nil);
            }
            else {
                completion(nil, error);
            }
        }];
    }
}

- (void)getDataWithLong:(int)lng Lat:(int)lat Type:(NSString*)dataType Completion:(void(^)(NSDictionary*, NSError *error))completion{
    APIManager *apiManager = [APIManager shared];

    [apiManager setURLWithLatitude:lat Longitude:lng Range:dataType];
    [apiManager getDataWithCompletion:^(NSDictionary *data, NSError *error) {
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
            completion(nil, error);
        } else {
            completion(data, nil);
        }
    }];
}

-(void)setWeeklyDataWithDictionary:(NSDictionary*)data{
    NSArray *dailyArray = data[@"daily"][@"data"];
    for(int i=0; i<numDaysInWeek; i++){
        [self.weeklyData addObject:[[Weather alloc]initWithData:dailyArray[i]]];
    }
}

-(void)setDailyDataWithDictionary:(NSDictionary*)data{
    NSArray *hourlyArray = data[@"hourly"][@"data"];
    for(int i=0; i<numHoursInDay; i++){
        [self.dailyData addObject:[[Weather alloc]initWithData:hourlyArray[i]]];
    }
}

/*----------------------MISC----------------------*/
// Convert UIImage to PFFile
+ (PFFile *) getPFFileFromImage: (UIImage * _Nullable) image {
    if (!image) return nil;
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) return nil;
    return [PFFile fileWithName:@"image.png" data:imageData];
}

/*-------------CLLOCATION MANAGER DELEGATE METHODS-------------*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Updated loction to %f, %f", locations[0].coordinate.latitude, locations[0].coordinate.longitude);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"Getting location failed with error: %@", error);
}

@end
