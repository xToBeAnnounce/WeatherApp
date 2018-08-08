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
static BOOL showBanner;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedCell = nil;
        showBanner = NO;
        [self setWeeklyUI];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setLocationName];
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

-(void)setLocationName{
    if ([self.location.placeName isEqualToString:self.location.customName]) {
        self.customNameLabel.font = [UIFont systemFontOfSize:45];
        self.locationLabel.hidden = YES;
    }
    else {
        self.locationLabel.hidden = NO;
        self.customNameLabel.font = [UIFont systemFontOfSize:35];
        self.locationLabel.text = self.location.placeName;
        [self.locationLabel sizeToFit];
    }
}
- (void) setLocation:(Location *)location {

    if (_location.weeklyData) location.weeklyData = _location.weeklyData;
    _location = location;
    self.customNameLabel.text = self.location.customName;
    self.selectedCell = nil;
    
    [self updateDataIfNeeded];
    [self refreshView];
}

- (void) setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self.WeeklytableView reloadData];
}

/*--------------------------SET UI METHODS------------------------------*/
-(void)setWeeklyUI{

    self.WeeklytableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width,350)];
    self.WeeklytableView.estimatedRowHeight = 50;
    self.WeeklytableView.rowHeight = 50;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:@"WeeklyCell"];
    self.WeeklytableView.backgroundColor = UIColor.orangeColor;
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;

    self.weatherBanner = [[BannerView alloc] initWithMessage:@""];
    self.weatherBanner.backgroundColor = [UIColor redColor];
    [self addSubview:self.weatherBanner];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDate *cellDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*indexPath.row];
    
    WeeklyCell *weeklycell = [self.WeeklytableView dequeueReusableCellWithIdentifier:WeeklycellIdentifier];
    if(weeklycell == nil){
        weeklycell = [[WeeklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeeklycellIdentifier];
    }
    
    weeklycell.tempType = self.tempType;
    Weather *dayWeather = self.location.weeklyData[indexPath.row];

    weeklycell.dayWeather = dayWeather;
//    weeklycell.contentView.backgroundColor = UIColor.clearColor;
//    weeklycell.backgroundColor = UIColor.clearColor;

    if ([self shouldHighlightDate:cellDate]) {
        weeklycell.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.2];
        weeklycell.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.1];
//        if (!showBanner && [self.weatherBanner.bannerLabel.text isEqualToString:@""]) {
//            showBanner = YES;
//            [self.weatherBanner setBannerMessage:[self makeAlertStringForWeather:dayWeather]];
//        }
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
    Weather *weatherOfDay = self.location.weeklyData[indexPath.row];
    [self.delegate displayPopoverWithLocation:self.location Weather:weatherOfDay];
    [self.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
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

//- (NSString *)makeAlertStringForWeather:(Weather *)weather {
//    NSString *alertString = [NSString stringWithFormat:@"%@ will be %@",
//                             [weather getDayOfWeekWithTime:weather.time], [weather.summary lowercaseString]];
//    return alertString;
//}

- (void) showBannerIfNeededWithCompletion:(void(^)(BOOL finished))completion{
//    if (showBanner && ![self.weatherBanner.bannerLabel.text isEqualToString:@""]) {
//        showBanner = NO;
//        [self bringSubviewToFront:self.weatherBanner];
//        [self.weatherBanner animateBannerWithCompletion:^(BOOL finished) {
//            if (finished) {
//                [self.weatherBanner setBannerMessage:@""];
//                if (completion) completion(finished);
//            }
//        }];
//    }
}
@end

