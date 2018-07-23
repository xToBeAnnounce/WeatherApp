//
//  PageViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/20/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "PageViewController.h"
#import "DailyViewController.h"
#import "WeeklyViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource>

@property WeeklyViewController *weeklyVC;
@property DailyViewController *dailyVC;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:self.dailyVC, self.weeklyVC, nil];
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(UIViewController *)viewControllerAtIndex:(NSUInteger)index{
//    self.dailyVC = [[DailyViewController alloc] init];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    return nil;
    
}



@end
