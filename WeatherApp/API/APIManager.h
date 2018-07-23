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
-(void)setURLWithLatitude:(double)lat Longitude:(double)lng Range:(NSString*)range;
- (void)getDataWithCompletion:(void(^)(NSDictionary *data, NSError *error))completion;
@end
