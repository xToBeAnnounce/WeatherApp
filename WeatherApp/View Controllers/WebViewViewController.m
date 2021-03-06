//
//  WebViewViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/31/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WebViewViewController.h"
#import "MBProgressHUD.h"


@interface WebViewViewController ()
@property (strong, nonatomic) Location *location;
@property (strong,nonatomic) WKWebView *mapWV;
@end

@implementation WebViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapWV = [[WKWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        self.mapWV.navigationDelegate = self;
        [self.view addSubview:self.mapWV];
        
        [MBProgressHUD showHUDAddedTo:self.mapWV animated:YES];
    }
    return self;
}

- (instancetype) initWithLocation:(Location *)location {
    self = [self init];
    self.location = location;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.location) self.location = Location.currentLocation;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationUI];
    [self loadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationUI {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.topItem.titleView = nil;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.topItem.title = @"Map";
    self.navigationController.navigationBar.topItem.leftBarButtonItem.tintColor = self.view.tintColor;
    
    if (!self.navigationController.navigationBar.topItem.leftBarButtonItem) {
        self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onTapClose:)];
    }
    
}

- (void) loadMap {
    NSString *urlString = [@"https://maps.darksky.net/" stringByAppendingString:[NSString stringWithFormat:@"@temperature,%f,%f,9", self.location.lattitude, self.location.longitude]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            [self.mapWV loadRequest:request];
        }
    }];
    
    [task resume];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.mapWV animated:YES];
}

- (IBAction)onTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
