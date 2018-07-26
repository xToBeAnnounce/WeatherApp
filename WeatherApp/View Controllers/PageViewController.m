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
#import "LocationWeatherViewController.h"
#import "LocationDetailsViewController.h"
#import "User.h"

@interface PageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) NSArray *viewControllerArrary;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *locViewArrary;
@property (strong, nonatomic) UIViewController *placeholderScreen;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC ;
@property (strong, nonatomic) UIButton *locationDetailsButton;

@end

@implementation PageViewController

BOOL currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locViewArrary = [[NSMutableArray alloc] init];
    
    self.DailyWeeklySC = (UISegmentedControl *)self.navigationController.navigationBar.topItem.titleView;
    
    self.locationDetailsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.locationDetailsButton addTarget:self action:@selector(didTapLocDetails:) forControlEvents:UIControlEventTouchUpInside];
    self.locationDetailsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.locationDetailsButton];
    
    [self.locationDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-2].active = YES;
    [self.locationDetailsButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-2].active = YES;
    [self.locationDetailsButton.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.locationDetailsButton.widthAnchor constraintEqualToAnchor:self.locationDetailsButton.heightAnchor].active = YES;
    
    self.dataSource = self;
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    [self initalizePlaceHolderScreen];
    
    [self refreshPageViewWithStartIndex:0];
}

- (void) initalizePlaceHolderScreen {
    // creating placeholder view controller
    self.placeholderScreen = [[UIViewController alloc] init];
    self.placeholderScreen.view.backgroundColor = [UIColor blueColor];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Please wait while your locations are loading";
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.placeholderScreen.view addSubview:self.placeholderLabel];
    [self.placeholderLabel.centerXAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerXAnchor].active = YES;
    [self.placeholderLabel.centerYAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerYAnchor].active = YES;
    
    [self.locViewArrary addObject:self.placeholderScreen];
    currentLocation = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            currentLocation = pref.locationOn;
            if (pref.locationOn) {
              
                LocationWeatherViewController *currentLocVC = [[LocationWeatherViewController alloc] initWithLocation:Location.currentLocation segmentedControl:self.DailyWeeklySC];


                [self.locViewArrary insertObject:currentLocVC atIndex:0];
                [self.locViewArrary removeObject:self.placeholderScreen];
            }
            else {
                [self removeCurrentLocationScreen];
            }
            [self refreshPageViewWithStartIndex:0];
        }
        else {
        }
    }];
    
    
    [User.currentUser getLocationsArrayInBackgroundWithBlock:^(NSMutableArray *locations, NSError *error) {
        if (locations) {
            // If current location on, removes every screen after first, else removes all screeens
            NSRange locRange = (currentLocation) ?NSMakeRange(1, self.locViewArrary.count-1) : NSMakeRange(0, self.locViewArrary.count);
            
            [self.locViewArrary removeObjectsInRange:locRange];
            for (Location *loc in locations) {
                LocationWeatherViewController *newLocVC = [[LocationWeatherViewController alloc] initWithLocation:loc segmentedControl:self.DailyWeeklySC];
                [self.locViewArrary addObject:newLocVC];
            }
            
            [self.locViewArrary removeObject:self.placeholderScreen];
            [self addPlaceholderIfNeeded];
            [self refreshPageViewWithStartIndex:0];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIPageViewController *pagecontentVC = pageViewController.viewControllers[0];
    self.pageControl.currentPage = [self.locViewArrary indexOfObject:pagecontentVC];
    
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    UIViewController *vc = self.locViewArrary[index];
    return vc;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.locViewArrary indexOfObject:viewController];
    if (index < self.locViewArrary.count - 1) {
        return [self viewControllerAtIndex:index+1];
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.locViewArrary indexOfObject:viewController];
    if (index  > 0   ) {
        return [self viewControllerAtIndex:index-1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.locViewArrary.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void) removeCurrentLocationScreen {
    UIViewController *startingVC = self.locViewArrary[0];
    if ([startingVC.class isEqual:LocationWeatherViewController.class]) {
        LocationWeatherViewController *locVC = (LocationWeatherViewController *)startingVC;
        if (!locVC.location.objectId) {
            [self.locViewArrary removeObject:locVC];
            [self addPlaceholderIfNeeded];
        }
    }
}

- (void) addPlaceholderIfNeeded {
    if (self.locViewArrary.count == 0) {
        self.placeholderLabel.text = @"Add some locations!";
        [self.placeholderLabel sizeToFit];
        [self.locViewArrary addObject:self.placeholderScreen];
    }
}

- (IBAction)didTapLocDetails:(id)sender {
    if ([self.viewControllers[0] isKindOfClass:LocationWeatherViewController.class]) {
        LocationWeatherViewController *locWeatherVC = self.viewControllers[0];
        if (!locWeatherVC.location.objectId) {
            [self alertController:@"I won't show this page."];
        }
        else {
            LocationDetailsViewController *locDetailsVC = [[LocationDetailsViewController alloc] init];
            locDetailsVC.location = locWeatherVC.location;
            locDetailsVC.saveNewLocation = NO;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:locDetailsVC] animated:YES completion:nil];
//            [self.navigationController pushViewController:locDetailsVC animated:YES];
        }
    }
}

- (void) refreshPageViewWithStartIndex:(int) index {
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[self.locViewArrary[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        if (finished) [weakSelf.view bringSubviewToFront:weakSelf.locationDetailsButton];
    }];
}

-(void)alertController:(NSString *)message{
    NSString *title = @"Nice Try";
    NSString *text = @"OK";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *button = [UIAlertAction actionWithTitle:text style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:button];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

