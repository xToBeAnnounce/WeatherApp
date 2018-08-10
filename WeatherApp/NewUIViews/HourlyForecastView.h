//
//  HourlyForecastView.h
//  WeatherApp
//
//  Created by Tiffany Ma on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol HourlyForecastDelegate
-(void)reloadByHeight;
@end

@interface HourlyForecastView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) Location *location;
@property (nonatomic) CGFloat heightOfView;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) id<HourlyForecastDelegate> delegate;
-(void)setViewHeight;
@end
