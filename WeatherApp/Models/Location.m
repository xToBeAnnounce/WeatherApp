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
@dynamic lattitude, longitude, customName, startDate, endDate, backdropImage, placeName;


+ (nonnull NSString *)parseClassName {
    return @"Location";
}

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

+ (instancetype) initWithSearchDictionary:(NSDictionary *)searchDictionary {
    Location *newLoc = [[Location alloc] init];
    newLoc.longitude = [searchDictionary[@"lng"] doubleValue];
    newLoc.lattitude = [searchDictionary[@"lat"] doubleValue];
    newLoc.placeName = searchDictionary[@"name"];
    
    return newLoc;
}

//+ (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate{
//    Location *newLoc = [[Location alloc] init];
//    newLoc.lattitude = coordinate.latitude;
//    newLoc.longitude = coordinate.longitude;
//    [newLoc updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
//        // something
//    }];
//
//    return newLoc;
//}

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
    [newLoc updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
        // something
    }];
    return newLoc;
}

- (void) updateTimeFrame:(NSDate *)startDate withEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock)completion {
    self.startDate = startDate;
    self.endDate = endDate;
    [self saveInBackgroundWithBlock:completion];
}

- (void) addBackdropImage:(UIImage *)image withCompletion:(PFBooleanResultBlock)completion{
    self.backdropImage = [Location getPFFileFromImage:image];
    [self saveInBackgroundWithBlock:completion];
}

- (void) updatePlaceNameWithBlock:(void(^)(NSDictionary *data, NSError *error))block{
    GeoAPIManager *geoAPIManager = [GeoAPIManager shared];
    [geoAPIManager getNearestAddressOfLattitude:self.lattitude longitude:self.longitude completion:^(NSDictionary *data, NSError *error) {
        if (data) {
            NSDictionary *address = data[@"address"];
            self.placeName = address[@"placename"];
            if (!self.placeName) self.placeName = @"Current Location";
            block (data, nil);
        }
        else {
            block(nil, error);
        }
    }];
}

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Updated lol");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

+ (PFFile *) getPFFileFromImage: (UIImage * _Nullable) image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}
@end
