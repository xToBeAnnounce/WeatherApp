//
//  CustomCameraViewController.h
//  WeatherApp
//
//  Created by Jamie Tan on 8/6/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCameraDelegate

- (void)didTakePhoto:(UIImage *)image;

@end

@interface CustomCameraViewController : UIViewController

@property (strong, nonatomic) id<CustomCameraDelegate> delegate;

@end
