//
//  GeoAPIManager.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "GeoAPIManager.h"

@implementation GeoAPIManager

static NSString * const baseURLString = @"https://api.darksky.net/forecast/";
static NSString * const consumerSecret = @"41cbd5a478f0e0165572447fdb67d4db/";
static NSString * urlString;

+ (instancetype)shared {
    static GeoAPIManager *sharedManager = nil;
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

-(void)setURLWithLatitude:(double)lat Longitude:(double)lng Time:(NSDate*)date Range:(NSString*)range{
    urlString = @"";
    urlString = [baseURLString stringByAppendingString:consumerSecret];
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f", lat, lng];
    urlString = [urlString stringByAppendingString:coordinateStr];
    
    if(date != nil){
        NSTimeInterval timeDiff = [date timeIntervalSince1970];
        NSInteger timeDiffInt = timeDiff;
        NSString *timeDiffStr = [NSString stringWithFormat:@",%ld", (long)timeDiffInt];
        urlString = [urlString stringByAppendingString:timeDiffStr];
    }
    if(range != nil){
        if([range isEqualToString:@"daily"]){
            //Excluded alerts for now, contains data for hourly per day and currently
            urlString = [urlString stringByAppendingString:@"?exclude=minutely,daily,alerts,flags"];
        }
        else if([range isEqualToString:@"weekly"]){
            urlString = [urlString stringByAppendingString:@"?exclude=minutely,hourly,alerts,flags"];
        }
    }
    NSLog(@"%@", urlString);
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
