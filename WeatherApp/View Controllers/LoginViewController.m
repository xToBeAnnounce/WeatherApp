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
#import "WeeklyViewController.h"
#import "DailyViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (strong,nonatomic) UITextField *usernameField;
@property (strong,nonatomic) UITextField *passwordField;
@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) UIButton *signupButton;
@property LoginViewController *loginVC;
@property (strong,nonatomic) UILabel *titleLabel;
@property UITabBarController *tabBarController;
@property WeeklyViewController *weeklyVC;
@property DailyViewController *dailyVC;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tabBarSetup];
    [self setUI];
    
    AppDelegate *appD = [[AppDelegate alloc] init];
    
  
    
    self.view.backgroundColor = UIColor.whiteColor;
}

-(void)setUI{
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 258, 305, 45)];
    self.usernameField.placeholder = @"username";
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(35, 325, 305, 45)];
    self.passwordField.placeholder = @"password";
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(221, 380, 55, 30)];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LogIn" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.signupButton = [[UIButton alloc] initWithFrame:CGRectMake(109, 380, 60, 30)];
    [self.signupButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.signupButton setTitle:@"SignUp" forState:UIControlStateNormal];
    [self.signupButton addTarget:self action:@selector(signupButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
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
                [self presentViewController:self.navController animated:YES completion:nil];
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
            [self presentViewController:self.navController animated:YES completion:nil];
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

-(void)tabBarSetup{
    self.tabBarController = [[UITabBarController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
    self.weeklyVC = [[WeeklyViewController alloc] init];
    self.dailyVC = [[DailyViewController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:self.dailyVC, self.weeklyVC, nil];
    self.tabBarController.viewControllers = viewControllers;
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Daily"];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Weekly"];
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
