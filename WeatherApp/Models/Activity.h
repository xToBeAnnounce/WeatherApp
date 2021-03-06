
//
//  Activity.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Weather.h"

@protocol ActivityDelegate
-(void)displayPopoverWithLocation:(Location*)loc weather:(Weather*)weather index:(int)idx;
@end

@interface Activity : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon; //Icon of location provided
@property (strong, nonatomic) NSString *placeID; //Used to access webview / google maps in the future
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSArray *location; //Lat, lng

-(instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *) getActivityCategoryWithWeatherType:(NSString*)weatherCondition;
+ (NSString *) getSuggestionStringForActivity:(NSString *)activityCategory;
@end
