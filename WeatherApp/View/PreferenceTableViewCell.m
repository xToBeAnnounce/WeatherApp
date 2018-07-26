//
//  PreferenceTableViewCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/20/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "PreferenceTableViewCell.h"

@implementation PreferenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.preferenceLabel = [[UILabel alloc] init];
    self.preferenceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.preferenceLabel];
    [self.preferenceLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [self.preferenceLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    
    return self;
}

- (void)setPreferenceArray:(NSArray *)preferenceArray {
    _preferenceArray = preferenceArray;
    //[Name_of_control, control], i.e. ["Notification", notificationSwitch]
    self.preferenceLabel.text = preferenceArray[0];
    [self.preferenceLabel sizeToFit];
    
    /* Sets preferences without title in the center */
    if ([preferenceArray[0] isEqualToString:@""]) {
        UIControl *loneControl = preferenceArray[1];
        [self.contentView addSubview:loneControl];
        [loneControl.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [loneControl.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [loneControl.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:-4];
        [loneControl.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4];
    }
    else {
        self.preferenceControl = preferenceArray[1];
        self.preferenceControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.preferenceControl];
        
        [self.preferenceControl.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
        [self.preferenceControl.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [self.preferenceControl.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4];
    }
}

@end
