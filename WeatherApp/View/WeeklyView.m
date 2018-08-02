//
//  Weekly.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyView.h"
#import "WeeklyCell.h"
#import "Location.h"
@implementation WeeklyView

static NSString *WeeklycellIdentifier = @"WeeklyCell";
static NSIndexPath *selectedCell;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    selectedCell = nil;
    [super drawRect:rect];
    [self setWeeklyUI];
    
    [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            [self.WeeklytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
}

- (void) setLocation:(Location *)location {
    _location = location;
    [self refreshView];
}

- (void) setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self.WeeklytableView reloadData];
}

/*-----------------------------SETS WEEKLY UI-----------------------------------------*/
-(void)setWeeklyUI{
    self.WeeklytableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    self.WeeklytableView.estimatedRowHeight = 50;
    self.WeeklytableView.rowHeight = UITableViewAutomaticDimension;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:@"WeeklyCell"];
    [self setWeeklyConstraints];
    
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDate *cellDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*indexPath.row];
    
    WeeklyCell *weeklycell = [self.WeeklytableView dequeueReusableCellWithIdentifier:WeeklycellIdentifier];
    if(weeklycell == nil){
        weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeeklycellIdentifier];
    }
    
    weeklycell.tempType = self.tempType;
    Weather *dayWeather = self.location.weeklyData[indexPath.row];
    if(selectedCell == indexPath) weeklycell.displayActivity = YES;
    else weeklycell.displayActivity = NO;
    
    weeklycell.dayWeather = dayWeather;
    weeklycell.delegate = self.sourceVC;
    weeklycell.location = @[@(self.location.lattitude), @(self.location.longitude)];
    weeklycell.rowNum = (int)indexPath.row;
    weeklycell.rowHeight = self.WeeklytableView.estimatedRowHeight;
    if ([self shouldHighlightDate:cellDate]) {
        weeklycell.backgroundColor = UIColor.greenColor;
    }
    else {
        weeklycell.backgroundColor = UIColor.whiteColor;
    }
    
    return weeklycell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.location.weeklyData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(selectedCell == nil){
        selectedCell = indexPath;
    }
    else selectedCell = nil;
    [self.WeeklytableView reloadData];
}

- (void) refreshView {
    // Put code in here if we decide to display location stuff on weekly view
    [self.WeeklytableView reloadData];
}

- (BOOL) shouldHighlightDate:(NSDate *)date {
    if (self.location.endDate) {
        if (self.location.startDate) return [self date:date isBetweenStartDate:self.location.startDate andEndDate:self.location.endDate];
        else return [[date earlierDate:[NSDate dateWithTimeInterval:60*60*24 sinceDate:self.location.endDate]] isEqualToDate:date];
    }
    return NO;
}

- (BOOL) date:(NSDate *)date isBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    if ([[date earlierDate:startDate] isEqualToDate:date]) return NO;
    if ([[date earlierDate:endDate] isEqualToDate:endDate]) return NO;
    return YES;
}
@end
