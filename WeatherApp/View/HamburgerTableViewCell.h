//
//  HamburgerTableViewCell.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *sectionLabel;
@property (strong,nonatomic) UIImageView *icon;

-(void)setUI;

@end
