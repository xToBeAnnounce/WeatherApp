//
//  APIManager.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.darksky.net/forecast/";
static NSString * const consumerSecret = @"41cbd5a478f0e0165572447fdb67d4db/";
static NSString * urlString;

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init{
    urlString = [baseURLString stringByAppendingString:consumerSecret];
    return self;
}

- (void)getDataWithLatitude:(int)lat Longitude:(int)lng WithCompletion:(void(^)(NSDictionary *data, NSError *error))completion{
    NSString *coordinateStr = [NSString stringWithFormat:@"%d,%d", lat, lng]; 
    
    urlString = [urlString stringByAppendingString:coordinateStr];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
            if (error != nil) {
                NSLog(@"ERROR");
                completion(nil, error);
            }
            else {
                NSLog(@"Worked");
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@", dataDictionary);
                completion(dataDictionary, nil);
            }
        }];
        [task resume];
    });
}

@end
