//
//  Weather.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WeatherDelegate
-(void)reloadDataTableView;
@end

@interface Weather : NSObject
@property (strong, nonatomic) NSDate *time;
@property (nonatomic) int temperature;
@property (nonatomic) int temperatureHigh;
@property (nonatomic) int temperatureLow;
@property (strong, nonatomic) NSString *icon;

//Formatting functions for display in string
- (NSString*)getHourInDayWithTime:(NSDate*)date;
- (NSString*)getDayOfWeekWithTime:(NSDate*)date;
- (NSString*)getDateInString:(NSDate*)date;
- (NSString*)getTempInString:(int)temp;
- (NSString*)getTempInString:(int)temp withType:(NSString *)type;

- (instancetype)initWithData:(NSDictionary*)data;
@end
