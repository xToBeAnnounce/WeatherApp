//
//  PageViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/20/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "PageViewController.h"
#import "Weather.h"
#import "LocationWeatherViewController.h"
#import "LocationPickerViewController.h"
#import "LocationDetailsViewController.h"
#import "WebViewViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) Preferences *preferences;

@property (strong,nonatomic) UNUserNotificationCenter *notificationCenter;

@property (strong, nonatomic) NSMutableArray *locViewArray;

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
BOOL settingUpLocations;
BOOL alertShown;
BOOL isgranted;

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;
    
    self.locViewArray = [[NSMutableArray alloc] init];
    settingUpLocations = YES;
    
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.preferences = pref;
        }
        else {
            [self alertControllerWithTitle:@"Error" message:error.localizedDescription btnText:@"OK"];
        }
    }];
    
    [self notificationSetUp];
    [self setUI];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarUI];
    [self updateLocations];
    if (self.preferences.learningOn && !alertShown) [self presentLearnAlertWithCompletion: nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*----------------NOTIFICATION METHODS----------------*/
- (void) notificationSetUp {
    //Notification Set UP
    self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [self.notificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isgranted = granted;
    }];
}

- (void) presentPreferenceNotification{
    if(self.preferences.notificationsOn && isgranted){
        LocationWeatherViewController *locWVC = [self currentWeatherVC];
        Weather *weather = [locWVC.location.dailyData firstObject];
        
        if (locWVC.location && weather) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
            content.title = @"Good Morning";
            NSString *bodyText = [NSString stringWithFormat:@"%@ is ", locWVC.location.placeName];
            
            if (weather.temperature > [self.preferences.tooHotTemp intValue]) {
                bodyText = [bodyText stringByAppendingString:@"hot today. Wear some shorts!"];
            }
            else if (weather.temperature < [self.preferences.tooColdTemp intValue]) {
                bodyText = [bodyText stringByAppendingString:@"cold today. Grab a jacket!"];
            }
            else {
                bodyText = [bodyText stringByAppendingString:[NSString stringWithFormat:@"a nice %@. Enjoy the weather!",[weather getTempInString:weather.temperature withType:self.preferences.tempTypeString]]];
            }
            
            content.body = bodyText;
            content.sound = [UNNotificationSound defaultSound];
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UNrequest" content:content trigger:trigger];
            
            [self.notificationCenter addNotificationRequest:request withCompletionHandler:nil];
        }
    }
}

/*------------------SET UI METHODS------------------*/
// initalizes placeholder screen and contents
- (void) makePlaceHolderScreen {
    // creating placeholder view controller
    self.placeholderScreen = [[UIViewController alloc] init];
    
    self.placeholderLabel = [[UILabel alloc] init];
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
    
    [self.locViewArray addObject:self.placeholderScreen];
    
    [self refreshPageViewWithStartIndex:0];
}

- (void) setNavigationBarUI {
    self.navigationController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
    self.navigationController.navigationBar.topItem.titleView = self.DailyWeeklySC;
    [self.DailyWeeklySC addTarget:self action:@selector(onToggleDailyWeekly) forControlEvents:UIControlEventValueChanged];
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

// Initalizes controls and placeholder screen, sets view background color
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
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    UIViewController *vc = self.locViewArray[index];
    return vc;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.locViewArray indexOfObject:viewController];
    if (index < self.locViewArray.count - 1) {
        return [self viewControllerAtIndex:index+1];
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.locViewArray indexOfObject:viewController];
    if (index  > 0   ) {
        return [self viewControllerAtIndex:index-1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.locViewArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return [self currentPageIndex];
}


/*------------------PAGEVC NAVIGATION METHODS------------------*/
// gets index of current page in self.locviewarray
- (int)currentPageIndex {
    if (self.viewControllers.count > 0) {
        int index = (int)[self.locViewArray indexOfObject:self.viewControllers[0]];
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

- (void) refreshPageViewWithStartIndex:(int) index {
    [self addPlaceholderIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[self.locViewArray[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.view bringSubviewToFront:weakSelf.locationDetailsButton];
            [weakSelf.view bringSubviewToFront:weakSelf.mapButton];
        }
    }];
}

/*-----------------REMOVING/ADDING SCREENS-----------------*/
// removes current location weather screen if one exists
- (void) removeCurrentLocationScreen {
    UIViewController *startingVC = self.locViewArray[0];
    if ([startingVC.class isEqual:LocationWeatherViewController.class]) {
        LocationWeatherViewController *locVC = (LocationWeatherViewController *)startingVC;
        if (!locVC.location.objectId) {
            [self.locViewArray removeObject:locVC];
        }
    }
}

// removes location weather screen that has expired and shows an alert to the user
- (void) removeExpiredLocScreen:(LocationWeatherViewController *)locWVC {
    [self alertControllerWithTitle:@"Expired Location" message:[NSString stringWithFormat:@"%@ has expired and was deleted.", locWVC.location.customName] btnText:@"OK"];
    
    [User.currentUser deleteLocationWithID:locWVC.location.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded ){
            [self.locViewArray removeObject:locWVC];
            [self refreshPageViewWithStartIndex:[self currentPageIndex]];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

// adds placeholder screen if no locations
- (void) addPlaceholderIfNeeded {
    if (self.locViewArray.count == 0) {
        self.locationDetailsButton.hidden = YES;
        self.placeholderButton.hidden = NO;
        [self.locViewArray addObject:self.placeholderScreen];
    }
}

/*-----------------UPDATE VIEW METHODS-----------------*/
// Updates view whenever self.preferences is set
-(void) setPreferences:(Preferences *)pref {
    // current location is on (updates current loc every time returns to page)
    if (pref.locationOn && !_preferences.locationOn) {
        // Remove current location screen if it exists
        [self.loadingActivityIndicator stopAnimating];
        [self removeCurrentLocationScreen];
        [self.locViewArray removeObject:self.placeholderScreen];
        
        // Add new current location screen
        LocationWeatherViewController *currentLocVC = [[LocationWeatherViewController alloc] initWithLocation:Location.currentLocation segmentedControl:self.DailyWeeklySC  locDetailsButton:self.locationDetailsButton];
        [self.locViewArray insertObject:currentLocVC atIndex:0];
    }
    // current location switched from on to off
    else if (!pref.locationOn && _preferences.locationOn){
        [self removeCurrentLocationScreen];
    }
    
    // updating tempterature type
    for (LocationWeatherViewController *locWVC in [self.locViewArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"self isKindOfClass: %@", LocationWeatherViewController.class]]) {
        locWVC.tempTypeString = pref.tempTypeString;
    }
    
    // If learning was switched from off to on
    if (_preferences.learningOn && pref.learningOn) alertShown = NO;
    
    _preferences = pref;
    [self presentPreferenceNotification];
    [self refreshPageViewWithStartIndex:[self currentPageIndex]];
    settingUpLocations = NO;
    
}

// Updates locations displayed on screen
- (void) updateLocations {
    self.view.userInteractionEnabled = NO;
    
    // Makes userLocsArray - array of just the user's stored locations (excludes current location and placeholder screen)
    BOOL currentLocation = self.preferences.locationOn;
    NSRange locRange = NSMakeRange(currentLocation, self.locViewArray.count - currentLocation);
    NSArray *userLocsArray = [self.locViewArray subarrayWithRange:locRange];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"self isKindOfClass: %@", LocationWeatherViewController.class];
    userLocsArray = [userLocsArray filteredArrayUsingPredicate:predicate];
    
    // holds ids of added locations not displayed on screen
    NSMutableArray *newLocationIds = [User.currentUser.locationsIDArray mutableCopy];
    
    // removes locations no longer found in User location ID array
    for (LocationWeatherViewController *locWVC in userLocsArray) {
        if (![User.currentUser.locationsIDArray containsObject:locWVC.location.objectId]) {
            [self.locViewArray removeObject:locWVC];
        }
        else {
            [newLocationIds removeObject:locWVC.location.objectId];
        }
    }
    
    // Gets array of user's saved locations from backend
    [User.currentUser getLocationsArrayInBackgroundWithBlock:^(NSMutableArray *locations, NSError *error) {
        if (locations) {
            [self.loadingActivityIndicator stopAnimating];
            [self.locViewArray removeObject:self.placeholderScreen];
            // Stores location screen currently on display that have expired
            NSMutableArray *expiredLocationScreens = [[NSMutableArray alloc] init];
            
            for (int i=0; i<locations.count; i++) {
                Location *loc = locations[i];
                int viewIndex = i + self.preferences.locationOn; // corresponding view
                
                // if this location has been added since the last time user saw page view controller
                if ([newLocationIds containsObject:loc.objectId]) {
                    LocationWeatherViewController *newLocationWVC = [[LocationWeatherViewController alloc] initWithLocation:loc segmentedControl:self.DailyWeeklySC locDetailsButton:self.locationDetailsButton];
                    [self.locViewArray insertObject:newLocationWVC atIndex:viewIndex];
                }
                else {
                    LocationWeatherViewController *locWVC = self.locViewArray[viewIndex];
                    
                    // check if expired location
                    NSComparisonResult endDateCompare = [NSCalendar.currentCalendar compareDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24] toDate:loc.endDate toUnitGranularity:NSCalendarUnitDay];
                    if (loc.endDate && endDateCompare != NSOrderedAscending) {
                        [expiredLocationScreens addObject:locWVC];
                    }
                    locWVC.location = loc;
                }
            }
            
            // removes expired screens
            for (LocationWeatherViewController *locWVC in expiredLocationScreens) {
                [self removeExpiredLocScreen:locWVC];
            }
            settingUpLocations = NO;
            [self refreshPageViewWithStartIndex:[self currentPageIndex]];
            self.view.userInteractionEnabled = YES;
        }
        else {
            [self alertControllerWithTitle:@"Error" message:error.localizedDescription btnText:@"OK"];
        }
    }];
}

/*-------------------CONTROL SELECTORS-------------------*/
// controls behavior for location detail button and map button
- (IBAction)didTapBottomButton:(id)sender {
    LocationWeatherViewController *locWeatherVC = [self currentWeatherVC];
    
    if (locWeatherVC.location) {
        UIViewController *segueVC = [[UIViewController alloc] init];
        
        if ([sender isEqual:self.locationDetailsButton]) {
            LocationDetailsViewController *locDetailsVC = [[LocationDetailsViewController alloc] init];
            locDetailsVC.location = locWeatherVC.location;
            locDetailsVC.saveNewLocation = NO;
            segueVC = locDetailsVC;
        }
        else if ([sender isEqual:self.mapButton]) {
            WebViewViewController *mapWVC = [[WebViewViewController alloc] initWithLocation:locWeatherVC.location];
            segueVC = mapWVC;
        }
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:segueVC] animated:YES completion:nil];
    }
}

// When location details button is tapped
-(void)segueToAddLocation{
    LocationPickerViewController *locationVC = LocationPickerViewController.new;
    UINavigationController *locationNavVC = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self.navigationController presentViewController:locationNavVC animated:YES completion:nil];
}

// When segmented control is toggled
- (void) onToggleDailyWeekly {
    if (self.DailyWeeklySC.selectedSegmentIndex == 1) {
        LocationWeatherViewController *locWVC = [self currentWeatherVC];
        if (locWVC.location) {
            [locWVC showBannerIfNeededWithCompletion:nil];
        }
    }
}

/*-------------ALERT CONTROLLER METHODS----------------*/
// alert controller with title, message, and one button
-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message btnText:(NSString *)btnText{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *button = [UIAlertAction actionWithTitle:btnText style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:button];
    [self presentViewController:alert animated:YES completion:nil];
}

// Learn from me alert controller
- (void) presentLearnAlertWithCompletion:(void(^)(void))completion{
    LocationWeatherViewController *locWVC = self.locViewArray[0];
    
    if (![locWVC isEqual:self.placeholderScreen] && locWVC.location.placeName) {
        NSString *message = [NSString stringWithFormat:@"How did %@'s weather feel today?", locWVC.location.placeName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Data" message:message preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *hotAction = [UIAlertAction actionWithTitle:@"Hot" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:hotAction];
        
        UIAlertAction *coldAction = [UIAlertAction actionWithTitle:@"Cold" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:coldAction];
        
        UIAlertAction *perfectAction = [UIAlertAction actionWithTitle:@"Perfect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:perfectAction];
        
        [self presentViewController:alert animated:YES completion:completion];
        
        alertShown = YES;
    }
}
@end

