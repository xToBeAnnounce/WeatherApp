//
//  HamburgerViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HamburgerViewController.h"
#import "HamburgerTableViewCell.h"
#import "SettingsViewController.h"
#import "NavigationController.h"
#import "SWRevealViewController.h"
#import "PageViewController.h"
#import "WebViewViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface HamburgerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *hamburgerTableView;

@end

@implementation HamburgerViewController
static NSArray *cellContent;
static NSArray *cellImages;
static NSString *cellID = @"hamburgerMenu";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    cellImages = @[@"weatherIcon",@"user",@"activities",@"map",@"settings",@"logout"];
    cellContent = @[@"Weather",@"Account",@"Activies",@"Map",@"Settings",@"Logout"];
    
    
}

-(void)setTableView{
    self.hamburgerTableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
    self.hamburgerTableView.dataSource = self;
    self.hamburgerTableView.delegate = self;
    [self.hamburgerTableView registerClass:HamburgerTableViewCell.class forCellReuseIdentifier:cellID];
    [self.view addSubview:self.hamburgerTableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HamburgerTableViewCell *cell = [self.hamburgerTableView dequeueReusableCellWithIdentifier: cellID];
    if(cell == nil){
        cell = [[HamburgerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setUI];
    cell.sectionLabel.text = cellContent[indexPath.row];
    cell.icon.image = [UIImage imageNamed:cellImages[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    if (indexPath.row == 0){
        PageViewController *PageVC = [[PageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [revealController pushFrontViewController:PageVC animated:YES];
    }
    if (indexPath.row == 3){
        WebViewViewController *webVC = WebViewViewController.new;
        [revealController pushFrontViewController:webVC animated:YES];
    }
    
    if (indexPath.row == 4){
        SettingsViewController *settingsVC = SettingsViewController.new;
        [revealController pushFrontViewController:settingsVC animated:YES];
    }
    if (indexPath.row == 5) {
        [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            if (!error) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.pageVC = PageViewController.new;
                [self presentViewController:loginVC animated:NO completion:nil];
            }
        }];
    }
    [self.hamburgerTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellContent.count;
}


- (UIViewController *)presentFrontViewController:(UIViewController *)viewController {
    return viewController;
}


@end
