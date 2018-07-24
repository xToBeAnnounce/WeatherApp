//
//  Weather.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Weather.h"
#import "APIManager.h"

@implementation Weather

- (instancetype)initWithData:(NSDictionary*)data{
    NSTimeInterval timeInSeconds = [data[@"time"] longValue];
    self.time = [NSDate dateWithTimeIntervalSince1970:timeInSeconds];
    
    if(data[@"temperatureHigh"]){
        self.temperatureHigh = (int)[data[@"temperatureHigh"] doubleValue];
        self.temperatureLow = (int)[data[@"temperatureLow"] doubleValue];
        self.temperature = -1;
    }
    else{
        self.temperature = (int)[data[@"temperature"] doubleValue];
        self.temperatureLow = -1;
        self.temperatureHigh = -1;
    }
    self.icon = data[@"icon"];
    return self;
}

- (NSString*)getHourInDayWithTime:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date];
    int hour = (int)[components hour];
    if(hour <= 12){
        return [NSString stringWithFormat:@"%d am", hour];
    }
    else return [NSString stringWithFormat:@"%d pm", (hour - 12)];
}

- (NSString*)getDayOfWeekWithTime:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocalizedDateFormatFromTemplate:@"EEEE"];
    return [formatter stringFromDate:date];
}

- (NSString*)getDateInString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocalizedDateFormatFromTemplate:@"MMMMd"];
    return [formatter stringFromDate:date];
}

- (NSString*)getTempInString:(int)temp{
    return [NSString stringWithFormat:@"%d°", temp];
}
- (NSString*)getTempInString:(int)temp withType:(NSString *)type{
    if ([type isEqualToString:@"C"]) {
        temp = (int)((temp-32) *5.0/9.0);
    }
    return [NSString stringWithFormat:@"%d°", temp];
}

@end
