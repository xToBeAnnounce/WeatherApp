//
//  User.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic preferences, locationsIDArray;

+ (instancetype)currentUser {
    User *user = (User *)PFUser.currentUser;
    return user;
}

- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block {
    self.preferences = Preferences.defaultPreferences;
    self.locationsIDArray = NSMutableArray.new;
    [super signUpInBackgroundWithBlock:block];
}


/*-------------------- PREFERENCE FUNCTIONS --------------------*/
// Save new preferences with a preferences object
- (void) saveNewPreferences:(Preferences *)preferences withCompletion:(PFBooleanResultBlock)completion{
    [self.preferences deleteInBackgroundWithBlock:nil];
    self.preferences = preferences;
    [self saveInBackgroundWithBlock:completion];
}

- (void) updatePreferencesWithDictionary:(NSDictionary *)dictionary withCompletion:(PFBooleanResultBlock)completion {
    [self.preferences setValuesForKeysWithDictionary:dictionary];
    [self.preferences saveInBackgroundWithBlock:completion];
}

- (void) getUserPreferencesWithBlock:(void(^)(Preferences *pref, NSError *error)) block {
    PFQuery *query = [PFQuery queryWithClassName:@"Preferences"];
    [query getObjectInBackgroundWithId:self.preferences.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        block((Preferences *)object, error);
    }];
}

/*-------------------- LOCATION FUNCTIONS --------------------*/
// save a new location for user with longitude and lattitude
- (void) addLocationWithLongitude:(double)longitude lattitude:(double)lattitude attributes:(NSDictionary *)attributes completion:(PFBooleanResultBlock)completion{
    [Location saveLocationWithLongitude:longitude lattitude:lattitude attributes:attributes withBlock:^(Location *location, NSError *error) {
        if (location) {
            [self.locationsIDArray addObject:location.objectId];
            
            self.locationsIDArray = [self.locationsIDArray copy];
            [self saveInBackgroundWithBlock:completion];
            self.locationsIDArray = [NSMutableArray arrayWithArray:self.locationsIDArray];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        
    }];
}

// save a new location for user with location object
- (void) addLocation:(Location *)location completion:(PFBooleanResultBlock)completion{
    if (location.longitude && location.lattitude && location.placeName) {
        if (!location.customName) location.customName = location.placeName;
        [location saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.locationsIDArray addObject:location.objectId];
                
                self.locationsIDArray = [self.locationsIDArray copy];
                [self saveInBackgroundWithBlock:completion];
                self.locationsIDArray = [NSMutableArray arrayWithArray:self.locationsIDArray];
            }
            else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
}

// get location with given ID
- (Location *)getLocationWithID:(NSString *)locID {
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    Location *location = [query getObjectWithId:locID];
    return location;
}

// delete location with given id
- (void) deleteLocationWithID:(NSString *)locID withCompletion:(PFBooleanResultBlock)completion {
    Location *location = [self getLocationWithID:locID];
    [location deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.locationsIDArray removeObject:locID];
            self.locationsIDArray = [self.locationsIDArray copy];
            [self saveInBackgroundWithBlock:completion];
            self.locationsIDArray = [NSMutableArray arrayWithArray:self.locationsIDArray];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (NSMutableArray *) getLocationsArray{
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
    
    for (NSString *locID in self.locationsIDArray) {
        [locationsArray addObject:[self getLocationWithID:locID]];
    }
    
    return locationsArray;
}

- (void) getLocationsArrayInBackgroundWithBlock:(void(^)(NSMutableArray *locations, NSError *error))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // No explicit autorelease pool needed here.
        // The code runs in background, not strangling
        // the main run loop.
        NSMutableArray *locations = [self getLocationsArray];
        NSError *error;
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(locations, error);
        });
    });
}

@end
