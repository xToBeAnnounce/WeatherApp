//
//  User.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic preferences, locations, locationOrder;

+ (instancetype)currentUser {
    return (User *)PFUser.currentUser;
}

- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block {
    self.preferences = Preferences.defaultPreferences;
    self.locations = NSMutableDictionary.new;
    self.locationOrder = NSMutableArray.new;
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

- (void) addLocationWithLongitude:(double)longitude lattitude:(double)lattitude key:(NSString *)key attributes:(NSDictionary *)attributes completion:(PFBooleanResultBlock)completion{
    if (![[self.locations allKeys] containsObject:key]) {
        [Location saveLocationWithLongitude:longitude lattitude:lattitude key:key attributes:attributes withBlock:^(Location *location, NSError *error) {
            if (location) {
                [self.locations setValue:location.objectId forKey:location.customName];
                [self.locationOrder addObject:location.customName];
                
                self.locations = [self.locations copy];
                self.locationOrder = [self.locationOrder copy];
                [self saveInBackgroundWithBlock:completion];
                self.locations = (NSMutableDictionary *)self.locations;
                self.locationOrder = (NSMutableArray *)self.locationOrder;
            }
            else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            
        }];
    }
    else {
        NSLog(@"Key %@ already exists", key);
    }
}

- (void) updateDefaultLocationWithBlock:(PFBooleanResultBlock)completion {
    if ([self.locationOrder containsObject:self.preferences.defaultLocationKey]) {
        [self.locationOrder removeObject:self.preferences.defaultLocationKey];
        [self.locationOrder insertObject:self.preferences.defaultLocationKey atIndex:0];
        
        self.locationOrder = [self.locationOrder copy];
        [self saveInBackgroundWithBlock:completion];
        self.locationOrder = (NSMutableArray *)self.locationOrder;
    }
    else {
        NSLog(@"Location with given key does not exist");
    }
}

- (void) removeLocationWithKey:(NSString *)key withCompletion:(PFBooleanResultBlock)completion {
    [self.locations removeObjectForKey:key];
    [self.locationOrder removeObject:key];
    
    self.locations = [self.locations copy];
    self.locationOrder = [self.locationOrder copy];
    [self saveInBackgroundWithBlock:completion];
    self.locations = (NSMutableDictionary *)self.locations;
    self.locationOrder = (NSMutableArray *)self.locationOrder;
}

- (Location *) getLocationWithKey:(NSString *)key{
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    Location *location = [query getObjectWithId:self.locations[key]];
    return location;
}
@end
