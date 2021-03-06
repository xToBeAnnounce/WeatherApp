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
    
    NSTimeInterval sunSet = [data[@"sunsetTime"] integerValue];
    self.sunSet = [NSDate dateWithTimeIntervalSince1970:sunSet];

    
    NSTimeInterval sunRise = [data[@"sunriseTime"] integerValue];
    self.sunRise = [NSDate dateWithTimeIntervalSince1970:sunRise];
   
    
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

-(NSString*)formatSummaryWithType:(NSString *)type{
    NSString *icon = [self formattedIconSummary];
    NSString *summary = [NSString localizedStringWithFormat:@"%@ currently with a high of %@ %@. The low tonight will be %@ %@.",icon,[self getTempInString:self.temperatureHigh withType:type], type, [self getTempInString:self.temperatureLow withType:type],type];
    return summary;
}

-(NSString*)formatSummary{
    NSString *icon = [self formattedIconSummary];
    NSString *summary = [NSString localizedStringWithFormat:@"%@ currently with a high of %d°F (%.0f°C). The low tonight will be %d°F (%.0f°C).",icon,self.temperatureHigh,((self.temperatureHigh-32)/1.8), self.temperatureLow,((self.temperatureLow-32)/1.8)];
    
    return summary;
}

-(NSString *)formattedIconSummary {
    NSString *summary = self.icon;
    summary = [summary stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    summary = [summary stringByReplacingOccurrencesOfString:@"day" withString:@""];
    summary = [summary stringByReplacingOccurrencesOfString:@"night" withString:@""];
    return summary;
}


@end
