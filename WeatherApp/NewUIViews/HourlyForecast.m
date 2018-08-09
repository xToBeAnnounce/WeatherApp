//
//  HourlyForecast.m
//  WeatherApp
//
//  Created by Tiffany Ma on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HourlyForecast.h"
#import "HourlyCollectionCell.h"

@implementation HourlyForecast
{
    UICollectionView *_collectionView;
    NSMutableArray *_hourlyData;
    UICollectionViewFlowLayout *_layout;
}

NSString *hourlyCellIdentifier = @"singleHourCell";

- (instancetype)init{
    self = [super init];
    if (self) {
        [self layoutIfNeeded];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 1;
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_layout];
        [_collectionView registerClass:HourlyCollectionCell.class forCellWithReuseIdentifier:hourlyCellIdentifier];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_collectionView];
        [self setCollectionViewConstraints];
    }
    return self;
}

-(void)setCollectionViewConstraints{
    [_collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)setLocation:(Location *)location{
    if(_location.dailyData) location.dailyData = _location.dailyData; //Updates daily data
    _location = location; //Updates rest of locatin object (i.e. Preference settings)
    [self fetchDailyDataIfNeeded];
}

-(void)fetchDailyDataIfNeeded{
    if (self.location.dailyData.count == 0) {
        [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                //self.location.dailyData updated
                [_collectionView reloadData];
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
    else [_collectionView reloadData];
}

- (void)layoutSubviews{
    _collectionView.frame = self.bounds;
    [super layoutSubviews];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HourlyCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:hourlyCellIdentifier forIndexPath:indexPath];
    cell.weather = self.location.dailyData[indexPath.row];
    cell.backgroundColor = UIColor.clearColor;
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.location.dailyData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
