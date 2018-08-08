//
//  WeatherView.m
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeatherView.h"
#import "HourlyForecastCell.h"
#import "WeeklyView.h"

@implementation WeatherView

UICollectionViewFlowLayout *layout;
NSString *cellID = @"cellIDD";

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    layout = [[UICollectionViewFlowLayout alloc]init];
    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = UIColor.cyanColor;
    [self.mainCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:cellID];
    [self addSubview:self.mainCollectionView];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 1){
        //        HourlyForecastCell *hourlyForecastCell = [[HourlyForecastCell alloc] init];
        //        return hourlyForecastCell;
    }
    if(indexPath.row == 0){
        UICollectionViewCell *Dailycell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        WeeklyView *weeklyView = [[WeeklyView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 350)];
        weeklyView.location = self.location;
        [Dailycell addSubview:weeklyView];
        return Dailycell;
    }
    
    UICollectionViewCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = UIColor.blueColor;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, 350);
}



@end
