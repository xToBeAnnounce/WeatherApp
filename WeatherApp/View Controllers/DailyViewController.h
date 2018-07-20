//
//  DailyViewController.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface DailyViewController : UIViewController
@property (strong, nonatomic) Location *location;
@property (strong,nonatomic) UITableView *ourtableView;
-(void)setUI;
@end
