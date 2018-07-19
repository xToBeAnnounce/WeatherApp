//
//  GeoAPIManager.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "GeoAPIManager.h"

@implementation GeoAPIManager

static NSString * const baseURLString = @"https://secure.geonames.org/";
static NSString * const usernameKey = @"&username=ttj_weather_app";
static NSString * urlString;

+ (instancetype)shared {
    static GeoAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) getNearestAddressOfLattitude:(double)lat longitude:(double)lng completion:(void(^)(NSDictionary *data, NSError *error))completion{
    NSString *callParameters = [NSString stringWithFormat:@"findNearestAddressJSON?lat=%f&lng=%f", lat, lng];
    urlString = [baseURLString stringByAppendingString:[callParameters stringByAppendingString:usernameKey]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
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
}

- (void) searchForLocationByName:(NSString *)searchString withOffset:(int)offset withCompletion:(void(^)(NSDictionary *data, NSError *error))completion{
    NSString *callParameters = [NSString stringWithFormat:@"searchJSON?name=%@&maxRows=20&startRow=%d", searchString, offset];
    urlString = [baseURLString stringByAppendingString:[callParameters stringByAppendingString:usernameKey]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
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
}
@end
