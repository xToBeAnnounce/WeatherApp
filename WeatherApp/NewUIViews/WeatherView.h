//
//  WeatherView.h
//  WeatherApp
//
//  Created by Trustin Harris on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "HourlyForecastView.h"
#import "Activity.h"

@interface WeatherView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UICollectionView *mainCollectionView;
@property (strong,nonatomic) UITableView *maintableView;
@property (strong, nonatomic) id<ActivityDelegate> activityDelegate;

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *tempTypeString;
@end
