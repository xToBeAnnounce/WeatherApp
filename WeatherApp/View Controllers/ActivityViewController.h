//
//  ActivityViewController.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/27/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Weather.h"

@interface ActivityViewController : UIViewController
-(instancetype)initWithLocation:(Location*)loc weather:(Weather*)weather index:(int)idx;
@end
