//
//  Activity.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Activity.h"

@implementation Activity
-(instancetype)initWithDictionary:(NSDictionary*)data{
    self.name = data[@"name"];
    self.icon = data[@"icon"];
    self.address = data[@"vicinity"];
    self.placeID = data[@"placeID"];
    NSDictionary *loc = data[@"geometry"][@"location"];
    self.location = @[loc[@"lat"], loc[@"lng"]];
    return self;
}

+ (NSArray *) getActivityCategoryWithWeatherType:(NSString*)weatherCondition{
    NSArray *category = @[];
    
    if([weatherCondition rangeOfString:@"clear"].location != NSNotFound || [weatherCondition rangeOfString:@"cloud"].location != NSNotFound){
        category = @[@"attractions", @"park", @"trails", @"resturant", @"cafe"];
    }
    else if([weatherCondition rangeOfString:@"wind"].location != NSNotFound ||
            [weatherCondition rangeOfString:@"rain"].location != NSNotFound){
        category = @[@"clothing_store", @"library", @"movie_theater", @"shopping_mall", @"cafe", @"resturant"];
    }
    
    return category;
}

+ (NSString *) getSuggestionStringForActivity:(NSString *)activityCategory {
    activityCategory = [activityCategory stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    NSString *suggestionString;
    if ([activityCategory isEqualToString:@"attractions"]) {
        suggestionString = @"Take a trip to somewhere fun today!";
    }
    else if ([activityCategory isEqualToString:@"trails"]) {
        suggestionString = @"Today's perfect for a hike!";
    }
    else {
        suggestionString = [NSString stringWithFormat:@"It's a great day to visit a %@!", activityCategory];
    }
    return suggestionString;
}
@end
