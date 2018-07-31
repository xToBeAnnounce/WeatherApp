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
    self.sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    [self.contentView addSubview:self.sectionLabel];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
