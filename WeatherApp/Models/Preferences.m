//
//  Preferences.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences
@dynamic tooHotTemp, tooColdTemp, tempTypeString, defaultLocationKey, notificationsOn, locationOn, learningOn;

+ (nonnull NSString *)parseClassName {
    return @"Preferences";
}

+ (instancetype) defaultPreferences {
    Preferences *newPreferences = Preferences.new;
    
    newPreferences.tooHotTemp = @100;
    newPreferences.tooColdTemp = @40;
    newPreferences.tempTypeString = @"F";
    newPreferences.defaultLocationKey = @"current";
    newPreferences.locationOn = YES;
    newPreferences.notificationsOn = YES;
    newPreferences.learningOn = NO;
    
    return newPreferences;
}
@end
