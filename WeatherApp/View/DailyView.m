//
//  DailyView.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/25/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyView.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeeklyCell.h"
#import "Location.h"


@implementation DailyView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setDailyUI];
    [self displayCurrentWeather];
}

- (void) updateDataIfNeeded {
    if (self.location.dailyData.count == 0) {
        [self.location fetchDataType:@"weekly" WithCompletion:^(NSDictionary * data, NSError * error) {
            if(error == nil){
                [self displayCurrentWeather];
                NSLog(@"%@",data);
            }
            else NSLog(@"%@", error.localizedDescription);
        }];
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat TableViewOffset = self.DailytableView.contentOffset.y;
//    if(self.oldframe.size.height-TableViewOffset > currentWeatherViewHeight){
//        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:50 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            CGRect newFrame = CGRectMake(self.oldframe.origin.x, self.oldframe.origin.y, self.oldframe.size.width, self.oldframe.size.height-TableViewOffset);
//            self.currentWeatherView.frame = newFrame;
//            if(fabs(self.oldframe.size.height - self.currentWeatherView.frame.size.height) <= 10){
//                self.temperatureLabel.alpha = 1;
//            }
//            else if (TableViewOffset > currentWeatherViewHeight){
//                self.temperatureLabel.alpha = 0;
//            }
//            else{
//                self.temperatureLabel.alpha = 1 - (currentWeatherViewHeight / (self.oldframe.size.height-TableViewOffset));
//            }
//            [self layoutIfNeeded];
//        } completion:nil];
//    }
//}

- (void) setLocation:(Location *)location {

    if (_location.weeklyData) location.weeklyData = _location.weeklyData[0];

    _location = location;
    [self updateDataIfNeeded];
    [self refreshView];
}

- (void)setTempType:(NSString *)tempType {
    _tempType = tempType;
    [self refreshView];
}

- (void) setDailyUI {
    
    //setting up icon image view
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(34, 3, 70 , 70)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    [self addSubview:self.iconImageView];
    
    //setting up humidity label
    UILabel *humidityTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 110, 0, 0)];
    humidityTitle.font = [UIFont systemFontOfSize:15];

    humidityTitle.text = @"HUMIDITY";
    [humidityTitle sizeToFit];
    [self addSubview:humidityTitle];
    
    self.humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 130, 0, 0)];
    self.humidityLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview: self.humidityLabel];
    
    //setting up windspeed label
    UILabel *windspeedTitle = [[UILabel alloc]initWithFrame:CGRectMake(230, 110, 0, 0)];
    windspeedTitle.font = [UIFont systemFontOfSize:15];
    windspeedTitle.text = @"WIND SPEED";
    [windspeedTitle sizeToFit];
    [self addSubview:windspeedTitle];
    
    self.windspeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 130 , 0, 0)];
    self.windspeedLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview: self.windspeedLabel];
    
    //settings up uvIndex
    UILabel *uvIndexTitle = [[UILabel alloc]initWithFrame:CGRectMake(62, 160, 0, 0)];
    uvIndexTitle.font = [UIFont systemFontOfSize:15];
    uvIndexTitle.text = @"UV INDEX";
    [uvIndexTitle sizeToFit];
    [self addSubview:uvIndexTitle];
    
    self.uvIndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 180, 0, 0)];
    self.uvIndexLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.uvIndexLabel];
    
    UILabel *rainChanceTitle = [[UILabel alloc]initWithFrame:CGRectMake(220, 160, 0, 0)];
    rainChanceTitle.font = [UIFont systemFontOfSize:15];
    rainChanceTitle.text = @"CHANCE OF RAIN";
    [rainChanceTitle sizeToFit];
    [self addSubview:rainChanceTitle];
    
    self.rainChance = [[UILabel alloc]initWithFrame:CGRectMake(250, 180, 0, 0)];
    self.rainChance.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.rainChance];
    
    
    self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 19, 0, 0)];
    self.summaryLabel.text = @"--";
    self.summaryLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.summaryLabel];
    
}


-(void)displayCurrentWeather{
    Weather *currentWeather;
    if (self.location.weeklyData.count) currentWeather = self.location.weeklyData[0];
    
    self.iconImageView.image = [UIImage imageNamed:currentWeather.icon];
    
    self.humidityLabel.text = [currentWeather getHumidityInString:currentWeather.humidity];
    [self.humidityLabel sizeToFit];
    
    self.windspeedLabel.text = [currentWeather getWindSpeedInString:currentWeather.windSpeed];
    [self.windspeedLabel sizeToFit];
    

    self.uvIndexLabel.text = [NSString stringWithFormat:@"%d", currentWeather.uvIndex];
    [self.uvIndexLabel sizeToFit];
    
    self.summaryLabel.text = currentWeather.summary;
    [self.summaryLabel  sizeToFit];
    
    self.rainChance.text = [currentWeather getprecipProbabilityInString:currentWeather.precipProbability];
    [self.rainChance sizeToFit];

}



- (void) refreshView {
    [self displayCurrentWeather];
}




@end
