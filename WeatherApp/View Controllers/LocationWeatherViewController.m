//
//  LocationWeatherViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationWeatherViewController.h"
#import "APIManager.h"
#import "DailyView.h"
#import "WeeklyView.h"
#import "NavigationController.h"
#import "Activity.h"
#import "ActivityViewController.h"

@interface LocationWeatherViewController () <UIPopoverPresentationControllerDelegate>
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySC;
@property (strong,nonatomic) DailyView *dailyView;
@property (strong,nonatomic) WeeklyView *weeklyView;
@end

@implementation LocationWeatherViewController


- (instancetype) initWithLocation:(Location *)location segmentedControl:(UISegmentedControl *)DailyWeeklySC {
    self.location = location;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.DailyWeeklySC = DailyWeeklySC;
    self.DailyWeeklySC.selectedSegmentIndex = 0;
    [self.DailyWeeklySC addTarget:self action:@selector(selectedIndex) forControlEvents:UIControlEventValueChanged];
    
    [self setUI];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) setUI {
    
    self.dailyView = [[DailyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.weeklyView = [[WeeklyView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.weeklyView.location = self.location;
    self.weeklyView.sourceVC = self;
    self.dailyView.location = self.location;
    
    [self.view addSubview:self.dailyView];
    [self.view addSubview:self.weeklyView];
    
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"grad"]];

   [self selectedIndex];
}

-(void)displayPopoverWithType:(NSString*)type Location:(NSArray*)loc AtRow:(int)rowNum Height:(int)height{
    ActivityViewController *popoverView = [[ActivityViewController alloc] initWithLocation:loc Type:type];
    popoverView.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popController = popoverView.popoverPresentationController;
    popController.delegate = self;
    popController.sourceView = (UIView*)self.weeklyView;
    popController.sourceRect = CGRectMake(self.weeklyView.bounds.size.width/2, height*rowNum + rowNum/2, 1, 1);
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverView.preferredContentSize = CGSizeMake(300, 300);
    
    [self presentViewController:popoverView animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(void)selectedIndex{
    if(self.DailyWeeklySC.selectedSegmentIndex == 0 ){
        NSLog(@"Daily");
        self.weeklyView.hidden = YES;
        self.dailyView.hidden = NO;
    } else {
        NSLog(@"Weekly");
        self.weeklyView.hidden = NO;
        self.dailyView.hidden = YES;
    }
}
@end
