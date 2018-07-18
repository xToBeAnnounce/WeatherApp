//
//  WeeklyCell.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "WeeklyCell.h"

@implementation WeeklyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setWeeklyCell:(NSDictionary*)dailyData{
    NSLog(@"%@", dailyData);
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    testLabel.text = @"TESTING";
    testLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:testLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
