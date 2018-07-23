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
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.prefStackView = [[UIStackView alloc] init];
    self.prefStackView.axis = UILayoutConstraintAxisHorizontal;
    self.prefStackView.distribution = UIStackViewDistributionFill;
    self.prefStackView.alignment = UIStackViewAlignmentCenter;
    self.prefStackView.spacing = 8;
    self.prefStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.prefStackView];
    
    [self.prefStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [self.prefStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:8].active = YES;
    [self.prefStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    [self.prefStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:8].active = YES;
    [self.prefStackView.heightAnchor constraintGreaterThanOrEqualToConstant:50];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPreferenceArray:(NSArray *)preferenceArray {
    _preferenceArray = preferenceArray;
//    [self fillOutPrefStackViewWithArray:preferenceArray];
    self.textLabel.text = preferenceArray[0];
    
    if ([self.textLabel.text isEqualToString:@""]) {
        UIControl *loneControl = preferenceArray[1];
        [self.contentView addSubview:loneControl];
        [loneControl.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [loneControl.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    }
    else {
        self.accessoryView = preferenceArray[1];
    }
}

- (void) fillOutPrefStackViewWithArray:(NSArray *)array{
    UILabel *label = [[UILabel alloc] init];
    label.text = array[0];
    [label sizeToFit];
    UIControl *interactiveAspect = array[1];
//
//    [label.leadingAnchor constraintEqualToAnchor:self.prefStackView.leadingAnchor];
//    [interactiveAspect.trailingAnchor constraintEqualToAnchor:self.prefStackView.leadingAnchor];
    
    [self.prefStackView addArrangedSubview:label];
//    [self.prefStackView addArrangedSubview:[[UIView alloc]init]];
    [self.prefStackView addArrangedSubview:interactiveAspect];
}
@end
