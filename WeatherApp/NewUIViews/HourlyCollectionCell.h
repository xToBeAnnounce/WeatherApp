//
//  HourlyCollectionCell.h
//  WeatherApp
//
//  Created by Tiffany Ma on 8/7/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface HourlyCollectionCell : UICollectionViewCell
@property (strong, nonatomic) Weather *weather;
@end
