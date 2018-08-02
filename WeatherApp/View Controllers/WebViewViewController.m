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
@property (strong,nonatomic) WKWebView *mapWV;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) Location *location;
@end

@implementation WebViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapWV = [[WKWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        [self.view addSubview:self.mapWV];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.mapWV animated:YES];
        self.hud.backgroundColor = [UIColor lightTextColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.location) self.location = Location.currentLocation;
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
            [MBProgressHUD hideHUDForView:self.mapWV animated:YES];
        }
    }];
    
    [task resume];
}

- (instancetype) initWithLocation:(Location *)location {
    self = [self init];
    self.location = location;
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadMap];
    
    self.navigationController.navigationBar.topItem.titleView = nil;
    self.navigationController.navigationBar.topItem.title = @"Map";
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    
    if (!self.navigationController.navigationBar.topItem.leftBarButtonItem) {
        self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onTapClose:)];
    }
}

- (IBAction)onTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
