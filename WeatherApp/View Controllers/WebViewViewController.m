//
//  WebViewViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/31/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WebViewViewController.h"
#import "Location.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"


@interface WebViewViewController ()
@property (strong,nonatomic) WKWebView *mapWV;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.navigationController.navigationBar.topItem.titleView = nil;
    self.navigationController.navigationBar.topItem.title = @"Map";
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    Location *location = Location.currentLocation;
    NSString *urlString = [@"https://maps.darksky.net/" stringByAppendingString:[NSString stringWithFormat:@"@temperature,%f,%f,10", location.lattitude, location.longitude]];
    NSURL *url = [NSURL URLWithString:urlString];
    self.mapWV = [[WKWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.mapWV];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
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
            [self.mapWV loadRequest:request];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
