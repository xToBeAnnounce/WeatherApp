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

static NSString *const _currentTimeZone = @"America/Los_Angeles";
static NSArray *dayOfWeek;

- (instancetype)initWithData:(NSDictionary*)data Timezone:(NSString*)timezone{
    dayOfWeek = @[@"nil", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    
    NSTimeInterval timeInSeconds = [data[@"time"] integerValue];
    self.time = [NSDate dateWithTimeIntervalSince1970:timeInSeconds];
    
    if(![timezone isEqualToString:_currentTimeZone]){
        NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithName:_currentTimeZone];
        NSInteger destinationSeconds = [destinationTimeZone secondsFromGMTForDate:self.time];
        
        NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:timezone];
        NSInteger sourceSeconds = [sourceTimeZone secondsFromGMTForDate:self.time];
        
        NSTimeInterval timeDiff = 0;
        if(destinationSeconds > sourceSeconds) timeDiff = sourceSeconds - destinationSeconds;
        else timeDiff = destinationSeconds - sourceSeconds;
        self.time = [[NSDate alloc] initWithTimeInterval:timeDiff sinceDate:self.time];
    }
    
    self.icon = data[@"icon"];
    self.windSpeed = [data[@"windSpeed"] floatValue];
    self.humidity = [data[@"humidity"]floatValue];
    self.uvIndex = [data[@"uvIndex"] intValue];
    self.precipProbability = [data[@"precipProbability"] floatValue];
    self.sunSet = data[@"sunsetTime"];
    self.sunRise = data[@"sunriseTime"];
    
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
    formatter.dateFormat = @"yyyy-MM-dd";
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    NSString *currentDayString = [formatter stringFromDate:date];
    
    NSArray *dateInArray = [currentDayString componentsSeparatedByString:@"-"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSString *day = dateInArray[2];
    dateComponents.day = [day intValue];
    NSString *month = dateInArray[1];
    dateComponents.month = [month intValue];
    NSString *year = dateInArray[0];
    dateComponents.year = [year intValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *usedDate = [calendar dateFromComponents:dateComponents];
    NSInteger numDayOfWeek = [calendar component:NSCalendarUnitWeekday fromDate:usedDate];
    return dayOfWeek[(int)numDayOfWeek];
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

-(NSString*)getprecipProbabilityInString:(float)precipProbability{
    NSString* string = [NSString stringWithFormat:@"%.0f",precipProbability*100];
    string = [string stringByAppendingString:@"%"];
    return string;
}



-(NSString*)getWindSpeedInString:(float)windspeed{
    NSString* string = [NSString stringWithFormat:@"%.02f ",windspeed];
    string = [string stringByAppendingString:@"mph"];
    return string;
}

-(NSString*)formatSummary{
    NSString *icon = self.icon;
    NSString *summary;
    icon = [icon stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    icon = [icon stringByReplacingOccurrencesOfString:@"day" withString:@""];
    icon = [icon stringByReplacingOccurrencesOfString:@"night" withString:@""];
    icon = [icon capitalizedString];
    
    summary = [NSString localizedStringWithFormat:@"%@ currently with a high of %d. The low tonight will be %d",icon,self.temperatureHigh,self.temperatureLow];

    
    return summary;
}





@end
