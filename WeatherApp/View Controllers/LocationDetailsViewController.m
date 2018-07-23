//
//  LocationDetailsViewController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/23/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationDetailsViewController.h"

@interface LocationDetailsViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UILabel *placeNameLabel;
@property (strong, nonatomic) UILabel *custonNameLabel;
@property (strong, nonatomic) UITextField *custonNameTextField;
@property (strong, nonatomic) UILabel *startDateLabel;
@property (strong, nonatomic) UILabel *endDateLabel;
@end

@implementation LocationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"%@", self.location);
    [self initalizeUILabel];
}

-(void)initalizeUILabel{
    self.placeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, 100, 0, 0)];
    self.placeNameLabel.textColor = UIColor.blackColor;
    self.placeNameLabel.text = self.location.placeName;
    [self.placeNameLabel sizeToFit];
    [self.view addSubview:self.placeNameLabel];
    
    self.custonNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 160, 0, 0)];
    self.custonNameLabel.textColor = UIColor.blackColor;
    self.custonNameLabel.text = @"Custon Name";
    [self.custonNameLabel sizeToFit];
    [self.view addSubview:self.custonNameLabel];
    
    self.custonNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(200, 160, 0, 0)];
    self.custonNameTextField.delegate = self;
    self.custonNameTextField.textColor = UIColor.blackColor;
    self.custonNameTextField.placeholder = @"custom name";
    if(![self.location.customName isEqualToString:@""]) self.custonNameTextField.text = self.location.customName;
    [self.custonNameTextField sizeToFit];
    [self.view addSubview:self.custonNameTextField];
    
    self.startDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 190, 0, 0)];
    self.startDateLabel.textColor = UIColor.blackColor;
    self.startDateLabel.text = @"Start Date";
    [self.startDateLabel sizeToFit];
    [self.view addSubview:self.startDateLabel];
    
    self.endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 220, 0, 0)];
    self.endDateLabel.textColor = UIColor.blackColor;
    self.endDateLabel.text = @"End Date";
    [self.endDateLabel sizeToFit];
    [self.view addSubview:self.endDateLabel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.location.customName = self.custonNameTextField.text;
    NSLog(@"%@", self.location.customName);
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
