//
//  LocationDetailsViewController.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/23/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "AppDelegate.h"

@interface LocationDetailsViewController : UIViewController
@property (strong, nonatomic) Location *location;
@property (nonatomic) BOOL saveNewLocation;

@property (strong, nonatomic) id<NavigationDelegate> delegate;
@end
