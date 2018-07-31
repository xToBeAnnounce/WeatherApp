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

@interface HamburgerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *hamburgerTableView;




@end

@implementation HamburgerViewController
static NSArray *cellcontent;
static NSString *cellID = @"hamburgerMenu";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    cellcontent = @[@"Weather",@"Settings",@"Activies",@"Locations",@"Logout"];
    
    
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
    cell.sectionLabel.text = cellcontent[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    if (indexPath.row == 0){
        PageViewController *PageVC = [[PageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        UINavigationController *PageNVC = [[UINavigationController alloc]initWithRootViewController:PageVC];
        [revealController pushFrontViewController:PageNVC animated:YES];
        [self.hamburgerTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.row == 1){
        SettingsViewController *settingsVC = SettingsViewController.new;
        UINavigationController *settingsNVC = [[UINavigationController alloc]initWithRootViewController:settingsVC];
//        [revealController pushFrontViewController:settingsVC animated:YES];
//        [self.hamburgerTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self presentViewController:settingsNVC animated:YES completion:nil];
        
    }
    
    
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellcontent.count;
}


- (UIViewController *)presentFrontViewController:(UIViewController *)viewController {
    return viewController;
}


@end
