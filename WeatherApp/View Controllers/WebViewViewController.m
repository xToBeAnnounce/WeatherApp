//
//  WebViewViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface WebViewViewController ()
@property (strong,nonatomic) WKWebView *mapView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[WKWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.mapView];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSURL *url = [NSURL URLWithString:@"https://maps.darksky.net/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            [self.mapView loadRequest:request];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
