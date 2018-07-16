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
@property (strong, nonatomic) NSMutableDictionary *locations;  // Dictionary with NSString to Location object

+( instancetype)currentUser;
- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block;
- (void) saveNewPreferences:(Preferences *)preferences withCompletion:(PFBooleanResultBlock)completion;
- (void) addNewLocation:(Location *)location withCompletion:(PFBooleanResultBlock)completion;
- (void) updatePreferencesWithDictionary:(NSDictionary *)dictionary withCompletion:(PFBooleanResultBlock)completion;
@end
