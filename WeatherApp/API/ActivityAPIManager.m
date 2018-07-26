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
static NSInteger const radius = 1500; //meters
static NSString const * APIKey = @"AIzaSyB86_L5XQl5ot4iBMXeYBcnpTXdMTA_67o";
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

-(void)getActivityDataWithLocation:(NSArray*)location Type:(NSString*)type Keyword:(NSString*)keyword WithCompletion:(void(^)(NSDictionary *data, NSError *error))completion{
    urlString = @"";
    NSString *parameters = [NSString stringWithFormat:@"location=%@,%@&radius=%ld&type=%@&keyword=%@&key=%@", location[0], location[1], (long)radius, type, keyword, APIKey];
    urlString = [baseURL stringByAppendingString:parameters];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                completion(nil, error);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completion(dataDictionary, nil);
            }
        }];
        [task resume];
    });
}

@end