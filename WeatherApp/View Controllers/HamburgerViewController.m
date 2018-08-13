//
//  HamburgerViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HamburgerViewController.h"
#import "HamburgerTableViewCell.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface HamburgerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *hamburgerTableView;@end

@implementation HamburgerViewController
static NSArray *cellContent;
static NSArray *cellImages;
static NSString *cellID = @"hamburgerMenu";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    cellImages = @[@"weatherIcon",@"activities",@"map",@"settings",@"logout"];
    cellContent = @[@"Weather",@"Activies",@"Map",@"Settings",@"Logout"];
}

-(void)setTableView{
    self.hamburgerTableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
    self.hamburgerTableView.dataSource = self;
    self.hamburgerTableView.delegate = self;
    self.hamburgerTableView.backgroundColor = UIColor.clearColor;
    [self.hamburgerTableView registerClass:HamburgerTableViewCell.class forCellReuseIdentifier:cellID];
    [self.view addSubview:self.hamburgerTableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HamburgerTableViewCell *cell = [self.hamburgerTableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[HamburgerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.sectionLabel.text = cellContent[indexPath.row];
    cell.sectionLabel.textColor = UIColor.whiteColor;
    cell.backgroundColor = UIColor.clearColor;
    cell.icon.image = [UIImage imageNamed:cellImages[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    if (indexPath.row == 0){
        [revealController pushFrontViewController:self.pageVC animated:YES];
    }
    if (indexPath.row == 2){
        [revealController pushFrontViewController:self.mapWVC animated:YES];
    }
    
    if (indexPath.row == 3){
        [revealController pushFrontViewController:self.settingsVC animated:YES];
    }
    if (indexPath.row == 4) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            if (!error) {
                appDelegate.window.rootViewController = [[NavigationController alloc] init].navStack;
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
