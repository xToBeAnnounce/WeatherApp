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
@property (strong, nonatomic) NSString *locationTypeKey;   //Home, work, travel
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) PFFile *backdropImage;

+ (instancetype) initWithLongitude:(double)longitude lattitude:(double)lattitude attributes:(NSDictionary *)dictionary;
- (void) addBackdropImage:(UIImage *)image withCompletion:(PFBooleanResultBlock)completion;
- (void) updateTimeFrame:(NSDate *)startDate withEndDate:(NSDate *)endDate withCompletion:(PFBooleanResultBlock)completion;
@end
