//
//  LocationTableViewCell.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/24/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.customNameLabel = [[UILabel alloc] init];
    self.customNameLabel.font = [UIFont systemFontOfSize:25];
    self.customNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.fullPlaceNameLabel = [[UILabel alloc] init];
    self.fullPlaceNameLabel.font = [UIFont systemFontOfSize:17];
    self.fullPlaceNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow"]];
    self.rightArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightArrowImageView.clipsToBounds = YES;
    self.rightArrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.rightArrowImageView];
    
    self.labelsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.customNameLabel, self.fullPlaceNameLabel]];
    self.labelsStackView.axis = UILayoutConstraintAxisVertical;
    self.labelsStackView.distribution = UIStackViewDistributionFill;
    self.labelsStackView.alignment = UIStackViewAlignmentLeading;
    self.labelsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.labelsStackView];
    
    [self setConstraints];
    
    return self;
}

- (void)setLocation:(Location *)location {
    _location = location;
    self.customNameLabel.text = location.customName;
    [self.customNameLabel sizeToFit];
    
    self.fullPlaceNameLabel.text = location.fullPlaceName;
    [self.fullPlaceNameLabel sizeToFit];
}

- (void) setConstraints {
    // image view constraints
    [self.rightArrowImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
    [self.rightArrowImageView.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.rightArrowImageView.widthAnchor constraintEqualToAnchor:self.rightArrowImageView.heightAnchor multiplier:1.0/1.0].active = YES;
    [self.rightArrowImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    
    // stack view constraints
    [self.labelsStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
//    [self.labelsStackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.labelsStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    [self.labelsStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8].active = YES;
}

@end
