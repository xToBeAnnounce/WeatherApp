//
//  SettingsViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/17/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"
#import "PreferenceTableViewCell.h"

// TODO: Put HUD on the screen while preferences are loading

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableDictionary *updatePrefDict;

@property (strong, nonatomic) UITextField *tooHotTextField;
@property (strong, nonatomic) UITextField *tooColdTextField;
@property (strong, nonatomic) UISegmentedControl *tempTypeSegementedControl;
@property (strong, nonatomic) UISwitch *locationOnSwitch;
@property (strong, nonatomic) UISwitch *notificationsOnSwitch;
@property (strong, nonatomic) UIButton *resetButton;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

static NSArray *sectionsArray;
static NSMutableDictionary *sectionsDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Intialize properties
    self.user = User.currentUser;
    [self initalizeInteractiveProperties];
    [self loadPreferences];
    [self setUI];
    
    sectionsArray = @[@"Preferences", @"Locations"];
    sectionsDict = [NSMutableDictionary dictionaryWithDictionary:
  @{
    @"Preferences":@[
            @[@"Hot Temperature", self.tooHotTextField],
            @[@"Cold Temperature", self.tooColdTextField],
            @[@"Temperature Type", self.tempTypeSegementedControl],
            @[@"Current Location", self.locationOnSwitch],
            @[@"Notifications", self.notificationsOnSwitch],
            @[@"", self.resetButton]
    ],
        @"Locations":@[]
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // No explicit autorelease pool needed here.
        // The code runs in background, not strangling
        // the main run loop.
        [sectionsDict setValue:[self.user getLocationsArray] forKey:@"Locations"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Updated sectionsDict");
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPreferences{
    self.updatePrefDict = [[NSMutableDictionary alloc] init];
    self.tooHotTextField.text = @"";
    self.tooColdTextField.text = @"";
    [self.user getUserPreferencesWithBlock:^(Preferences *pref, NSError *error) {
        if (pref) {
            self.tooHotTextField.placeholder = [NSString stringWithFormat:@"%@", pref.tooHotTemp];
            self.tooColdTextField.placeholder = [NSString stringWithFormat:@"%@", pref.tooColdTemp];
            self.tempTypeSegementedControl.selectedSegmentIndex = [pref.tempTypeString isEqualToString:@"F"];
            self.locationOnSwitch.on = pref.locationOn;
            self.notificationsOnSwitch.on = pref.notificationsOn;
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void) initalizeInteractiveProperties {
    // Too Hot Temperature Text Field
    self.tooHotTextField = [[UITextField alloc] init];
    self.tooHotTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.tooHotTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.tooHotTextField.widthAnchor constraintEqualToConstant:self.view.frame.size.width/5].active = YES;
    self.tooHotTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tooHotTextField addTarget: self action: @selector(onEditedHot:) forControlEvents: UIControlEventEditingChanged];
    
    // Too Cold Temperature Text Field
    self.tooColdTextField = [[UITextField alloc] init];
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
    
    // Reset to Default Button
    self.resetButton = [[UIButton alloc] init];
    [self.resetButton setTitle:@"Reset to Default Preferences" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resetButton addTarget:self action:@selector(onTapReset:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIStackView *) makeHStackViewLabeled:(NSString *)text withSwitch:(UISwitch *)labeledSwitch {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [stackView addArrangedSubview:label];
    [stackView addArrangedSubview:labeledSwitch];
    
    return stackView;
}

- (void) setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:screenTap];
    
    // Sets navigation bar titlte and buttons
    self.navigationController.navigationBar.topItem.title = @"Settings";
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelBtn;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = doneBtn;
    
    // Sets up table view
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:PreferenceTableViewCell.class forCellReuseIdentifier:@"PreferenceTableViewCell"];
    
    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
}

// Creating and Filling main stack view
- (void) buildSettingsStackView {
    UIStackView *settingsStackView = [[UIStackView alloc] init];
    
    settingsStackView.axis = UILayoutConstraintAxisVertical;
    settingsStackView.distribution = UIStackViewDistributionFill;
    settingsStackView.alignment = UIStackViewAlignmentCenter;
    settingsStackView.spacing = 8;
    
    
    [settingsStackView addArrangedSubview:[self makeHStackViewFor:self.tooHotTextField withLabel:@"Hot Temperature"]];
    [settingsStackView addArrangedSubview:[self makeHStackViewFor:self.tooColdTextField withLabel:@"Cold Temperature"]];
    [settingsStackView addArrangedSubview:[self makeHStackViewFor:self.tempTypeSegementedControl withLabel:@"Temperature Type"]];
    [settingsStackView addArrangedSubview:[self makeHStackViewFor:self.locationOnSwitch withLabel:@"Location"]];
    [settingsStackView addArrangedSubview:[self makeHStackViewFor:self.notificationsOnSwitch withLabel:@"Notifications"]];
    [settingsStackView addArrangedSubview:self.resetButton];
    
    settingsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [settingsStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8].active = YES;
    [settingsStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:8].active = YES;
    [settingsStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:8].active = YES;
    [settingsStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [settingsStackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    [self.view addSubview:settingsStackView];
}

- (UIStackView *) makeHStackViewFor:(id)labeledTool withLabel:(NSString *)labelText{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    [stackView addArrangedSubview:label];
    [stackView addArrangedSubview:labeledTool];
    
    return stackView;
}

- (IBAction)onTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)onTapDone:(id)sender {
    [self.user updatePreferencesWithDictionary:[NSDictionary dictionaryWithDictionary:self.updatePrefDict] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved preferences!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"Unsuccessful");
        }
    }];
}

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSetTempType:(id)sender {
    NSString *tempType = [self.tempTypeSegementedControl titleForSegmentAtIndex:self.tempTypeSegementedControl.selectedSegmentIndex];
    [self.updatePrefDict setObject:tempType forKey:@"tempTypeString"];
//    NSLog(@"Prefered Temp Type: %@", tempType);
}

- (IBAction)onToggleLocation:(id)sender {
    [self.updatePrefDict setObject:[NSNumber numberWithBool:[self.locationOnSwitch isOn]] forKey:@"locationOn"];
//    NSLog(@"Location On: %d", self.user.preferences.locationOn);
}

- (IBAction)onToggleNotifications:(id)sender {
    [self.updatePrefDict setObject:[NSNumber numberWithBool:[self.notificationsOnSwitch isOn]] forKey:@"notificationsOn"];
//    NSLog(@"Notifications on: %d", self.user.preferences.notificationsOn);
}

- (IBAction)onEditedHot:(id)sender {
    if (![self.tooHotTextField.text isEqualToString:@""]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        [self.updatePrefDict setObject:[formatter numberFromString:self.tooHotTextField.text] forKey:@"tooHotTemp"];
        NSLog(@"Too Hot Temperature: %@", self.tooHotTextField.text);
    }
    else {
        [self.updatePrefDict removeObjectForKey:@"tooHotTemp"];
    }
}

- (IBAction)onEditedCold:(id)sender {
    if (![self.tooColdTextField.text isEqualToString:@""]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        [self.updatePrefDict setObject:[formatter numberFromString:self.tooColdTextField.text] forKey:@"tooColdTemp"];
        NSLog(@"Too Cold Temperature: %@", self.tooColdTextField.text);
    }
    else {
        [self.updatePrefDict removeObjectForKey:@"tooColdTemp"];
    }
}

- (IBAction)onTapReset:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You are about to reset all your preferences to the default settings. Do you wish to continue?" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.user saveNewPreferences:Preferences.defaultPreferences withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self loadPreferences];
            }
            else {
                NSLog(@"Error occured: %@", error.localizedDescription);
            }
        }];
    }];
    [alert addAction:yesAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // preferences cell
        PreferenceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PreferenceTableViewCell" forIndexPath:indexPath];
        cell = [[PreferenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PreferenceTableViewCell"];
        NSArray *prefs = sectionsDict[sectionsArray[indexPath.section]];
        cell.preferenceArray = prefs[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1){
        PreferenceTableViewCell *cell = [[PreferenceTableViewCell alloc] init];
        NSString *name = [NSString stringWithFormat:@"Location %ld", indexPath.row+1];
        [cell.textLabel setText:name];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionsArray[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContent = sectionsDict[sectionsArray[section]];
    return sectionContent.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*-----------------------PANTRY-----------------------*/


@end
