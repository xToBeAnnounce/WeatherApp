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

@interface PageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic) NSArray *viewControllerArrary;
@property (strong,nonatomic) UIPageControl *pageControl;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.navController = [[UINavigationController alloc]initWithRootViewController:self];
    
    DailyViewController *dailyVC = [[DailyViewController alloc]init];
    WeeklyViewController *weeklyVC = [[WeeklyViewController alloc]init];
    
    self.viewControllerArrary = @[dailyVC, weeklyVC];
    [self setViewControllers:@[dailyVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self configurePageControl];
}

-(void)configurePageControl{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 630 , UIScreen.mainScreen.bounds.size.width, 50)];
    self.pageControl.numberOfPages = self.viewControllerArrary.count;
    self.pageControl.currentPage = 0;
    self.pageControl.tintColor = UIColor.blackColor;
    self.pageControl.backgroundColor = UIColor.blueColor;
    self.pageControl.pageIndicatorTintColor = UIColor.blackColor;
    self.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
    [self.view addSubview:self.pageControl];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIPageViewController *pagecontentVC = pageViewController.viewControllers[0];
    self.pageControl.currentPage = [self.viewControllerArrary indexOfObject:pagecontentVC];
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    UIViewController *vc = self.viewControllerArrary[index];
    return vc;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllerArrary indexOfObject:viewController];
    if (index < self.viewControllerArrary.count - 1) {
        return [self viewControllerAtIndex:index+1];
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllerArrary indexOfObject:viewController];
    if (index  > 0   ) {
        return [self viewControllerAtIndex:index-1];
    }
    return nil;
}

@end
