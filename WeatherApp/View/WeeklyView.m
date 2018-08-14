//
//  Weekly.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyView.h"
#import "WeeklyCell.h"
#import "BannerView.h"

@implementation WeeklyView
{
    UIWindow *_bannerWindow;
    BannerView *_bannerView;
    NSLayoutConstraint *_tableViewHeightConstraint;
    NSIndexPath *_expandedIndexPath;
}

static NSString *WeeklycellIdentifier = @"WeeklyCell";
static BOOL showBanner;

- (instancetype)init{
    self = [super init];
    if (self) {
        showBanner = NO;
        _expandedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setWeeklyUI];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void) setLocation:(Location *)location {
    if (_location.weeklyData && !location.weeklyData) location.weeklyData = _location.weeklyData;
    _location = location;
    
    self.selectedCell = nil;
    [self refreshView];
}

- (void) setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self.WeeklytableView reloadData];
}

/*--------------------------SET UI METHODS------------------------------*/
-(void)setWeeklyUI{
    self.WeeklytableView = [[UITableView alloc] init];
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
    self.backgroundColor = UIColor.clearColor;
    self.WeeklytableView.rowHeight = UITableViewAutomaticDimension;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:@"WeeklyCell"];
    self.WeeklytableView.backgroundColor = UIColor.clearColor;
    self.WeeklytableView.scrollEnabled = NO;
    [self setTableViewConstraints];
    
    _bannerWindow = UIApplication.sharedApplication.keyWindow;
    _bannerView = [[BannerView alloc] initWithMessage:@""];
    _bannerView.backgroundColor = [UIColor redColor];
    [_bannerWindow addSubview:_bannerView];
    [_bannerView setUpBannerForSuperview];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeeklyCell *weeklycell = [self.WeeklytableView dequeueReusableCellWithIdentifier:WeeklycellIdentifier];
    if(weeklycell == nil){
        weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeeklycellIdentifier];
    }
    
    weeklycell.tempType = self.tempType;
    weeklycell.location = self.location;
    weeklycell.activitDelegate = self.activityDelegate;
    Weather *dayWeather = self.location.weeklyData[indexPath.row+1];
    weeklycell.dayWeather = dayWeather;
    
    NSDate *cellDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*indexPath.row];
    if ([self shouldHighlightDate:cellDate]) {
        weeklycell.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.2];
//        if (!showBanner && [_bannerView.bannerLabel.text isEqualToString:@""]) {
//            showBanner = YES;
//            [_bannerView setBannerMessage:[self makeAlertStringForWeather:dayWeather]];
//        }
    }
    else {
        weeklycell.backgroundColor = UIColor.clearColor;
    }
    
    if(indexPath.row == 0){
        weeklycell.dateLabel.text = @"Tomorrow";
        [weeklycell.dateLabel sizeToFit];
    }
    return weeklycell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.location.weeklyData.count-1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    Weather *weatherOfDay = self.location.weeklyData[indexPath.row];
    //    [self.activityDelegate displayPopoverWithLocation:self.location weather:weatherOfDay index:0];
    
    [tableView beginUpdates]; // tell the table you're about to start making changes
    
    // If the index path of the currently expanded cell is the same as the index that
    // has just been tapped set the expanded index to nil so that there aren't any
    // expanded cells, otherwise, set the expanded index to the index that has just
    // been selected.
    if ([indexPath compare:_expandedIndexPath] == NSOrderedSame) {
        _expandedIndexPath = nil;
    } else {
        _expandedIndexPath = indexPath;
    }
    [tableView endUpdates]; // tell the table you're done making your changes
    
//    _tableViewHeightConstraint.constant = self.WeeklytableView.contentSize.height;
//    [self.superview layoutIfNeeded];
    [self.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:_expandedIndexPath] == NSOrderedSame) {
        WeeklyCell *cell = [self.WeeklytableView cellForRowAtIndexPath:indexPath];
        _tableViewHeightConstraint.constant = self.WeeklytableView.contentSize.height;
        
        return cell.contentView.frame.size.height + cell.ExpandedView.frame.size.height;
    }
    return 53.0;
}

- (void) refreshView {
    _tableViewHeightConstraint.constant = self.WeeklytableView.contentSize.height;
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

- (void) setTableViewConstraints {
    [self.WeeklytableView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.WeeklytableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    _tableViewHeightConstraint = [self.WeeklytableView.heightAnchor constraintEqualToConstant:53*6];
    _tableViewHeightConstraint.active = YES;
//    [self.heightAnchor constraintEqualToAnchor: self.WeeklytableView.heightAnchor].active = YES;
    [self.heightAnchor constraintEqualToConstant: 53*6].active = YES;

}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion{
    if (showBanner && ![_bannerView.bannerLabel.text isEqualToString:@""]) {
        showBanner = NO;
        _bannerWindow.windowLevel = UIWindowLevelStatusBar+1;
        [_bannerView animateBannerWithCompletion:^(BOOL finished) {
            if (finished) {
                self->_bannerWindow.windowLevel = UIWindowLevelStatusBar-1;
                [self->_bannerView setBannerMessage:@""];
                if (completion) completion(finished);
            }
        }];
    }
}
@end

