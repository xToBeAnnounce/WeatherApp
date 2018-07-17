//
//  Preferences.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Parse/Parse.h>

@interface Preferences : PFObject <PFSubclassing>

@property (strong, nonatomic) NSNumber *tooHotTemp;
@property (strong, nonatomic) NSNumber *tooColdTemp;
@property (strong, nonatomic) NSString *tempTypeString;   //c or f
@property (strong, nonatomic) NSString *defaultLocationKey;
@property (nonatomic) BOOL notificationsOn;
@property (nonatomic) BOOL locationOn; //Access to user location

+ (instancetype) defaultPreferences;
@end
