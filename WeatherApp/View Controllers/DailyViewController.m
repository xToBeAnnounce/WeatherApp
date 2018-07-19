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


@interface DailyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray *DailyArrary;
@property (strong,nonatomic) NSMutableArray *hourlyArrary;
@property (strong,nonatomic) UITableView *ourtableView;
@property (strong,nonatomic) UIImageView *IconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;
@property (strong,nonatomic) NSArray *testArrary;

@end



@implementation DailyViewController
static float lat = 42.3601;
static float lng = -71.0589;
static bool loadedData = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDailyData];
    //[self setUI];
    self.testArrary = @[@"10am",@"11am",@"12am",@"1pm",@"2pm",@"3pm",];
    self.DailyArrary = [[NSMutableArray alloc] init];
    
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
    
-(void)getDailyData{
    APIManager *apiManager = [APIManager shared];
    NSDate *currDate = [NSDate date];
    [apiManager setURLWithLatitude:lat Longitude:lng Time:currDate Range:@"daily"];
    [apiManager getDataWithCompletion:^(NSDictionary *data, NSError *error) {
       
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        } else {
            [self.DailyArrary addObject:[[NSDictionary alloc]initWithDictionary:data]];
            loadedData = YES;
            NSLog(@"%@", data);
            [self.ourtableView reloadData];
            [self setUI];
        }
    }];
}

-(void)setUI{
    NSDictionary *newDict = self.DailyArrary[0];
    
    //setting up icon image view
    NSString *iconName = newDict[@"currently"][@"icon"];
    self.IconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 90, 166, 166)];
    self.IconImageView.image = [UIImage imageNamed:iconName];
    [self.view addSubview:self.IconImageView];
    
    //setting up temperatureLabel
    NSString *temp = newDict[@"currently"][@"temperature"];
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 250, 0, 0)];
    self.temperatureLabel.font = [UIFont systemFontOfSize:60];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.0ld", (long)temp.integerValue ];
    [self.temperatureLabel sizeToFit];
    [self.view addSubview:self.temperatureLabel];
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 10, 10)];
    self.locationLabel.font = [UIFont systemFontOfSize:35];
    self.locationLabel.text = newDict[@"timezone"];
    [self.locationLabel sizeToFit];
    [self.view addSubview:self.locationLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [self.ourtableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil){
        cell = [[DailyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    if(loadedData){
        [cell setCellUI:self.DailyArrary];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
