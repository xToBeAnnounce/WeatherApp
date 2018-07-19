//
//  Location.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Location.h"
#import "Weather.h"
#import "APIManager.h"

static float lat = 42.3601;
static float lng = -71.0589;
static int const numDaysInWeek = 7;
static int const numHoursInDay = 24;

@implementation Location
@dynamic lattitude, longitude, customName, startDate, endDate, backdropImage, placeName;
@synthesize dailyData, weeklyData, delegate;

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

-(void)fetchWeeklyData{
    self.weeklyData = [[NSMutableArray alloc] init];
    [self getWeeklyWithLong:lng Lat:lat Array:self.weeklyData Count:0];
}

- (void)getWeeklyWithLong:(int)lng Lat:(int)lat Array:(NSMutableArray*)weeklyData Count:(int)count{
    if(count == numDaysInWeek){
        [self.delegate reloadDataTableView];
        return;
    }
    else{
        APIManager *apiManager = [APIManager shared];
        NSDate *currDate = [NSDate date];
        NSDate *nextDate = [currDate dateByAddingTimeInterval:(60*60*24*count)];
        
        [apiManager setURLWithLatitude:lat Longitude:lng Time:nextDate Range:@"weekly"];
        [apiManager getDataWithCompletion:^(NSDictionary *data, NSError *error) {
            if(error != nil) NSLog(@"%@", error.localizedDescription);
            else{
                NSArray *dayData = data[@"daily"][@"data"];
                [weeklyData addObject:[[Weather alloc]initWithData:dayData[0]]];
                [self getWeeklyWithLong:lng Lat:lat Array:weeklyData Count:(count+1)];
            }
        }];
    }
}

-(void)fetchDailyData{
    self.dailyData = [[NSMutableArray alloc] init];
    [self getDailyWithLong:lng Lat:lat Array:self.dailyData];
}

- (void)getDailyWithLong:(int)lng Lat:(int)lat Array:(NSMutableArray*)dailyData{
    APIManager *apiManager = [APIManager shared];
    NSDate *currDate = [NSDate date];
    [apiManager setURLWithLatitude:lat Longitude:lng Time:currDate Range:@"daily"];
    [apiManager getDataWithCompletion:^(NSDictionary *data, NSError *error) {
        
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSArray *hourlyData = data[@"hourly"][@"data"];
            for(int i=0; i<numHoursInDay; i++){
                [dailyData addObject:[[Weather alloc]initWithData:hourlyData[i]]];
            }
            [self.delegate reloadDataTableView];
        }
    }];
}

@end
