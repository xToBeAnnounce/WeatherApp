//
//  HamburgerTableViewCell.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/30/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "HamburgerTableViewCell.h"

@implementation HamburgerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setUI];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setUI {
    self.sectionLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.sectionLabel];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    [self setConstraints];
}

- (void) setConstraints {
    for (UIView *subview in self.contentView.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[iconView]-[sectionLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"iconView":self.icon, @"sectionLabel":self.sectionLabel}]];
    
    [self.icon.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.icon.heightAnchor constraintEqualToConstant:25].active = YES;
    [self.icon.widthAnchor constraintEqualToAnchor:self.icon.heightAnchor].active = YES;
}

@end
