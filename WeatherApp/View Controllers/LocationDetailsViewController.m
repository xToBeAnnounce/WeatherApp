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
@property (strong, nonatomic) UITextField *customNameTextField;

/* Date Switches */
@property (strong, nonatomic) UISwitch *startSwitch;
@property (strong, nonatomic) UISwitch *endSwitch;


/* Date Pickers */
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;

/* View properties */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *placeNameView;
@property (strong, nonatomic) UIStackView *mainStackView;
@end

@implementation LocationDetailsViewController

NSMutableDictionary *locationAttributeDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationAttributeDict = [[NSMutableDictionary alloc] init];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Setting up navigation buttons
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveLocationDetail)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelectedLocation)];
    self.navigationItem.rightBarButtonItem = saveButton;
//    if (self.saveNewLocation) {
//        self.navigationController.navigationBar.topItem.rightBarButtonItem = saveButton;
//        self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
//    }
//    else {
//        self.navigationItem.rightBarButtonItem = saveButton;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void) setUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *screenTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:screenTapGesture];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    self.placeNameView = [[UIView alloc] init];
    self.placeNameView.backgroundColor = [UIColor lightGrayColor];
    self.placeNameView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Displays name of location (missing center anchor)
    self.placeNameLabel = [[UILabel alloc]init];
    self.placeNameLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    self.placeNameLabel.textColor = UIColor.blackColor;
    self.placeNameLabel.text = self.location.fullPlaceName;
    [self.placeNameLabel sizeToFit];
    self.placeNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.placeNameView addSubview:self.placeNameLabel];
    
    //Custom Name input
    self.customNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(200, 160, 0, 0)];
    self.customNameTextField.delegate = self;
    self.customNameTextField.textColor = UIColor.blackColor;
    self.customNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    if(self.location.customName && ![self.location.customName isEqualToString:@""]) {
        self.customNameTextField.text = self.location.customName;
        self.customNameTextField.placeholder = self.location.customName;
    }
    else {
        self.customNameTextField.placeholder = self.location.placeName;
        self.location.customName = self.location.placeName;
    }
    [self.customNameTextField sizeToFit];
    
    self.startSwitch = [[UISwitch alloc] init];
    [self.startSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    
    self.endSwitch = [[UISwitch alloc] init];
    [self.endSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    
    //Start and End date pickers (Next step: try to make them hidden when unsed)
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate;
    if (self.location.startDate) [self.startDatePicker setDate:self.location.startDate];
    self.startDatePicker.hidden = YES;
    
    self.endDatePicker = [[UIDatePicker alloc]init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    if (self.location.endDate) [self.endDatePicker setDate:self.location.endDate];
    self.endDatePicker.hidden = YES;
    
    NSArray *stackSubViews = @[self.placeNameView,
                               [self makeHStackViewFor:self.customNameTextField withLabel:@"Custom Name"],
                               [self makeHStackViewFor:self.startSwitch withLabel:@"Start Date"],
                               self.startDatePicker,
                               [self makeHStackViewFor:self.endSwitch withLabel:@"End Date"],
                               self.endDatePicker
                               ];
    
    self.mainStackView = [[UIStackView alloc] initWithArrangedSubviews:stackSubViews];
    self.mainStackView.axis = UILayoutConstraintAxisVertical;
    self.mainStackView.distribution = UIStackViewDistributionFillProportionally;
    self.mainStackView.alignment = UIStackViewAlignmentCenter;
    self.mainStackView.spacing = 10;
    self.mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mainStackView];
    
    [self setConstraints];
}

- (UIStackView *) makeHStackViewFor:(UIControl *)labeledControl withLabel:(NSString *)labelText{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    
    [stackView addArrangedSubview:label];
    [stackView addArrangedSubview:labeledControl];
    
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor].active = YES;
    labeledControl.translatesAutoresizingMaskIntoConstraints = NO;
    [labeledControl.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor].active = YES;
    
    return stackView;
}

- (void) setConstraints {
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.placeNameView.heightAnchor constraintEqualToConstant:self.view.frame.size.height/3].active = YES;
    
    [self.placeNameLabel.centerYAnchor constraintEqualToAnchor:self.placeNameView.centerYAnchor].active = YES;
    [self.placeNameLabel.centerXAnchor constraintEqualToAnchor:self.placeNameView.centerXAnchor].active = YES;
    
    [self.mainStackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.mainStackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-8].active = YES;
    [self.mainStackView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor].active = YES;
    [self.mainStackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:8].active = YES;
    [self.mainStackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-8].active = YES;
    
    for (UIView *subview in self.mainStackView.arrangedSubviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
        
        if ([subview.class isEqual:UIStackView.class] || [subview.class isEqual:UIView.class]){
            [subview.leadingAnchor constraintEqualToAnchor:self.mainStackView.leadingAnchor].active = YES;
            [subview.trailingAnchor constraintEqualToAnchor:self.mainStackView.trailingAnchor].active = YES;
        }
        else {
            [subview.centerXAnchor constraintEqualToAnchor:self.mainStackView.centerXAnchor].active = YES;
        }
    }
}

-(IBAction)onToggleDate:(id)sender{
    if([sender isEqual:self.startSwitch]) {
        if (self.startSwitch.isOn)   self.startDatePicker.hidden = NO;
        else    self.startDatePicker.hidden = YES;
    }
    else if ([sender isEqual:self.endSwitch]){
        if (self.endSwitch.isOn) self.endDatePicker.hidden = NO;
        else    self.endDatePicker.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//Press Return to save
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.customNameTextField.text isEqualToString:@""]) {
        [locationAttributeDict removeObjectForKey:@"customName"];
    }
    else {
        [locationAttributeDict setObject:self.customNameTextField.text forKey:@"customName"];
    }
    NSLog(@"%@", [locationAttributeDict objectForKey:@"customName"]);
}

-(void)cancelSelectedLocation{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveLocationDetail{
    [locationAttributeDict setObject:self.startDatePicker.date forKey:@"startDate"];
    [locationAttributeDict setObject:self.endDatePicker.date forKey:@"endDate"];
    
    if(!self.startSwitch.isOn) [locationAttributeDict setObject:[NSDate date] forKey:@"startDate"];
    if(!self.endSwitch.isOn) [locationAttributeDict removeObjectForKey:@"endDate"];
    
    NSDate *startDate = [locationAttributeDict objectForKey:@"startDate"];
    NSDate *endDate = [locationAttributeDict objectForKey:@"endDate"];
    
    //Does not save is endDate > startDate
    if ((startDate == nil || endDate == nil) || [[startDate earlierDate:endDate] isEqualToDate:startDate]) {
        [self.location setValuesForKeysWithDictionary:locationAttributeDict];
        if (self.saveNewLocation) {
            // Add location to user
            [User.currentUser addLocation:self.location completion:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else NSLog(@"%@", error.localizedDescription);
            }];
        }
        else {
            // Save changes to existing Location
            [self.location saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Dates" message:@"Start date cannot be later than end date." preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)dateDidChange:(id)sender {
    if ([sender isEqual:self.startDatePicker]) {
        [locationAttributeDict setObject:self.startDatePicker.date forKey:@"startDate"];
    }
    else if ([sender isEqual:self.endDatePicker]){
        [locationAttributeDict setObject:self.endDatePicker.date forKey:@"endDate"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
