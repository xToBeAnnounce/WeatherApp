//
//  HourlyForecastView.h
//  WeatherApp
//
//  Created by Tiffany Ma on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface HourlyForecastView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) Location *location;
@end
