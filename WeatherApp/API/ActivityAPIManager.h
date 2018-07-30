//
//  ActivityAPIManager.h
//  WeatherApp
//
//  Created by Tiffany Ma on 7/26/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ActivityAPIManager : NSObject
+(instancetype)shared;
-(void)getActivityDataWithLocation:(NSArray*)location Keyword:(NSString*)keyword WithCompletion:(void(^)(NSDictionary *data, NSError *error))completion;
@end
