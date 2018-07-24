//
//  LocationTableViewCell.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *fullPlaceNameLabel;
@property (strong, nonatomic) UILabel *customNameLabel;
@property (strong, nonatomic) UIStackView *labelsStackView;
@property (strong, nonatomic) UIImageView *rightArrowImageView;

@property (strong, nonatomic) Location *location;

@end
