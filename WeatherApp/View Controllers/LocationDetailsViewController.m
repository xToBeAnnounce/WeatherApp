//
//  LocationDetailsViewController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/23/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "User.h"

@interface LocationDetailsViewController () <UITextFieldDelegate>
/* Name Labels */
@property (strong, nonatomic) UILabel *placeNameLabel;
@property (strong, nonatomic) UILabel *customNameLabel;
@property (strong, nonatomic) UITextField *customNameTextField;

/* Date Pickers */
@property (strong, nonatomic) UILabel *startDateLabel;
@property (strong, nonatomic) UILabel *endDateLabel;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (strong, nonatomic) UISwitch *startSwitch;
@property (strong, nonatomic) UISwitch *endSwitch;

/* Navigation Properties */
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@end

@implementation LocationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initalizeLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    //Setting up navigation buttons
    self.saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveLocationDetail)];
    self.cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectedLocation)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = self.saveButton;
    self.navigationController.navigationBar.topItem.leftBarButtonItem = self.cancelButton;
}

-(void)initalizeLabel{
    //Displays name of location (missing center anchor)
    self.placeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, 100, 0, 0)];
    self.placeNameLabel.textColor = UIColor.blackColor;
    self.placeNameLabel.text = self.location.placeName;
    [self.placeNameLabel sizeToFit];
    [self.view addSubview:self.placeNameLabel];
    
    //Custom Name
    self.customNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 160, 0, 0)];
    self.customNameLabel.textColor = UIColor.blackColor;
    self.customNameLabel.text = @"Custon Name";
    [self.customNameLabel sizeToFit];
    [self.view addSubview:self.customNameLabel];
    
    //Custom Name input
    self.customNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(200, 160, 0, 0)];
    self.customNameTextField.delegate = self;
    self.customNameTextField.textColor = UIColor.blackColor;
    self.customNameTextField.placeholder = @"custom name";
    if(![self.location.customName isEqualToString:@""]) self.customNameTextField.text = self.location.customName;
    [self.customNameTextField sizeToFit];
    [self.view addSubview:self.customNameTextField];
    
    self.startDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 190, 0, 0)];
    self.startDateLabel.textColor = UIColor.blackColor;
    self.startDateLabel.text = @"Start Date";
    [self.startDateLabel sizeToFit];
    [self.view addSubview:self.startDateLabel];
    
    self.startSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(150, 190, 70, 50)];
    [self.startSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.startSwitch];
    
    self.endSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(150, 430, 70, 50)];
    [self.endSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.endSwitch];
    
    self.endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 430, 0, 0)];
    self.endDateLabel.textColor = UIColor.blackColor;
    self.endDateLabel.text = @"End Date";
    [self.endDateLabel sizeToFit];
    [self.view addSubview:self.endDateLabel];
    
    //Start and End date pickers (Next step: try to make them hidden when unsed)
    self.startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(50, 220, 0, 0)];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate;
    self.startDatePicker.hidden = YES;
    [self.view addSubview:self.startDatePicker];

    self.endDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(50, 460, 0, 0)];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    self.endDatePicker.hidden = YES;
    [self.view addSubview:self.endDatePicker];
}

-(IBAction)onToggleDate:(id)sender{
    if([sender isEqual:self.startSwitch]) {
        if (self.startSwitch.isOn)   self.startDatePicker.hidden = NO;
        else    self.startDatePicker.hidden = YES;
    }
    else if ([sender isEqual:self.endSwitch]){
        if (self.endSwitch.isOn) self.startDatePicker.hidden = NO;
        else    self.endDatePicker.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//Press Return to save
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.location.customName = self.customNameTextField.text;
    NSLog(@"%@", self.location.customName);
}

-(void)cancelSelectedLocation{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveLocationDetail{
    NSDate *startDate = self.startDatePicker.date;
    NSDate *endDate = self.endDatePicker.date;
    if(!self.startSwitch.isOn) startDate = nil;
    if(!self.endSwitch.isOn) endDate = nil;
    
    //Does not save is endDate > startDate
    if((startDate == nil || endDate == nil) || [[startDate earlierDate:endDate] isEqualToDate:startDate]){
        self.location.startDate = startDate;
        self.location.endDate = endDate;
    }
    User *currentUser = [User currentUser];
    [currentUser addLocation:self.location completion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
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
