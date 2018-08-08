//
//  WeatherCardCell.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/8/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCardCell : UICollectionViewCell

@property (strong, nonatomic) UIView *customView;
- (void)setTitle:(NSString *)title withView:(UIView *)view;
- (void)setCardBackgroundColor:(UIColor *)backgroundColor;
@end
