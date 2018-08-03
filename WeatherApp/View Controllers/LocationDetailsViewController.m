//
//  LocationDetailsViewController.m
//  WeatherApp
//
//  Created by Tiffany Ma on 7/23/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "User.h"

// TODO: ADD HUD WHEN CURRENTLY SAVING

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

/* Delete Location Button */
@property (strong, nonatomic) UIButton *deleteLocationButton;

/* View properties */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *placeNameView;
@property (strong, nonatomic) UIStackView *mainStackView;
@end

@implementation LocationDetailsViewController

NSMutableDictionary *locationAttributeDict;

BOOL saving = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationAttributeDict = [[NSMutableDictionary alloc] init];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Setting up navigation buttons
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveLocationDetail:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    //For information page
    if (self.navigationController.viewControllers.count <= 1) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(didTapClose:)];
        self.navigationItem.leftBarButtonItem = closeButton;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) initalizeControlProperties {
    //Displays name of location
    self.placeNameLabel = [[UILabel alloc]init];
    self.placeNameLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightThin];
    self.placeNameLabel.textColor = UIColor.blackColor;
    self.placeNameLabel.text = self.location.fullPlaceName;
    self.placeNameLabel.numberOfLines = 0;
    self.placeNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.placeNameLabel sizeToFit];
    self.placeNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Custom Name input
    self.customNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(200, 160, 0, 0)];
    self.customNameTextField.delegate = self;
    self.customNameTextField.textColor = UIColor.blackColor;
    self.customNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    if (!self.location.customName || [self.location.customName isEqualToString:@""]) {
        self.location.customName = self.location.placeName;
    }
    self.customNameTextField.placeholder = self.location.customName;
    //    [self.customNameTextField sizeToFit];
    [self.customNameTextField addTarget:self action:@selector(onEditedCustomName) forControlEvents:UIControlEventEditingChanged];
    
    // Date Switches
    self.startSwitch = [[UISwitch alloc] init];
    self.startSwitch.on = (BOOL)self.location.startDate;
    [self.startSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    
    self.endSwitch = [[UISwitch alloc] init];
    self.endSwitch.on = (BOOL)self.location.endDate;
    [self.endSwitch addTarget:self action:@selector(onToggleDate:) forControlEvents:UIControlEventValueChanged];
    
    //Start and End date pickers (Next step: try to make them hidden when unsed)
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate;
    if (self.location.startDate) [self.startDatePicker setDate:self.location.startDate];
    self.startDatePicker.hidden = !(BOOL)self.location.startDate;;
    
    self.endDatePicker = [[UIDatePicker alloc]init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    if (self.location.endDate) [self.endDatePicker setDate:self.location.endDate];
    self.endDatePicker.hidden = !(BOOL)self.location.endDate;
    
    // Delete location button
    self.deleteLocationButton = [[UIButton alloc] init];
    [self.deleteLocationButton setTitle:@"Delete Location" forState:UIControlStateNormal];
    [self.deleteLocationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.deleteLocationButton.hidden = self.saveNewLocation;
    [self.deleteLocationButton addTarget:self action:@selector(onTapDelete:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setUI {
    [self initalizeControlProperties];
    
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
    [self.placeNameView addSubview:self.placeNameLabel];
    
    NSArray *stackSubViews = @[self.placeNameView,
                               [self makeHStackViewFor:self.customNameTextField withLabel:@"Custom Name"],
                               [self makeHStackViewFor:self.startSwitch withLabel:@"Start Date"],
                               self.startDatePicker,
                               [self makeHStackViewFor:self.endSwitch withLabel:@"End Date"],
                               self.endDatePicker,
                               self.deleteLocationButton
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
    [self.placeNameLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.placeNameView.leadingAnchor constant:8].active = YES;
    [self.placeNameLabel.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.placeNameView.trailingAnchor constant:8].active = YES;
    
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

- (void) onEditedCustomName {
    if ([self.customNameTextField.text isEqualToString:@""]) {
        [locationAttributeDict removeObjectForKey:@"customName"];
    }
    else {
        [locationAttributeDict setObject:self.customNameTextField.text forKey:@"customName"];
    }
}

-(void)cancelSelectedLocation{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveLocationDetail:(id)sender{
    [self.customNameTextField resignFirstResponder];
    if (saving) return;
    
    saving = YES;
    NSDate *startDate = self.startDatePicker.date;
    NSDate *endDate = self.endDatePicker.date;
    
    if(!self.startSwitch.isOn) startDate = nil;
    if(!self.endSwitch.isOn) endDate = nil;
    
    
    
    if (startDate && endDate && [NSCalendar.currentCalendar compareDate:startDate toDate:endDate toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
        [self presentAlertWithMessage:@"Start date cannot be later than end date."];
    }
    else if (self.saveNewLocation && endDate && [NSCalendar.currentCalendar compareDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24] toDate:endDate toUnitGranularity:NSCalendarUnitDay] != NSOrderedAscending) {
        [self presentAlertWithMessage:@"Cannot create new location with expired end date."];
    }
    else {
        [self.location setValuesForKeysWithDictionary:locationAttributeDict];
        self.location.startDate = startDate;
        self.location.endDate = endDate;
        if (self.saveNewLocation) {
            // Add location to user
            [User.currentUser addLocation:self.location completion:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    saving = NO;
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                    saving = NO;
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
        else {
            // Save changes to existing Location
            [self.location saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    saving = NO;
                     [self navigateBackAppropriatelyAnimated:YES completion:nil];
                }
            }];
        }
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) presentAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Date Input" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        saving = NO;
    }];
}

- (IBAction)onTapDelete:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to delete this location?" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];

    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [User.currentUser deleteLocationWithID:self.location.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self navigateBackAppropriatelyAnimated:YES completion:nil];
            }
            else {
                NSLog(@"Error occured: %@", error.localizedDescription);
            }
        }];
    }];
    [alert addAction:yesAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (IBAction)didTapClose:(id)sender {
    [self navigateBackAppropriatelyAnimated:YES completion:nil];
}

- (void) navigateBackAppropriatelyAnimated:(BOOL)flag completion:(void (^)(void))completion {
    // If was presented modally
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:flag completion:completion];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
