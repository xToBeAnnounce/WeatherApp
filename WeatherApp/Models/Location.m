//
//  Location.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Location.h"

@implementation Location
@dynamic lattitude, longitude, customName, startDate, endDate, backdropImage, placeName;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

+ (void) saveLocationWithLongitude:(double)longitude lattitude:(double)lattitude key:(NSString *)key attributes:(NSDictionary *)dictionary withBlock:(void(^)(Location *, NSError *))block{
    Location *newLoc = Location.new;
    newLoc.longitude = longitude;
    newLoc.lattitude = lattitude;
    newLoc.customName = key;
    newLoc.startDate = [NSDate date];
    newLoc.endDate = nil;
    newLoc.backdropImage = nil;
    
    if (dictionary) {
        [newLoc setValuesForKeysWithDictionary:dictionary];
    }
    
    if (newLoc.customName) {
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
        NSLog(@"Key cannot be null");
    }
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

//- (NSString *)getReverseGeocodedString {
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.lattitude longitude:self.longitude];
//    CLGeocoder *geocoder = [CLGeocoder new];
//
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Geocode failed with error: %@", error);
//            return; // Request failed, log error
//        }
//        else if (placemarks && placemarks.count > 0) {
//            CLPlacemark *placemark = placemarks[0];
//
//        }
//        else {
//        }
//    }];
//}

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
