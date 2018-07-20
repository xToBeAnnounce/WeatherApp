//
//  WeeklyCell.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeeklyCell : UITableViewCell
@property UILabel *lowTempLabel;
@property UILabel *highTempLabel;
@property UILabel *dateLabel;

-(void)setWeeklyCell:(Weather*)data;
@end
