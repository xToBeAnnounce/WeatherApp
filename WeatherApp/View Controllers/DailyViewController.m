//
//  DailyViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyViewController.h"
#import "APIManager.h"
#import "DailyTableViewCell.h"
#import "Weather.h"

@interface DailyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *DailyArrary;
@property (strong,nonatomic) UIImageView *IconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) UIImageView *backgroundImageView;



@end

static bool loadData = NO;

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.location = [Location currentLocation]; //For testing
    [self.location fetchDataType:@"daily" WithCompletion:^(NSDictionary * data, NSError * error) {
        if(error == nil){
            [self setUI];
            loadData = YES;
            [self.ourtableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //sets table view
    CGFloat yorigin = self.view.frame.origin.y + self.view.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.view.frame.origin.x, yorigin, self.view.frame.size.width, self.view.frame.size.height/2);
    self.ourtableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    self.ourtableView.delegate = self;
    self.ourtableView.dataSource = self;
    [self.ourtableView registerClass:DailyTableViewCell.class forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.ourtableView];
}

-(void)setUI{
    Weather *currentWeather = self.location.dailyData[0];
    
    //setting up background images
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 320)];
    self.backgroundImageView.image = [UIImage imageNamed:@"sunnybackground"];
    [self.view addSubview:self.backgroundImageView];
    
    
    //setting up icon image view
    NSString *iconName = currentWeather.icon;
    self.IconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 90, 166, 166)];
    self.IconImageView.image = [UIImage imageNamed:iconName];
    [self.view addSubview:self.IconImageView];
    
    //setting up temperatureLabel
    NSString *temp = [currentWeather getTempInString:currentWeather.temperature];
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 250, 0, 0)];
    self.temperatureLabel.font = [UIFont systemFontOfSize:60];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.0ld", (long)temp.integerValue ];
    [self.temperatureLabel sizeToFit];
    [self.view addSubview:self.temperatureLabel];
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 10, 10)];
    self.locationLabel.font = [UIFont systemFontOfSize:35];
    //WAITING FOR LOCATION TEXT
    [self.locationLabel sizeToFit];
    [self.view addSubview:self.locationLabel];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [self.ourtableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if(cell == nil){
        cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    if(loadData){
        Weather *hourlyWeather = self.location.dailyData[indexPath.row];
        [cell setCellUI:hourlyWeather];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.location.dailyData.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
