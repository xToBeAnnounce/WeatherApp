//
//  Weekly.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyView.h"
#import "WeeklyCell.h"

@implementation WeeklyView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setWeeklyUI];
}

/*-----------------------------SETS WEEKLY UI-----------------------------------------*/
-(void)setWeeklyUI{
    self.WeeklytableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    self.WeeklytableView.estimatedRowHeight = 50;
    self.WeeklytableView.rowHeight = UITableViewAutomaticDimension;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:@"WeeklyCell"];
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

-(void)HideWeeklyData{
    self.WeeklytableView.hidden = YES;
    [self.WeeklytableView reloadData];
}

-(void)ShowWeeklyData{
    self.WeeklytableView.hidden = NO;
    [self.WeeklytableView reloadData];
}

@end
