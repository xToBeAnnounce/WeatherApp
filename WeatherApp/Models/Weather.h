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
@property NSDate *time;
@property int temperature;
@property int temperatureHigh;
@property int temperatureLow;
@property NSString *icon;

//Formatting functions for display in string
- (NSString*)getHourInDayWithTime:(NSDate*)date;
- (NSString*)getDayOfWeekWithTime:(NSDate*)date;
- (NSString*)getDateInString:(NSDate*)date;
- (NSString*)getTempInString:(int)temp;

- (instancetype)initWithData:(NSDictionary*)data;
@end
