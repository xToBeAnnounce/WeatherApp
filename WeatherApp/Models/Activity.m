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

@end
