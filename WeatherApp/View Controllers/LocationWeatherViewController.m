//
//  LocationWeatherViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationWeatherViewController.h"

@interface LocationWeatherViewController ()

@end

@implementation LocationWeatherViewController


- (instancetype) initWithLocation:(Location *)location {
    self.location = location;
    self.view.backgroundColor = [UIColor redColor];
    
    self.locLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [self.view addSubview:self.locLabel];
    
    [self setUI];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUI {
    self.locLabel.text = self.location.customName;
    [self.locLabel sizeToFit];
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
