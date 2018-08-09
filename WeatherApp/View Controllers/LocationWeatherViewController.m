//
//  LocationWeatherViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationWeatherViewController.h"
#import "NavigationController.h"
#import "User.h"
#import "ActivityViewController.h"
#import "DailyView.h"
#import "WeeklyView.h"
#import "WeatherView.h"

@interface LocationWeatherViewController () <UIPopoverPresentationControllerDelegate>
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong, nonatomic) UIButton *locationDetailsButton;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;
@property (strong,nonatomic) WeatherView *weatherView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@end

@implementation LocationWeatherViewController
{
    UIVisualEffectView *_blurEffectView;
}

- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC locDetailsButton:(UIButton *)locationsDetailsButton{
    [self setSubviews];
    self.location = location;
    
    self.DailyWeeklySC = DailyWeeklySC;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    [self selectedIndex];
    
    self.locationDetailsButton = locationsDetailsButton;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.bounds;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.weeklyView.selectedCell = nil;
    [User.currentUser getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tempTypeString = pref.tempTypeString;
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.locationDetailsButton.hidden = !self.location.objectId;
    [self setNavBarUI];
    
    if (!self.weeklyView.hidden) {
        [self showBannerIfNeededWithCompletion:nil];
    }
    
}

- (void)setTempTypeString:(NSString *)tempTypeString {
    _tempTypeString = tempTypeString;
    self.dailyView.tempType = tempTypeString;
    self.weeklyView.tempType = tempTypeString;
}

- (void) setSubviews {
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
    
    self.titleLabel = [[UILabel alloc]init];
    self.subtitleLabel = [[UILabel alloc]init];
//
//    self.dailyView = [[DailyView alloc]initWithFrame:self.view.frame];
//    self.dailyView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.dailyView];
//
//    self.weeklyView = [[WeeklyView alloc]initWithFrame:self.view.frame];
//    self.weeklyView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.weeklyView.delegate = self;
//    [self.view addSubview:self.weeklyView];
//
//    [self setConstraintsForView:self.dailyView];
//    [self setConstraintsForView:self.weeklyView];
    
    self.weatherView = [[WeatherView alloc]initWithFrame:self.view.frame];
    self.weatherView.translatesAutoresizingMaskIntoConstraints = NO;
    self.weatherView.activityDelegate = self;
    [self.view addSubview:self.weatherView];
    [self setConstraintsForView:self.weatherView];
}

- (void)setLocation:(Location *)location {
    _location = location;
//    self.dailyView.location = location;
//    self.weeklyView.location = location;
    self.weatherView.location = location;
    [self refreshNavBarTitle];
}

-(void)displayPopoverWithLocation:(Location*)loc weather:(Weather*)weather index:(int)idx{
    ActivityViewController *popoverView = [[ActivityViewController alloc] initWithLocation:loc weather:weather index:idx];
    popoverView.modalPresentationStyle = UIModalPresentationPopover;
    popoverView.preferredContentSize = CGSizeMake(self.view.frame.size.width-35, self.view.frame.size.height-125);
    
    UIPopoverPresentationController *popController = popoverView.popoverPresentationController;
    popController.delegate = self;
    popController.sourceView = self.view;
    popController.permittedArrowDirections = 0;
    popController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)+25,0,0);
    
    [self.view addSubview:_blurEffectView];
    [self presentViewController:popoverView animated:YES completion:nil];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [_blurEffectView removeFromSuperview];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(void)selectedIndex {
    self.dailyView.hidden = self.DailyWeeklySC.selectedSegmentIndex;
    self.weeklyView.hidden = !self.dailyView.hidden;
}

- (void) setConstraintsForView:(UIView *)view{
    [view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion{
    [self.weeklyView showBannerIfNeededWithCompletion:completion];
}

- (void) addNavTitleView{
    UIStackView *stackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.titleLabel, self.subtitleLabel]];
    stackView.distribution = UIStackViewDistributionEqualCentering;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment =UIStackViewAlignmentCenter;
    
    [stackView setFrame:CGRectMake(0, 0, MAX(self.titleLabel.frame.size.width, self.subtitleLabel.frame.size.width), 35)];
    self.navigationController.navigationBar.topItem.titleView = stackView;
}

- (void) refreshNavBarTitle {
    self.titleLabel.text = self.location.customName;
    self.subtitleLabel.text = self.location.placeName;
    
    if ([self.location.customName isEqualToString:@"Current Location"] && !self.location.placeName) {
        [self.location updatePlaceNameWithBlock:^(NSDictionary *data, NSError *error) {
            if (data) {
                self.subtitleLabel.text = self.location.placeName;
                [self.subtitleLabel sizeToFit];
            }
            else {
                NSLog(@"error");
            }
        }];
    }
    
    if ([self.location.customName isEqualToString:self.location.placeName]) {
        [self configureLabelProperties:self.titleLabel withFontSize:25];
        self.subtitleLabel.text = @"";
        [self.subtitleLabel sizeToFit];
    }
    else {
        [self configureLabelProperties:self.titleLabel withFontSize:17];
        [self configureLabelProperties:self.subtitleLabel withFontSize:13];
    }
    
    if (!self.navigationController.navigationBar.topItem.titleView) [self addNavTitleView];
}

- (void) setNavBarUI {
    [self refreshNavBarTitle];
    [self addNavTitleView];
}

// Gives label white text color and black shadow
- (void) configureLabelProperties:(UILabel *)label withFontSize:(CGFloat)size{
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:size];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    label.layer.shadowColor = [UIColor.blackColor CGColor];
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 2;
    label.layer.shadowOffset = CGSizeMake(0.5, 1.0);
}
@end
