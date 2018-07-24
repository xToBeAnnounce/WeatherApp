//
//  LocationPickerViewController.m
//  WeatherApp
//
//  Created by Jamie Tan on 7/19/18.
//  Copyright © 2018 xToBeAnnounce. All rights reserved.
//

#import "LocationPickerViewController.h"
#import "LocationDetailsViewController.h"
#import "Location.h"
#import "GeoAPIManager.h"

@interface LocationPickerViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *searchLocationArray;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *locationCellLabel;

@end

@implementation LocationPickerViewController

static BOOL loadingData;

- (void)viewDidLoad {
    [super viewDidLoad];
    loadingData = NO;
    self.searchLocationArray = [[NSMutableArray alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + 20, self.view.bounds.size.width, 50)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if([self.searchBar.text isEqual: @""]) [self.searchLocationArray removeAllObjects];
    else if(!loadingData){
        loadingData = YES;
        [[GeoAPIManager shared] searchForLocationByName:self.searchBar.text withOffset:0 withCompletion:^(NSDictionary *data, NSError *error) {
            if (data) {
                NSArray *geonamesArray = data[@"geonames"];
                for (NSDictionary *geoname in geonamesArray) {
                    Location *loc = [Location initWithSearchDictionary:geoname];
                    [self.searchLocationArray addObject:loc];
                }
                loadingData = NO;
                [self.tableView reloadData];
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchLocationArray removeAllObjects];
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchLocationArray removeAllObjects];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCell"];
    Location *location = self.searchLocationArray[indexPath.row];
    [self setSearchCell:cell withLocation:location];
    return cell;
}

-(void)setSearchCell:(UITableViewCell*)cell withLocation:(Location*)location{
    [cell.textLabel setFrame:CGRectMake(50, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.textLabel.text = location.fullPlaceName;
    [cell.textLabel sizeToFit];
    //[cell.contentView addSubview:self.locationCellLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchLocationArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationDetailsViewController *locDetailVC = [[LocationDetailsViewController alloc] init];
    locDetailVC.location = self.searchLocationArray[indexPath.row];
    UINavigationController *locationDetailNVC = [[UINavigationController alloc] initWithRootViewController:locDetailVC];
    [self.navigationController presentViewController:locationDetailNVC animated:YES completion:nil];
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
