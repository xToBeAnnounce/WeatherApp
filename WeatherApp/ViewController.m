//
//  ViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onTapTestAPI) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Test API" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
}

- (void)onTapTestAPI{
    [[APIManager shared] getDataWithLatitude:42.3601 Longitude: -71.0589 WithCompletion:^(NSDictionary *data, NSError *error) {
        if(error != nil){
            NSLog(@"%@", data);
        }
        else{
            NSLog(@"FAILED");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
