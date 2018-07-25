//
//  LoginViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "PageViewController.h"
#import "LocationPickerViewController.h"


@interface LoginViewController ()
@property (strong,nonatomic) UITextField *usernameField;
@property (strong,nonatomic) UITextField *passwordField;
@property UINavigationController *navController;
@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) UIButton *signupButton;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIBarButtonItem *settingsButton;
@property (strong, nonatomic) PageViewController *pageVC;
@property (strong, nonatomic) UIBarButtonItem *addLocationButton;
@property (strong,nonatomic) UISegmentedControl *DailyWeeklySegmentedC;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewController];
    [self setPageNavigation];
    self.view.backgroundColor = UIColor.whiteColor;
    
}

-(void)initViewController{
    self.pageVC = [[PageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageVC.navController = [[UINavigationController alloc] initWithRootViewController:self.pageVC];
    
    self.settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(segueToSettings)];
    self.settingsButton.image = [UIImage imageNamed:@"hamburger"];
    self.settingsButton.tintColor = UIColor.whiteColor;
    self.pageVC.navController.navigationBar.topItem.leftBarButtonItem = self.settingsButton;
    self.addLocationButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(segueToAddLocation)];
    self.addLocationButton.image = [UIImage imageNamed:@"plus-1"];
    self.addLocationButton.tintColor = UIColor.whiteColor;
    self.pageVC.navController.navigationBar.topItem.rightBarButtonItem = self.addLocationButton;
    
    self.DailyWeeklySegmentedC = [[UISegmentedControl alloc]initWithItems:@[@"Daily",@"Weekly"]];
    self.pageVC.navigationController.navigationBar.topItem.titleView = self.DailyWeeklySegmentedC;
    self.DailyWeeklySegmentedC.selectedSegmentIndex = 0;
    self.DailyWeeklySegmentedC.tintColor = UIColor.blackColor;
    
}

-(void)setPageNavigation{
    if(PFUser.currentUser){
        [self.mainNavController presentViewController:self.pageVC.navController animated:YES completion:nil];
    }
    else{
        [self setLoginUI];
    }
}

-(void)setLoginUI{
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 258, 305, 45)];
    self.usernameField.placeholder = @"username";
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;

    //setting password textfield
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(35, 325, 305, 45)];
    self.passwordField.placeholder = @"password";
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.secureTextEntry = YES;
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(221, 380, 55, 30)];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LogIn" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //setting signup button
    self.signupButton = [[UIButton alloc] initWithFrame:CGRectMake(109, 380, 60, 30)];
    [self.signupButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.signupButton setTitle:@"SignUp" forState:UIControlStateNormal];
    [self.signupButton addTarget:self action:@selector(signupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //setting title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 132, 152, 41)];
    self.titleLabel.text = @"WeatherAPP";
    self.titleLabel.font = [UIFont systemFontOfSize:40];
    [self.titleLabel sizeToFit];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.signupButton];
}


-(IBAction)loginButtonTapped:(id)sender{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self AlertController:error.localizedDescription];
        } else {
            NSLog(@"User logged in successfully");
                [self.mainNavController presentViewController:self.pageVC.navController animated:YES completion:nil];
        }
    }];
}



-(IBAction)signupButtonTapped:(id)sender{
    User *newUser = User.new;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self AlertController:error.localizedDescription];
        } else {
            NSLog(@"User registered successfully");
            [self.mainNavController presentViewController:self.pageVC.navController animated:YES completion:nil];
        }
    }];
}

-(void)AlertController:(NSString *)Message{
    NSString *title = @"Error!";
    NSString *message = Message;
    NSString *text = @"OK";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *button = [UIAlertAction actionWithTitle:text style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:button];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)segueToAddLocation{
    [self.pageVC.navController pushViewController:LocationPickerViewController.new animated:YES];
}

-(void)segueToSettings{
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:SettingsViewController.new];
    [self.pageVC.navController presentViewController:settingsNavigationController animated:YES completion:nil];
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
