//
//  Activity.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivityDelegate
-(void)displayPopoverData;
@end

@interface Activity : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon; //Icon of location provided
@property (strong, nonatomic) NSString *placeID; //Used to access webview / google maps in the future
@property (strong, nonatomic) NSString *address;
@end
