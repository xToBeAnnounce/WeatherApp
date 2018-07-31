//
//  HamburgerTableViewCell.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HamburgerTableViewCell.h"

@implementation HamburgerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUI {
    self.sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(41, 10, 150, 20)];
    [self.contentView addSubview:self.sectionLabel];
    
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(8,8, 25, 25)];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
