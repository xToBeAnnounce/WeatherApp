//
//  Location.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Location.h"
#import "GeoAPIManager.h"

@implementation Location
/*-----------------------PARSE-----------------------*/
@dynamic lattitude, longitude, customName, startDate, endDate, backdropImage, placeName, fullPlaceName;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

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
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = newLoc;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager requestLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    newLoc.lattitude = coordinate.latitude;
    newLoc.longitude = coordinate.longitude;
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
                self.placeName = @"Unknown Location";
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
    NSLog(@"Updated loction");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"Getting location failed with error: %@", error);
}
@end
