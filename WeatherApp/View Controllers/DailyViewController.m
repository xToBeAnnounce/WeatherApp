//
//  DailyViewController.m
//  WeatherApp
//
//  Created by Trustin Harris on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "DailyViewController.h"
#import "APIManager.h"


@interface DailyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray *testArrary;
@property (strong,nonatomic) UITableView *ourtableView;
@property (strong,nonatomic) UIImageView *IconImageView;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *locationLabel;


@end

@implementation DailyViewController
NSString *cellId = @"CellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setUI];
    
    self.testArrary = @[@"10am", @"11am", @"12pm",@"1pm",@"2pm",@"3pm",@"4pm"];
    
    self.ourtableView.delegate = self;
    self.ourtableView.dataSource = self;
}

-(void)setUI{
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //setting up table view
    CGFloat yorigin = self.view.frame.origin.y + self.view.frame.size.height/2;
    CGRect boundsD = CGRectMake(self.view.frame.origin.x, yorigin, self.view.frame.size.width, self.view.frame.size.height/2);
    self.ourtableView = [[UITableView alloc]initWithFrame:boundsD style:UITableViewStylePlain];
    [self.view addSubview:self.ourtableView];
    
    //setting up icon image view
    self.IconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 90, 166, 166)];
    self.IconImageView.image = [UIImage imageNamed:@"sunny"];
    [self.view addSubview:self.IconImageView];
    
    //setting up temperatureLabel
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 250, 0, 0)];
    self.temperatureLabel.font = [UIFont systemFontOfSize:60];
    self.temperatureLabel.text = @"70";
    [self.temperatureLabel sizeToFit];
    [self.view addSubview:self.temperatureLabel];
    
    //setting up locationLabel
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 10, 10)];
    self.locationLabel.font = [UIFont systemFontOfSize:35];
    self.locationLabel.text = @"San Fransico";
    [self.locationLabel sizeToFit];
    [self.view addSubview:self.locationLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     [self.ourtableView registerClass:[UITableViewCell self] forCellReuseIdentifier:cellId];
    UITableViewCell *cell = [self.ourtableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.textLabel.text = self.testArrary[indexPath.row];
   
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testArrary.count;
}



@end
