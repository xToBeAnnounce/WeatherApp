//
//  PageViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/20/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "PageViewController.h"
#import "User.h"
#import "Weather.h"
#import "NavigationController.h"
#import "LocationWeatherViewController.h"
#import "LocationPickerViewController.h"
#import "LocationDetailsViewController.h"
#import "WebViewViewController.h"
#import "SWRevealViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) UNUserNotificationCenter *notificationCenter;

@property (strong,nonatomic) NSArray *viewControllerArrary;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *locViewArrary;

@property (strong, nonatomic) UIViewController *placeholderScreen;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingActivityIndicator;
@property (strong, nonatomic) UIButton *placeholderButton;

@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong, nonatomic) UIButton *locationDetailsButton;
@property (strong, nonatomic) UIButton *mapButton;

@property (strong, nonatomic) UIBarButtonItem *addLocationButton;

@end

@implementation PageViewController

BOOL currentLocation;
BOOL settingUpLocations;
bool isgranted;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    isgranted = NO;
    
    self.locViewArrary = [[NSMutableArray alloc] init];
    currentLocation = NO;
    settingUpLocations = YES;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleScreens:)];
    [self.navDelegate setLeftBarItem:revealButtonItem WithNVC:self.navigationController];
    
    [self setUI];
    [self notificationSetUp];
}

- (void) notificationSetUp {
    //Notification Set UP
    self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [self.notificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isgranted = granted;
    }];
}

-(void) notification{
    if(isgranted){
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.title = @"title";
        content.subtitle = @"subtitle";
        content.body = @"body";
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UNrequest" content:content trigger:trigger];
        
        [self.notificationCenter addNotificationRequest:request withCompletionHandler:nil];
    }
}

- (void) notificationWithPreferences:(Preferences *)pref {
    if(isgranted){
        LocationWeatherViewController *locWVC = [self currentWeatherVC];
        Weather *weather = [locWVC.location.dailyData firstObject];
        
        if (locWVC.location && weather) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
            content.title = @"Good Morning";
            NSString *bodyText = [NSString stringWithFormat:@"%@ is ", locWVC.location.placeName];
            
            if (weather.temperature > [pref.tooHotTemp intValue]) {
                bodyText = [bodyText stringByAppendingString:@"hot today. Wear some shorts!"];
            }
            else if (weather.temperature < [pref.tooColdTemp intValue]) {
                bodyText = [bodyText stringByAppendingString:@"cold today. Grab a jacket!"];
            }
            else {
                bodyText = [bodyText stringByAppendingString:[NSString stringWithFormat:@"a nice %@. Enjoy the weather!",[weather getTempInString:weather.temperature withType:pref.tempTypeString]]];
            }
            
            content.body = bodyText;
            content.sound = [UNNotificationSound defaultSound];
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UNrequest" content:content trigger:trigger];
            
            [self.notificationCenter addNotificationRequest:request withCompletionHandler:nil];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarUI];
    [self refreshView];
//    [self notification];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*------------------SET UI METHODS------------------*/
- (void) makePlaceHolderScreen {
    // creating placeholder view controller
    self.placeholderScreen = [[UIViewController alloc] init];
    
    self.placeholderLabel = [[UILabel alloc] init];
//    self.placeholderLabel.text = @"Please wait while your locations are loading";
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.placeholderScreen.view addSubview:self.placeholderLabel];
    
    self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadingActivityIndicator startAnimating];
    [self.placeholderScreen.view addSubview:self.loadingActivityIndicator];
    
    self.placeholderButton = [[UIButton alloc] init];
    [self.placeholderButton setTitle:@"Add some locations" forState:UIControlStateNormal];
    [self.placeholderButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    self.placeholderButton.layer.cornerRadius = 7;
    self.placeholderButton.layer.borderColor = [self.view.tintColor CGColor];
    self.placeholderButton.layer.borderWidth = 1;
    [self.placeholderButton setContentEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    self.placeholderButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderButton.hidden = YES;
    [self.placeholderButton addTarget:self action:@selector(segueToAddLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.placeholderScreen.view addSubview:self.placeholderButton];
    
    [self.locViewArrary addObject:self.placeholderScreen];
  
    currentLocation = NO;
    
    [self refreshPageViewWithStartIndex:0];
}

- (void) setConstraints {
    [self.placeholderLabel.centerXAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerXAnchor].active = YES;
    [self.placeholderLabel.centerYAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerYAnchor].active = YES;
    
    [self.loadingActivityIndicator.centerXAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerXAnchor].active = YES;
    [self.loadingActivityIndicator.centerYAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerYAnchor].active = YES;
    
    [self.placeholderButton.centerXAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerXAnchor].active = YES;
    [self.placeholderButton.centerYAnchor constraintEqualToAnchor:self.placeholderScreen.view.centerYAnchor].active = YES;

    [self.locationDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-2].active = YES;
    [self.locationDetailsButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-2].active = YES;
    [self.locationDetailsButton.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.locationDetailsButton.widthAnchor constraintEqualToAnchor:self.locationDetailsButton.heightAnchor].active = YES;
    
    [self.mapButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-2].active = YES;
    [self.mapButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:2].active = YES;
    [self.mapButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [self.mapButton.widthAnchor constraintEqualToAnchor:self.mapButton.heightAnchor].active = YES;
}

- (void) setNavigationBarUI {
    self.navigationController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
    self.navigationController.navigationBar.topItem.titleView = self.DailyWeeklySC;
    [self.DailyWeeklySC addTarget:self action:@selector(onToggleDailyWeekly) forControlEvents:UIControlEventValueChanged];
}

- (void) setUI {
    self.addLocationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-1"] style:UIBarButtonItemStylePlain target:self action:@selector(segueToAddLocation)];
    
    self.DailyWeeklySC = [[UISegmentedControl alloc]initWithItems:@[@"Daily",@"Weekly"]];
    self.DailyWeeklySC.tintColor = UIColor.blackColor;
    self.DailyWeeklySC.selectedSegmentIndex = 0;
    
    self.mapButton = [[UIButton alloc] init];
    [self.mapButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    self.mapButton.contentMode = UIViewContentModeScaleAspectFit;
    self.mapButton.clipsToBounds = YES;
    [self.mapButton addTarget:self action:@selector(didTapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    self.mapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mapButton];
    
    self.locationDetailsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.locationDetailsButton addTarget:self action:@selector(didTapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void) removeExpiredLocScreen:(LocationWeatherViewController *)locWVC {
    [self alertControllerWithTitle:@"Expired Location" message:[NSString stringWithFormat:@"%@ has expired and was deleted.", locWVC.location.customName] btnText:@"OK"];
    
    [User.currentUser deleteLocationWithID:locWVC.location.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded ){
            [self.locViewArrary removeObject:locWVC];
            [self refreshPageViewWithStartIndex:[self currentPageIndex]];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void) addPlaceholderIfNeeded {
    if (self.locViewArrary.count == 0) {
        self.locationDetailsButton.hidden = YES;
        self.placeholderButton.hidden = NO;
        [self.locViewArrary addObject:self.placeholderScreen];
    }
}

- (IBAction)didTapBottomButton:(id)sender {
    LocationWeatherViewController *locWeatherVC = [self currentWeatherVC];
    if (locWeatherVC.location) {
        if ([sender isEqual:self.locationDetailsButton]) {
            LocationDetailsViewController *locDetailsVC = [[LocationDetailsViewController alloc] init];
            locDetailsVC.location = locWeatherVC.location;
            locDetailsVC.saveNewLocation = NO;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:locDetailsVC] animated:YES completion:nil];
        }
        else if ([sender isEqual:self.mapButton]) {
            WebViewViewController *mapWVC = [[WebViewViewController alloc] initWithLocation:locWeatherVC.location];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mapWVC] animated:YES completion:nil];
        }
    }
}

- (void) refreshPageViewWithStartIndex:(int) index {
    [self addPlaceholderIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[self.locViewArrary[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.view bringSubviewToFront:weakSelf.locationDetailsButton];
            [weakSelf.view bringSubviewToFront:weakSelf.mapButton];
        }
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

- (LocationWeatherViewController *)currentWeatherVC {
    if ([self.viewControllers[0] isKindOfClass:LocationWeatherViewController.class]) {
        return self.viewControllers[0];
    }
    else return LocationWeatherViewController.new;
}

- (void) updateLocations {
    self.view.userInteractionEnabled = NO;
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
            [self.loadingActivityIndicator stopAnimating];
            [self.locViewArrary removeObject:self.placeholderScreen];
            NSMutableArray *expiredLocationScreens = [[NSMutableArray alloc] init];
            
            for (int i=0; i<locations.count; i++) {
                Location *loc = locations[i];
                int viewIndex = i + currentLocation; // corresponding view
                
                if ([newLocationIds containsObject:loc.objectId]) {
                    LocationWeatherViewController *newLocationWVC = [[LocationWeatherViewController alloc] initWithLocation:loc segmentedControl:self.DailyWeeklySC locDetailsButton:self.locationDetailsButton];
                    [self.locViewArrary insertObject:newLocationWVC atIndex:viewIndex];
                }
                else {
                    LocationWeatherViewController *locWVC = self.locViewArrary[viewIndex];
                    
                    NSComparisonResult endDateCompare = [NSCalendar.currentCalendar compareDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24] toDate:loc.endDate toUnitGranularity:NSCalendarUnitDay];
                    
                    if (loc.endDate && endDateCompare != NSOrderedAscending) {
                        [expiredLocationScreens addObject:locWVC];
                    }
                    locWVC.location = loc;
                }
            }
            
            for (LocationWeatherViewController *locWVC in expiredLocationScreens) {
                [self removeExpiredLocScreen:locWVC];
            }
            settingUpLocations = NO;
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
            if (pref.notificationsOn) [self notificationWithPreferences:pref];
            // current location is on (updates current loc every time returns to page)
            if (pref.locationOn && !currentLocation) {
                // Remove current location screen if it exists
                [self removeCurrentLocationScreen];
                [self.loadingActivityIndicator stopAnimating];
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
            
            for (LocationWeatherViewController *locWVC in [self.locViewArrary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"self isKindOfClass: %@", LocationWeatherViewController.class]]) {
                locWVC.tempTypeString = pref.tempTypeString;
            }
        }
        else {
            [self alertControllerWithTitle:@"Error" message:error.localizedDescription btnText:@"OK"];
        }
    }];
}

- (void) reorderLocations {
    
}

- (IBAction)toggleScreens:(id)sender{
    SWRevealViewController *revealController = [self.navDelegate getRevealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [revealController revealToggle:sender];
}

-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self.navigationController presentViewController:locationNavVC animated:YES completion:nil];
}

- (void) refreshView {
    [self updateLocations];
    [self updateUserPreferences];
}

- (void) onToggleDailyWeekly {
    if (self.DailyWeeklySC.selectedSegmentIndex == 1) {
        LocationWeatherViewController *locWVC = [self currentWeatherVC];
        if (locWVC.location) {
            [locWVC showBannerIfNeededWithCompletion:nil];
        }
    }
}
    
@end

