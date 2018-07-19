//
//  DailyTableViewCell.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/18/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *temperateLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UIImageView *iconImageView;
-(void)setCellUI:(NSDictionary*)dailyDict;

@end
