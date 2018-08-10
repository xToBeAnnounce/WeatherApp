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
    UICollectionView *_collectionView;
    NSMutableArray *_hourlyData;
    UICollectionViewFlowLayout *_layout;
    CGFloat _viewHeight;
}
NSString *hourlyCellIdentifier = @"singleHourCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initalizeCollectionView];
        [self systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    }
    return self;
}

-(void)initalizeCollectionView{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 1;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_layout];
    [_collectionView registerClass:HourlyCollectionCell.class forCellWithReuseIdentifier:hourlyCellIdentifier];
    _collectionView.backgroundColor = UIColor.clearColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_collectionView];
    [self setCollectionViewConstraints];
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
//    [self fetchDailyDataIfNeeded];
}

//-(void)fetchDailyDataIfNeeded{
//    if (self.location.dailyData.count == 0) {
//        [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
//            if(error == nil){
//                //self.location.dailyData updated
//                [self->_collectionView reloadData];
//            }
//            else NSLog(@"%@", error.localizedDescription);
//        }];
//    }
//    else [_collectionView reloadData];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HourlyCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:hourlyCellIdentifier forIndexPath:indexPath];
    cell.weather = self.location.dailyData[indexPath.row];
    cell.backgroundColor = UIColor.clearColor;
    _viewHeight = cell.frame.size.height + 8;
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.location.dailyData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)setViewHeight{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [_collectionView reloadData];
    });
    [self.heightAnchor constraintEqualToConstant:150].active = YES;;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
