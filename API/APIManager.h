//
//  APIManager.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
+ (instancetype)shared;
- (void)getDataWithLatitude:(int)lat Longitude:(int)lng WithCompletion:(void(^)(NSDictionary *data, NSError *error))completion;
@end
