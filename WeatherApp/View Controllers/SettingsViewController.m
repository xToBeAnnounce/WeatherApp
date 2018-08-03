//
//  SettingsViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "SettingsViewController.h"
#import "PreferenceTableViewCell.h"
#import "LocationTableViewCell.h"
#import "LocationDetailsViewController.h"
#import "LocationPickerViewController.h"
#import "PageViewController.h"
#import "User.h"
#import "PageViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableDictionary *updatePrefDict;

@property (strong, nonatomic) UITextField *tooHotTextField;
@property (strong, nonatomic) UITextField *tooColdTextField;
@property (strong, nonatomic) UISegmentedControl *tempTypeSegementedControl;
@property (strong, nonatomic) UISwitch *locationOnSwitch;
@property (strong, nonatomic) UISwitch *notificationsOnSwitch;
@property (strong, nonatomic) UISwitch *learningOnSwitch;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UITapGestureRecognizer *screenTap;

@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

static NSArray *sectionsArray;
static NSMutableDictionary *sectionsDict;
static NSString *preferenceCellID = @"PreferenceTableViewCell";
static NSString *locationCellID = @"LocationTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Intialize properties
    self.user = User.currentUser;
    [self initalizePreferenceControls];
    [self loadPreferences];
    [self setUI];
    
    sectionsArray = @[@"Preferences", @"Locations", @"AddLocation"];
    sectionsDict = [NSMutableDictionary dictionaryWithDictionary:
  @{
    @"Preferences":@[
            @[@"Hot Temperature", self.tooHotTextField],
            @[@"Cold Temperature", self.tooColdTextField],
            @[@"Temperature Type", self.tempTypeSegementedControl],
            @[@"Display Current Location", self.locationOnSwitch],
            @[@"Notifications", self.notificationsOnSwitch],
            @[@"Learn From Me", self.learningOnSwitch],
            @[@"", self.resetButton]
    ],
        @"Locations":@[],
        @"AddLocation":@[@"Add more locations..."]
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationUI];
    [self.user getLocationsArrayInBackgroundWithBlock:^(NSMutableArray *locations, NSError *error) {
        if (locations) {
            [sectionsDict setValue:locations forKey:@"Locations"];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tooHotTextField resignFirstResponder];
    [self.tooColdTextField resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*--------------------CONFIGURING UI METHODS--------------------*/

- (void) initalizePreferenceControls {
    // Save Button
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onTapSave:)];
    
    // Tap Gesture
    self.screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    self.screenTap.enabled = NO;
    self.screenTap.cancelsTouchesInView = NO;
    
    // Too Hot Temperature Text Field
    self.tooHotTextField = [[UITextField alloc] init];
    self.tooHotTextField.delegate = self;
    self.tooHotTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.tooHotTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.tooHotTextField.widthAnchor constraintEqualToConstant:self.view.frame.size.width/5].active = YES;
    self.tooHotTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tooHotTextField addTarget: self action: @selector(onEditedHot:) forControlEvents: UIControlEventEditingChanged];

    
    // Too Cold Temperature Text Field
    self.tooColdTextField = [[UITextField alloc] init];
    self.tooColdTextField.delegate = self;
    self.tooColdTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.tooColdTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.tooColdTextField.widthAnchor constraintEqualToConstant:self.view.frame.size.width/5].active = YES;
    self.tooColdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tooColdTextField addTarget: self action: @selector(onEditedCold:) forControlEvents: UIControlEventEditingChanged];
    
    // Temperature Type Control
    self.tempTypeSegementedControl = [[UISegmentedControl alloc] initWithItems:@[@"C", @"F"]];
    self.tempTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tempTypeSegementedControl addTarget: self action: @selector(onSetTempType:) forControlEvents: UIControlEventValueChanged];
    
    // Location on switch
    self.locationOnSwitch = [[UISwitch alloc] init];
    [self.locationOnSwitch addTarget: self action: @selector(onToggleLocation:) forControlEvents: UIControlEventValueChanged];
    
    // Notifications on switch
    self.notificationsOnSwitch = [[UISwitch alloc] init];
    [self.notificationsOnSwitch addTarget: self action: @selector(onToggleNotifications:) forControlEvents: UIControlEventValueChanged];
    
    // Learning on switch
    self.learningOnSwitch = [[UISwitch alloc] init];
    [self.learningOnSwitch addTarget: self action: @selector(onToggleLearning:) forControlEvents: UIControlEventValueChanged];
    
    // Reset to Default Button
    self.resetButton = [[UIButton alloc] init];
    [self.resetButton setTitle:@"Reset to Default Preferences" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resetButton addTarget:self action:@selector(onTapReset:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loadPreferences{
    self.updatePrefDict = [[NSMutableDictionary alloc] init];
    self.tooHotTextField.text = @"";
    self.tooColdTextField.text = @"";
    [self.user getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            double tooHotTemp = [pref.tooHotTemp doubleValue];
            double tooColdTemp = [pref.tooColdTemp doubleValue];
            if ([pref.tempTypeString isEqualToString:@"C"]) {
                tooHotTemp = [self convertTemp:tooHotTemp toType:@"C"];
                tooColdTemp = [self convertTemp:tooColdTemp toType:@"C"];
            }
            self.tooHotTextField.placeholder = [NSString stringWithFormat:@"%0.f", tooHotTemp];
            self.tooColdTextField.placeholder = [NSString stringWithFormat:@"%0.f", tooColdTemp];
            self.tempTypeSegementedControl.selectedSegmentIndex = [pref.tempTypeString isEqualToString:@"F"];
            self.locationOnSwitch.on = pref.locationOn;
            self.notificationsOnSwitch.on = pref.notificationsOn;
            self.learningOnSwitch.on = pref.learningOn;
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void) setNavigationUI {
    // Sets navigation bar title and buttons
    self.navigationController.navigationBar.topItem.titleView = nil;
    self.navigationController.navigationBar.topItem.title = @"Settings";
    self.navigationController.navigationBar.topItem.rightBarButtonItem = self.saveButton;
}

- (void) setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Sets up table view
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView addGestureRecognizer:self.screenTap];
    [self.tableView registerClass:PreferenceTableViewCell.class forCellReuseIdentifier:preferenceCellID];
    [self.tableView registerClass:LocationTableViewCell.class forCellReuseIdentifier:locationCellID];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
}
/*--------------------ACTION METHODS--------------------*/
- (IBAction)onTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)onTapSave:(id)sender {
    [self.tooHotTextField resignFirstResponder];
    [self.tooColdTextField resignFirstResponder];
    
    [self.user updatePreferencesWithDictionary:[NSDictionary dictionaryWithDictionary:self.updatePrefDict] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved preferences!");
            [self loadPreferences];
            [self.settingDelegate updatePreferences:self.user.preferences];
        }
        else {
            NSLog(@"Unsuccessful");
        }
    }];
}

- (IBAction)onEditedHot:(id)sender {
    if (![self.tooHotTextField.text isEqualToString:@""]) {
        NSString *tempType = [self.tempTypeSegementedControl titleForSegmentAtIndex:self.tempTypeSegementedControl.selectedSegmentIndex];
        
        int temp = [self.tooHotTextField.text intValue];
        if ([tempType isEqualToString:@"C"]) temp = [self convertTemp:temp toType:@"F"];
        
        [self.updatePrefDict setObject:[NSNumber numberWithInt:temp] forKey:@"tooHotTemp"];
        NSLog(@"Too Hot Temperature: %@", self.tooHotTextField.text);
    }
    else {
        [self.updatePrefDict removeObjectForKey:@"tooHotTemp"];
    }
}

- (IBAction)onEditedCold:(id)sender {
    if (![self.tooColdTextField.text isEqualToString:@""]) {
        NSString *tempType = [self.tempTypeSegementedControl titleForSegmentAtIndex:self.tempTypeSegementedControl.selectedSegmentIndex];
        
        int temp = [self.tooColdTextField.text intValue];
        if ([tempType isEqualToString:@"C"]) temp = [self convertTemp:temp toType:@"F"];
        [self.updatePrefDict setObject:[NSNumber numberWithInt:temp] forKey:@"tooColdTemp"];
        
        NSLog(@"Too Cold Temperature: %@", self.tooColdTextField.text);
    }
    else {
        [self.updatePrefDict removeObjectForKey:@"tooColdTemp"];
    }
}

- (IBAction)onSetTempType:(id)sender {
    NSString *tempType = [self.tempTypeSegementedControl titleForSegmentAtIndex:self.tempTypeSegementedControl.selectedSegmentIndex];
    [self updateFieldsToTempType:tempType];
    [self.updatePrefDict setObject:tempType forKey:@"tempTypeString"];
}

- (IBAction)onToggleLocation:(id)sender {
    [self.updatePrefDict setObject:[NSNumber numberWithBool:[self.locationOnSwitch isOn]] forKey:@"locationOn"];
}

- (IBAction)onToggleNotifications:(id)sender {
    [self.updatePrefDict setObject:[NSNumber numberWithBool:[self.notificationsOnSwitch isOn]] forKey:@"notificationsOn"];
}

- (IBAction)onToggleLearning:(id)sender {
    [self.updatePrefDict setObject:[NSNumber numberWithBool:[self.learningOnSwitch isOn]] forKey:@"learningOn"];
}

- (IBAction)onTapReset:(id)sender {
    [self presentConfirmActionAlertWithTitle:@"Warning" message:@"You are about to reset all your preferences to the default settings. Do you wish to continue?"
    yesHandler:^(UIAlertAction * _Nonnull action) {
        [self.user saveNewPreferences:Preferences.defaultPreferences withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self loadPreferences];
            }
            else {
                NSLog(@"Error occured: %@", error.localizedDescription);
            }
        }];
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField canResignFirstResponder]) [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.screenTap.enabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.screenTap.enabled = NO;
}

- (void) presentConfirmActionAlertWithTitle:(NSString *)title message:(NSString *)message yesHandler:(void(^)(UIAlertAction * _Nonnull action))yesHandler completion:(void(^)(void))completion{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:yesHandler];
    [alert addAction:yesAction];
    
    [self presentViewController:alert animated:YES completion:completion];
}

/*-----------------TABLE VIEW DELEGATE METHODS-----------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) return @"";
    return sectionsArray[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContent = sectionsDict[sectionsArray[section]];
    return sectionContent.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *items = sectionsDict[sectionsArray[indexPath.section]];
    
    if (indexPath.section == [sectionsArray indexOfObject:@"Preferences"]) {
        // preferences cell
        PreferenceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:preferenceCellID forIndexPath:indexPath];
        if (!cell) {
            cell = [[PreferenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:preferenceCellID];
        }
        cell.preferenceArray = items[indexPath.row];
        return cell;
    }
    else if (indexPath.section == [sectionsArray indexOfObject:@"Locations"]){
        LocationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:locationCellID forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCellID];
        }
        
        cell.location = items[indexPath.row];
        return cell;
    }
    else if (indexPath.section == [sectionsArray indexOfObject:@"AddLocation"]) return [self makeTextCellWithMessage:@"Add more locations..."];
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        LocationDetailsViewController *locationDetailVC = [[LocationDetailsViewController alloc] init];
        NSArray *locations = sectionsDict[sectionsArray[indexPath.section]];
        locationDetailVC.location = locations[indexPath.row];
        locationDetailVC.saveNewLocation = NO;
        [self.navigationController pushViewController:locationDetailVC animated:YES];
    }
    else if (indexPath.section == 2) {
        LocationPickerViewController *locationPickerVC = [[LocationPickerViewController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:locationPickerVC] animated:YES completion:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *) makeTextCellWithMessage:(NSString *)message {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:22];
    [messageLabel sizeToFit];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cell.contentView addSubview:messageLabel];
    
    [messageLabel.centerXAnchor constraintEqualToAnchor:cell.contentView.centerXAnchor].active = YES;
    [messageLabel.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor].active = YES;
    
    return cell;
}

/*-----------------C TO F AND VICE VERSA-----------------*/
// update number displayed in text fields
- (void) updateFieldsToTempType:(NSString *)type{
    if ([self.tooHotTextField.text isEqualToString:@""]) {
        int hotValue = [self.tooHotTextField.placeholder intValue];
        self.tooHotTextField.placeholder = [NSString stringWithFormat:@"%0.f", [self convertTemp:hotValue toType:type]];
    }
    else {
        int hotValue = [self.tooHotTextField.text intValue];
        self.tooHotTextField.text = [NSString stringWithFormat:@"%0.f", [self convertTemp:hotValue toType:type]];
    }
    
    if ([self.tooColdTextField.text isEqualToString:@""]) {
        int coldValue = [self.tooColdTextField.placeholder intValue];
        self.tooColdTextField.placeholder = [NSString stringWithFormat:@"%0.f", [self convertTemp:coldValue toType:type]];
    }
    else {
        int coldValue = [self.tooColdTextField.text intValue];
        self.tooColdTextField.text = [NSString stringWithFormat:@"%0.f", [self convertTemp:coldValue toType:type]];
    }
}

// convert temp to given temperature type (if not given C or F returns infinity)
- (double) convertTemp:(int)temp toType:(NSString *)type {
    if ([type isEqualToString:@"C"]) {
        return ((temp-32)*5.0/9.0);
    }
    else if ([type isEqualToString:@"F"]) {
        return ((temp*9.0/5.0)+32);
    }
    return INFINITY;
}

@end
