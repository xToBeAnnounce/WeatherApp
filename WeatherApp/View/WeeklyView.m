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

static bool loadWeeklyData = NO;
static NSString *WeeklycellIdentifier = @"WeeklyCell";
static NSIndexPath *selectedCell;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    selectedCell = nil;
    [self setWeeklyUI];
    
    [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            loadWeeklyData = YES;
            [self.WeeklytableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
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
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    WeeklyCell *weeklycell = [self.WeeklytableView dequeueReusableCellWithIdentifier:WeeklycellIdentifier];
    if(weeklycell == nil){
        weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeeklycellIdentifier];
    }
    if(loadWeeklyData){
        weeklycell.tempType = self.tempType;
        Weather *dayWeather = self.location.weeklyData[indexPath.row];
        if(selectedCell == indexPath) weeklycell.displayActivity = YES;
        else{
            weeklycell.displayActivity = NO;
        }
        weeklycell.dayWeather = dayWeather;
    }
    return weeklycell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.location.weeklyData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //[self.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.delegate displayPopoverDataRow:(int)indexPath.row Height: (int)self.WeeklytableView.estimatedRowHeight];
    if(selectedCell == nil){
        selectedCell = indexPath;
        [self.WeeklytableView reloadData];
    }
    else selectedCell = nil;
    // Create an activity for the location here
    // Initalize the popover view
    // Display the activity data in the popover view
}


@end
