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
    //Increment by one day so it starts at current day
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.day = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timeInSeconds];
    self.time = [calendar dateByAddingComponents:components toDate:time options:0];
    
    self.icon = data[@"icon"];
    self.windSpeed = [data[@"windSpeed"] floatValue];
    self.humidity = [data[@"humidity"]floatValue];
    
    self.summary = data[@"summary"];
    
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
    return self;
}

- (NSString*)getHourInDayWithTime:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date];
    int hour = (int)[components hour];
    if(hour == 0){
        return [NSString stringWithFormat:@"12 am"];
    }
    else if(hour <= 12){
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

-(NSString*)getHumidityInString:(float)humidity{
    NSString* string = [NSString stringWithFormat:@"%.0f",humidity*100];
    string = [string stringByAppendingString:@"%"];
    return string;
}

-(NSString*)getWindSpeedInString:(float)windspeed{
    NSString* string = [NSString stringWithFormat:@"%.02f ",windspeed];
    string = [string stringByAppendingString:@"mph"];
    return string;
}

-(NSString*)formatSummary:(NSString*)summary{
    summary = [summary stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    summary = [summary stringByReplacingOccurrencesOfString:@"day" withString:@" "];
    summary = [summary stringByReplacingOccurrencesOfString:@"night" withString:@" "];
    return summary;
}







@end
