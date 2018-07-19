//
//  GeoAPIManager.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoAPIManager : NSObject

+ (instancetype)shared;
- (void) getNearestAddressOfLattitude:(double)lat longitude:(double)lng completion:(void(^)(NSDictionary *data, NSError *error))completion;
- (void) searchForLocationByName:(NSString *)searchString withOffset:(int)offset withCompletion:(void(^)(NSDictionary *data, NSError *error))completion;

@end
