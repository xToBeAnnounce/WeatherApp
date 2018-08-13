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
@property (strong, nonatomic) NSString *timezone;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *icon;
@property (nonatomic) int temperature;
@property (nonatomic) int temperatureHigh;
@property (nonatomic) int temperatureLow;
@property (nonatomic) float humidity;
@property (nonatomic) float windSpeed;
@property (strong,nonatomic) NSDate *sunRise;
@property (strong,nonatomic) NSDate *sunSet;
@property (nonatomic) int uvIndex;
@property (nonatomic) float precipProbability;

//Formatting functions for display in string
- (NSString*)getHourInDayWithTime:(NSDate*)date;
- (NSString*)getDayOfWeekWithTime:(NSDate*)date;
- (NSString*)getDateInString:(NSDate*)date;
- (NSString*)getTempInString:(int)temp;
- (NSString*)getTempInString:(int)temp withType:(NSString *)type;
-(NSString*)getHumidityInString:(float)humidity;
-(NSString*)getWindSpeedInString:(float)windspeed;
-(NSString*)getprecipProbabilityInString:(float)precipProbability;
-(NSString*)formatSummary:(NSString*)summary;
-(NSString*)formattedIconSummary;



- (instancetype)initWithData:(NSDictionary*)data Timezone:(NSString*)timezone;
@end
