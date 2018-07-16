//
//  User.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic preferences, locations;

+ (instancetype)currentUser {
    return (User *)PFUser.currentUser;
}

- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block {
    self.preferences = Preferences.defaultPreferences;
    self.locations = NSMutableDictionary.new;
    [super signUpInBackgroundWithBlock:block];
}

- (void) saveNewPreferences:(Preferences *)preferences withCompletion:(PFBooleanResultBlock)completion{
    [self.preferences deleteInBackgroundWithBlock:nil];
    self.preferences = preferences;
    [self saveInBackgroundWithBlock:completion];
}

- (void) updatePreferencesWithDictionary:(NSDictionary *)dictionary withCompletion:(PFBooleanResultBlock)completion {
    [self.preferences setValuesForKeysWithDictionary:dictionary];
    [self.preferences saveInBackgroundWithBlock:completion];
}

- (void) addNewLocation:(Location *)location withCompletion:(PFBooleanResultBlock)completion{
    [self.locations setValue:location forKey:location.locationTypeKey];
    [self saveInBackgroundWithBlock:completion];
}

- (void) removeLocationWithKey:(NSString *)key withCompletion:(PFBooleanResultBlock)completion {
    [self.locations removeObjectForKey:key];
    [self saveInBackgroundWithBlock:completion];
}
@end
