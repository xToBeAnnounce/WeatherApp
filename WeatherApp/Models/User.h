//
//  User.h
//  WeatherApp
//
//  Created by Jamie Tan on 7/16/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Parse/Parse.h>
#import "Preferences.h"
#import "Location.h"

@interface User : PFUser

@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) NSMutableDictionary *locations;  // Dictionary with NSString to Location objectId
@property (strong, nonatomic) NSMutableArray *locationOrder;

// Get current user
+ (instancetype)currentUser;

// Sign up
- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block;

// Preference methods
- (void) saveNewPreferences:(Preferences *)preferences withCompletion:(PFBooleanResultBlock)completion;
- (void) updatePreferencesWithDictionary:(NSDictionary *)dictionary withCompletion:(PFBooleanResultBlock)completion;
- (void) getUserPreferencesWithBlock:(void(^)(Preferences *pref, NSError *error))block;

// Location methods
- (void) addLocationWithLongitude:(double)longitude lattitude:(double)lattitude key:(NSString *)key attributes:(NSDictionary *)attributes completion:(PFBooleanResultBlock)completion;
- (void) updateDefaultLocationWithBlock:(PFBooleanResultBlock)completion;
- (Location *) getLocationWithKey:(NSString *)key;
@end
