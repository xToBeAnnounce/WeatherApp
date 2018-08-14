//
//  HourlyForecastView.m
//  WeatherApp
//
//  Created by Tiffany Ma on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HourlyForecastView.h"
#import "HourlyCollectionCell.h"

@implementation HourlyForecastView 
{
    NSMutableArray *_hourlyData;
    UICollectionViewFlowLayout *_layout;
    CGFloat _viewHeight;
    NSLayoutConstraint *_heightConstraint;
}
NSString *hourlyCellIdentifier = @"singleHourCell";

- (instancetype)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initalizeCollectionView];
        [self systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
        _viewHeight = 150;
    }
    return self;
}

-(void)initalizeCollectionView{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 1;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_layout];
    [self.collectionView registerClass:HourlyCollectionCell.class forCellWithReuseIdentifier:hourlyCellIdentifier];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 50);
    
    [self addSubview:self.collectionView];
    [self setCollectionViewConstraints];
}

-(void)setCollectionViewConstraints{
    [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [self addConstraint:_heightConstraint];
}

- (void)setLocation:(Location *)location{
    if(_location.dailyData) location.dailyData = _location.dailyData; //Updates daily data
    _location = location; //Updates rest of locatin object (i.e. Preference settings)
    [self.collectionView reloadData];
}

- (void)setTempTypeString:(NSString *)tempTypeString {
    _tempTypeString = tempTypeString;
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HourlyCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:hourlyCellIdentifier forIndexPath:indexPath];
    cell.tempType = self.tempTypeString;
    cell.weather = self.location.dailyData[indexPath.row];
    cell.backgroundColor = UIColor.clearColor;
    [cell layoutIfNeeded];
    _viewHeight = cell.frame.size.height + 20;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.location.dailyData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)layoutSubviews{
//    _heightConstraint.active = NO;
//    [_collectionView.heightAnchor constraintEqualToConstant:_viewHeight].active = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
