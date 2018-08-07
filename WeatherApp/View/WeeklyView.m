//
//  Weekly.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyView.h"
#import "WeeklyCell.h"
#import "WeeklyCollectionViewCell.h"

@implementation WeeklyView

static NSString *WeeklycellIdentifier = @"WeeklyCell";
static NSString *WeeklyCollectioncellIdentifier = @"WeeklyCollectionCell";
static BOOL showBanner;
UICollectionViewFlowLayout *layout;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedCell = nil;
        showBanner = NO;
        //[self setWeeklyUI];
        [self setWeeklyConstraints];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setLocationName];

    [self setCollectionView];
    

    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;
    self.WeeklytableView.backgroundColor = UIColor.clearColor;
    
    self.WeeklyCollectionView.dataSource = self;
    self.WeeklyCollectionView.delegate = self;
    self.WeeklyCollectionView.backgroundColor = UIColor.clearColor;
    
   
    
    self.backgroundImage = [[UIImageView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.backgroundImage.image = [UIImage imageNamed:@"golden_san_fran"];
    self.backgroundImage.clipsToBounds = YES;
    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self insertSubview:self.backgroundImage belowSubview:self.WeeklyCollectionView];
    
//    //Blur Effect
//    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    self.BlurView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
//    self.BlurView.frame = self.backgroundImage.frame;
//    self.BlurView.alpha = 0.37;
//    [self insertSubview:self.BlurView aboveSubview:self.backgroundImage];

}

- (void) updateDataIfNeeded {
    if (self.location.weeklyData.count == 0) {
        [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                [self.WeeklytableView reloadData];
                [self.WeeklyCollectionView reloadData];
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
    [self.WeeklyCollectionView reloadData];
}

/*--------------------------SET UI METHODS------------------------------*/
-(void)setWeeklyUI{

    self.WeeklytableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    self.WeeklytableView.estimatedRowHeight = 50;
    self.WeeklytableView.rowHeight = 80;
    self.WeeklytableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.WeeklytableView];
    [self.WeeklytableView registerClass: WeeklyCell.class forCellReuseIdentifier:@"WeeklyCell"];
    self.WeeklytableView.delegate = self;
    self.WeeklytableView.dataSource = self;

    

    self.backgroundImage = [[UIImageView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.backgroundImage.image = [UIImage imageNamed:@"Sanfranciso"];
    [self insertSubview:self.backgroundImage belowSubview:self.WeeklytableView];
    
    //Blur Effect
    UIVisualEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.BlurView = [[UIVisualEffectView alloc]initWithEffect:blureffect];
    self.BlurView.frame = self.backgroundImage.frame;
    self.BlurView.alpha = 0.4;
    [self insertSubview:self.BlurView aboveSubview:self.backgroundImage];
    
    self.weatherBanner = [[BannerView alloc] initWithMessage:@""];
    self.weatherBanner.backgroundColor = [UIColor redColor];
    [self addSubview:self.weatherBanner];
  
    [self setLocationDisplay];
    //[self setWeeklyConstraints];
}

-(void)setLocationDisplay{
    self.locationView = [[UIView alloc] init];
    [self addSubview:self.locationView];
    self.locationView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.locationView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.locationView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.locationView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.locationView.heightAnchor constraintEqualToConstant:self.frame.size.height/8].active = YES;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[locationView]-0-[tableView]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"locationView": self.locationView, @"tableView": self.WeeklytableView}]];

    
    //setting up customNameLabel
    self.customNameLabel = [[UILabel alloc]init];
    self.customNameLabel.font = [UIFont systemFontOfSize:35];
    self.customNameLabel.text = self.location.customName;
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:17];
    self.locationLabel.text = @"---";
    
    NSArray *locationDisplay = @[self.customNameLabel,self.locationLabel];
    self.locationStackView = [[UIStackView alloc] initWithArrangedSubviews:locationDisplay];
    self.locationStackView.axis = UILayoutConstraintAxisVertical;
    self.locationStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.locationStackView.alignment = UIStackViewAlignmentCenter;
    self.locationStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationView addSubview:self.locationStackView];
}

- (void) setWeeklyConstraints {
    [self.WeeklytableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.WeeklytableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;

    
    // stack view constraints
    [self.locationStackView.centerXAnchor constraintEqualToAnchor:self.locationView.centerXAnchor].active = YES;
    [self.locationStackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.locationStackView.bottomAnchor constraintEqualToAnchor:self.locationView.bottomAnchor constant:-8].active = YES;
    
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

    weeklycell.dayWeather = dayWeather;
    weeklycell.contentView.backgroundColor = UIColor.clearColor;
    weeklycell.backgroundColor = UIColor.clearColor;
    
    if (indexPath.row == 0){
        weeklycell.dateLabel.text = @"Today";
    }
    if ([self shouldHighlightDate:cellDate]) {
        weeklycell.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.2];

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
    Weather *weatherOfDay = self.location.weeklyData[indexPath.row];
    [self.delegate displayPopoverWithLocation:self.location Weather:weatherOfDay];
    [self.WeeklytableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) refreshView {
    [self.WeeklytableView reloadData];
    [self.WeeklyCollectionView reloadData];
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
        [self bringSubviewToFront:self.weatherBanner];
        [self.weatherBanner animateBannerWithCompletion:^(BOOL finished) {
            if (finished) {
                [self.weatherBanner setBannerMessage:@""];
                if (completion) completion(finished);
            }
        }];
    }
}

/***********************COLLECTION VIEW********************/

-(void)setCollectionView{
    layout = [[UICollectionViewFlowLayout alloc]init];
    self.WeeklyCollectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
    [self.WeeklyCollectionView registerClass:WeeklyCollectionViewCell.class forCellWithReuseIdentifier:WeeklyCollectioncellIdentifier];
    self.WeeklyCollectionView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.WeeklyCollectionView];
    
    self.WeeklyCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeeklyCollectionViewCell *cell = [self.WeeklyCollectionView dequeueReusableCellWithReuseIdentifier:WeeklyCollectioncellIdentifier forIndexPath:indexPath];
    
    if(cell.lowTempLabel == nil){
        [cell setWeeklyCVC];
    }
    
    Weather *dayWeather = self.location.weeklyData[indexPath.row];
    
    [cell setDayWeather:dayWeather];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.location.weeklyData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    layout.minimumInteritemSpacing = 7;
    layout.minimumLineSpacing = 7;
    
    CGFloat moviePerRow = 2;
    CGFloat width = (self.WeeklyCollectionView.frame.size.width - layout.minimumInteritemSpacing * (moviePerRow-1)) / moviePerRow;
    CGFloat height = width -40 ;
    layout.itemSize = CGSizeMake(width, height);
    return layout.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

