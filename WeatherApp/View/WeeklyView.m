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

static NSString *WeeklycellIdentifier = @"WeeklyCell";
static NSIndexPath *selectedCell;
static BOOL showBanner;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectedCell = nil;
        showBanner = NO;
        [self setWeeklyUI];
        [self setWeeklyConstraints];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void) updateDataIfNeeded {
    if (self.location.weeklyData.count == 0) {
        [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                [self.WeeklytableView reloadData];
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void) setLocation:(Location *)location {
    _location = location;
    [self updateDataIfNeeded];
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
    
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
    
    self.weatherBanner = [[BannerView alloc] initWithMessage:@""];
    self.weatherBanner.backgroundColor = [UIColor redColor];
    [self addSubview:self.weatherBanner];
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    [self.weatherBanner setDefaultSuperviewConstraints];
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
        weeklycell.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.1];
        if (!showBanner && [self.weatherBanner.bannerLabel.text isEqualToString:@""]) {
            showBanner = YES;
            [self.weatherBanner setBannerMessage:[self makeAlertStringForWeather:dayWeather]];
        }
    }
    else {
        weeklycell.backgroundColor = nil;
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
    [self.WeeklytableView reloadData];
}

- (BOOL) shouldHighlightDate:(NSDate *)date {
    if (self.location.endDate) {
        if (self.location.startDate) return [self date:date isBetweenStartDate:self.location.startDate andEndDate:self.location.endDate];
        else {
            return !([NSCalendar.currentCalendar compareDate:date toDate:self.location.endDate toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending);
        }
    }
    return NO;
}

- (BOOL) date:(NSDate *)date isBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSComparisonResult startDateComparison = [NSCalendar.currentCalendar compareDate:date toDate:startDate toUnitGranularity:NSCalendarUnitDay];
    NSComparisonResult endDateComparison = [NSCalendar.currentCalendar compareDate:date toDate:endDate toUnitGranularity:NSCalendarUnitDay];
    
    if (startDateComparison == NSOrderedAscending) return NO;
    if (endDateComparison == NSOrderedDescending) return NO;
    return YES;
}

- (NSString *)makeAlertStringForWeather:(Weather *)weather {
    NSString *alertString = [NSString stringWithFormat:@"%@ will be %@",
                             [weather getDayOfWeekWithTime:weather.time], [weather.summary lowercaseString]];
    return alertString;
}

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion{
    if (showBanner && ![self.weatherBanner.bannerLabel.text isEqualToString:@""]) {
        showBanner = NO;
        [self.weatherBanner animateBannerWithCompletion:^(BOOL finished) {
            if (finished) {
                [self.weatherBanner setBannerMessage:@""];
                if (completion) completion(finished);
            }
        }];
    }
}
@end
