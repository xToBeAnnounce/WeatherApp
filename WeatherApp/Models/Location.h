//
//  Location.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Parse/Parse.h>

@interface Location : PFObject <PFSubclassing>

@property (nonatomic) double lattitude;
@property (nonatomic) double longitude;
@property (strong, nonatomic) NSString *placeName; // ex. San Francisco
@property (strong, nonatomic) NSString *customName;   //Home, work, travel
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) PFFile *backdropImage;

// Save new location
+ (void) saveLocationWithLongitude:(double)longitude lattitude:(double)lattitude key:(NSString *)key attributes:(NSDictionary *)dictionary withBlock:(void(^)(Location *, NSError *))block;

// Update existing location
- (void) addBackdropImage:(UIImage *)image withCompletion:(PFBooleanResultBlock)completion;
- (void) updateTimeFrame:(NSDate *)startDate withEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock)completion;
@end
