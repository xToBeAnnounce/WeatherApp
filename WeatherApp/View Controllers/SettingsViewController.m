//
//  SettingsViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"

@interface SettingsViewController ()

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UISwitch *locationOnSwitch;
@property (strong, nonatomic) UISwitch *notificationsOnSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.user = User.currentUser;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setUI {
    [self.view setBackgroundColor:[UIColor redColor]];
    
    self.locationOnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 10, 51, 31)];
    self.notificationsOnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 10, 51, 31)];
    
    UIStackView *settingsStackView = [[UIStackView alloc] init];
    [settingsStackView setBackgroundColor:[UIColor blueColor]];
    
    settingsStackView.axis = UILayoutConstraintAxisVertical;
    settingsStackView.distribution = UIStackViewDistributionFill;
    settingsStackView.alignment = UIStackViewAlignmentCenter;
    settingsStackView.spacing = 8;
    
    
    [settingsStackView addArrangedSubview:[self makeHStackViewLabeled:@"Location" withSwitch:self.locationOnSwitch]];
    [settingsStackView addArrangedSubview:[self makeHStackViewLabeled:@"Notifications" withSwitch:_notificationsOnSwitch]];
    
    settingsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:settingsStackView];
    
    [settingsStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [settingsStackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (UIStackView *) makeHStackViewLabeled:(NSString *)text withSwitch:(UISwitch *)labeledSwitch {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [stackView addArrangedSubview:label];
    [stackView addArrangedSubview:labeledSwitch];
    
    return stackView;
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
