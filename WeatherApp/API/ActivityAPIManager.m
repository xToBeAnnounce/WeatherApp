//
//  ActivityAPIManager.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "ActivityAPIManager.h"

/*Sample API request: https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=LAT,LNG&radius=RADIUS_METERS&type=LOC_TYPE&keyword=KEYWORD&key=YOUR_API_KEY */
static NSString const * baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
static NSInteger const radius = 11265; //meters (about 7 miles)
static NSString const * APIKey = @"AIzaSyDgbVK8x7X-7tUEnIxOG44M42lXkHWlVCM";
static NSString * urlString = @"";

@implementation ActivityAPIManager

+ (instancetype)shared{
    static ActivityAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)getActivityDataWithLocation:(NSArray*)location Type:(NSString*)type WithCompletion:(void(^)(NSDictionary *data, NSError *error))completion{
    urlString = @"";
    NSString *activityName = [type stringByReplacingOccurrencesOfString:@"_" withString:@"+"];
    NSString *parameters = [NSString stringWithFormat:@"location=%@,%@&radius=%ld&keyword=%@&key=%@", location[0], location[1], (long)radius, activityName, APIKey];
    urlString = [baseURL stringByAppendingString:parameters];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                completion(nil, error);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completion(dataDictionary[@"results"], nil);
            }
        }];
        [task resume];
    });
}

@end
