//
//  Weekly.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyView : UIView
@property (strong, nonatomic) UITableView *WeeklytableView;
-(void)ShowWeeklyData;
-(void)HideWeeklyData;

@end
