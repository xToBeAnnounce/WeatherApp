//
//  WebViewViewController.h
//  WeatherApp
//
//  Created by Trustin Harris on 7/31/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Location.h"

@interface WebViewViewController : UIViewController
- (instancetype) initWithLocation:(Location *)location;
@end
