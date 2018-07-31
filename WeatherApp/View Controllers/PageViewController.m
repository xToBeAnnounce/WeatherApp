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
#import "NavigationController.h"
#import "SWRevealViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) NSArray *viewControllerArrary;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *locViewArrary;
@property (strong, nonatomic) UIViewController *placeholderScreen;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong, nonatomic) UIButton *locationDetailsButton;

@end

@implementation PageViewController

BOOL currentLocation;
BOOL settingUpLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    
    self.locViewArrary = [[NSMutableArray alloc] init];
    currentLocation = NO;
    
    SWRevealViewController *revealController = [self.navDelegate getRevealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    [self.navDelegate setLeftBarItem:revealButtonItem];
    
    [self setUI];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLocations];
    [self updateUserPreferences];
}

/*------------------SET UI METHODS------------------*/
- (void) makePlaceHolderScreen {
    // creating placeholder view controller
    self.placeholderScreen = [[UIViewController alloc] init];
//    self.placeholderScreen.view.backgroundColor = [UIColor blueColor];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Please wait while your locations are loading";
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.placeholderScreen.view addSubview:self.placeholderLabel];
    
    [self.locViewArrary addObject:self.placeholderScreen];
  
    currentLocation = NO;
    
    [self refreshPageViewWithStartIndex:0];
}

- (void) setConstraints {
    [self.placeholderLabel.centerXAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerXAnchor].active = YES;
    [self.placeholderLabel.centerYAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerYAnchor].active = YES;
    [self.locationDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-2].active = YES;
    [self.locationDetailsButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-2].active = YES;
    [self.locationDetailsButton.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.locationDetailsButton.widthAnchor constraintEqualToAnchor:self.locationDetailsButton.heightAnchor].active = YES;
}

- (void) setUI {
    self.DailyWeeklySC = [self.navDelegate getDailyWeeklySegmentControl];
    self.DailyWeeklySC.selectedSegmentIndex = 0;
    
    self.locationDetailsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.locationDetailsButton addTarget:self action:@selector(didTapLocDetails:) forControlEvents:UIControlEventTouchUpInside];
    self.locationDetailsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationDetailsButton.hidden = YES;
    [self.view addSubview:self.locationDetailsButton];
    
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    [self makePlaceHolderScreen];
    [self setConstraints];
    
    [self refreshPageViewWithStartIndex:0];
}

/*------------------PAGE VIEW CONTROLLER DELEGATE METHODS------------------*/
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
    return [self currentPageIndex];
}

/*-----------------REMOVING/ADDING SCREENS-----------------*/
- (void) removeCurrentLocationScreen {
    UIViewController *startingVC = self.locViewArrary[0];
    if ([startingVC.class isEqual:LocationWeatherViewController.class]) {
        LocationWeatherViewController *locVC = (LocationWeatherViewController *)startingVC;
        if (!locVC.location.objectId) {
            [self.locViewArrary removeObject:locVC];
        }
    }
}

- (void) addPlaceholderIfNeeded {
    if (self.locViewArrary.count == 0) {
        self.locationDetailsButton.hidden = YES;
        
        self.placeholderLabel.text = @"Add some locations!";
        self.placeholderLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightThin];
        [self.placeholderLabel sizeToFit];
        [self.locViewArrary addObject:self.placeholderScreen];
    }
}

- (IBAction)didTapLocDetails:(id)sender {
    if ([self.viewControllers[0] isKindOfClass:LocationWeatherViewController.class]) {
        LocationWeatherViewController *locWeatherVC = self.viewControllers[0];
        if (!locWeatherVC.location.objectId) {
            [self alertControllerWithTitle:@"Nice Try" message:@"I won't show this page." btnText:@"OK"];
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
    [self addPlaceholderIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[self.locViewArrary[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        if (finished) [weakSelf.view bringSubviewToFront:weakSelf.locationDetailsButton];
    }];
}

-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message btnText:(NSString *)btnText{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *button = [UIAlertAction actionWithTitle:btnText style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:button];
    [self presentViewController:alert animated:YES completion:nil];
}

- (int)currentPageIndex {
    if (self.viewControllers.count > 0) {
        int index = (int)[self.locViewArrary indexOfObject:self.viewControllers[0]];
        if (index != -1) return index;
        else return 0;
    }
    else {
        return 0;
    }
}

- (void) updateLocations {
    self.view.userInteractionEnabled = NO;
//    [self reorderLocations];
    NSRange locRange = NSMakeRange(currentLocation, self.locViewArrary.count - currentLocation);
    NSArray *userLocsArray = [self.locViewArrary subarrayWithRange:locRange];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"self isKindOfClass: %@", LocationWeatherViewController.class];
    userLocsArray = [userLocsArray filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *newLocationIds = [User.currentUser.locationsIDArray mutableCopy];
    
    
    for (LocationWeatherViewController *locWVC in userLocsArray) {
        if (![User.currentUser.locationsIDArray containsObject:locWVC.location.objectId]) {
            [self.locViewArrary removeObject:locWVC];
        }
        else {
            [newLocationIds removeObject:locWVC.location.objectId];
        }
    }
    
    [User.currentUser getLocationsArrayInBackgroundWithBlock:^(NSMutableArray *locations, NSError *error) {
        if (locations) {
            [self.locViewArrary removeObject:self.placeholderScreen];
            for (LocationWeatherViewController *locWVC in self.locViewArrary) {
                NSLog(@"%@", locWVC.location);
            }
            
            for (int i=0; i<locations.count; i++) {
                
                Location *loc = locations[i];
                int viewIndex = i + currentLocation;
                
                if ([newLocationIds containsObject:loc.objectId]) {
                    LocationWeatherViewController *newLocationWVC = [[LocationWeatherViewController alloc] initWithLocation:loc segmentedControl:self.DailyWeeklySC locDetailsButton:self.locationDetailsButton];
                    [self.locViewArrary insertObject:newLocationWVC atIndex:viewIndex];
                }
                else {
                    LocationWeatherViewController *locWVC = self.locViewArrary[viewIndex];
                    locWVC.location = loc;
                }
            }
            [self refreshPageViewWithStartIndex:[self currentPageIndex]];
        }
        else {
            [self alertControllerWithTitle:@"Error" message:error.localizedDescription btnText:@"OK"];
        }
    }];
    self.view.userInteractionEnabled = YES;
}

- (void) updateUserPreferences {
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            // current location is on (updates current loc every time returns to page)
            if (pref.locationOn && !currentLocation) {
                // Remove current location screen if it exists
                [self removeCurrentLocationScreen];
                [self.locViewArrary removeObject:self.placeholderScreen];
                
                // Add new current location screen
                LocationWeatherViewController *currentLocVC = [[LocationWeatherViewController alloc] initWithLocation:Location.currentLocation segmentedControl:self.DailyWeeklySC  locDetailsButton:self.locationDetailsButton];
                [self.locViewArrary insertObject:currentLocVC atIndex:0];
            }
            // current location switched from on to off
            else if (!pref.locationOn && currentLocation){
                [self removeCurrentLocationScreen];
            }
            currentLocation = pref.locationOn;
            [self refreshPageViewWithStartIndex:[self currentPageIndex]];
            settingUpLocations = NO;
        }
        else {
            [self alertControllerWithTitle:@"Error" message:error.localizedDescription btnText:@"OK"];
        }
    }];
}

- (void) reorderLocations {
    
}
<<<<<<< Updated upstream
=======

- (IBAction)toggleScreens:(id)sender{
    SWRevealViewController *revealController = [self.navDelegate getRevealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [revealController revealToggle:sender];
    SettingsViewController *settingsVC = (SettingsViewController *)revealController.rearViewController;

    if (revealController.frontViewPosition == FrontViewPositionRight) {
       // [settingsVC loadPreferences];
        self.navigationController.navigationBar.topItem.title = @"Settings";
        self.navigationController.navigationBar.topItem.leftBarButtonItem.image = [UIImage imageNamed:@"close"];
    }
    else {
     //   [settingsVC.tooHotTextField resignFirstResponder];
     //   [settingsVC.tooColdTextField resignFirstResponder];
        self.navigationController.navigationBar.topItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
        self.navigationController.navigationBar.topItem.titleView = self.DailyWeeklySC;
        self.navigationController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
    }
}

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self.navigationController presentViewController:locationNavVC animated:YES completion:nil];
}
>>>>>>> Stashed changes
@end

