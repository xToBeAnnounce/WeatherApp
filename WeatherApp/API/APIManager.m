//
//  APIManager.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.darksky.net/forecast/";
//static NSString * const consumerSecret = @"41cbd5a478f0e0165572447fdb67d4db/"; // Tiffany's
static NSString * const consumerSecret = @"d54d5c8906cd432065ed86b50f25049b/"; // Trustin's
//static NSString * const consumerSecret = @"bc3c4e45aa60ac2223c847786e4754dd/"; // Jamie's
static NSString * urlString;

@implementation APIManager

+ (instancetype)shared{
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init{
    urlString = @"";
    urlString = [baseURLString stringByAppendingString:consumerSecret];
    return self;
}

-(void)setURLWithLatitude:(double)lat Longitude:(double)lng Range:(NSString*)range{
    urlString = @"";
    urlString = [baseURLString stringByAppendingString:consumerSecret];
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f", lat, lng];
    urlString = [urlString stringByAppendingString:coordinateStr];
    
    if([range isEqualToString:@"daily"]){
        urlString = [urlString stringByAppendingString:@"?exclude=currently,minutely,daily,alerts,flags"];
    }
    else if([range isEqualToString:@"weekly"]){
        urlString = [urlString stringByAppendingString:@"?exclude=currently,minutely,hourly,alerts,flags"];
    }
}

- (void)getDataWithCompletion:(void(^)(NSDictionary *data, NSError *error))completion{
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
                completion(dataDictionary, nil);
            }
        }];
        [task resume];
    });
}

@end
