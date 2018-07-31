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

/* Location Cell Property (didn't use custom cell) */
@property (strong, nonatomic) UILabel *locationCellLabel;

@end

@implementation LocationPickerViewController

static BOOL loadingData;

- (void)viewDidLoad {
    [super viewDidLoad];
    loadingData = NO;
    self.searchLocationArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didTapCancel)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"SearhResultCell"];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqual: @""]) {
        [self.searchLocationArray removeAllObjects];
        [self.tableView reloadData];
    }
    else if(!loadingData){
        [self searchUsingQuery:searchText];
    }
}

- (void) searchUsingQuery:(NSString *)query {
    loadingData = YES;
    [[GeoAPIManager shared] searchForLocationByName:query withOffset:0 withCompletion:^(NSDictionary *data, NSError *error) {
        if (data) {
            [self.searchLocationArray removeAllObjects];
            NSArray *geonamesArray = data[@"geonames"];
            for (NSDictionary *geoname in geonamesArray) {
                Location *loc = [Location initWithSearchDictionary:geoname];
                [self.searchLocationArray addObject:loc];
            }
            if (geonamesArray.count == 0) {
                Location *loc = [[Location alloc] init];
//                loc.fullPlaceName = [NSString stringWithFormat:@"No locations found", self.searchBar.text];
                loc.fullPlaceName = @"No locations found";
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

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    if([self.searchBar.text isEqual: @""]) [self.searchLocationArray removeAllObjects];
//    else if(!loadingData){
//        loadingData = YES;
//        [[GeoAPIManager shared] searchForLocationByName:self.searchBar.text withOffset:0 withCompletion:^(NSDictionary *data, NSError *error) {
//            if (data) {
//                NSArray *geonamesArray = data[@"geonames"];
//                for (NSDictionary *geoname in geonamesArray) {
//                    Location *loc = [Location initWithSearchDictionary:geoname];
//                    [self.searchLocationArray addObject:loc];
//                }
//                if (geonamesArray.count == 0) {
//                    Location *loc = [[Location alloc] init];
//                    loc.fullPlaceName = [NSString stringWithFormat:@"No locations found for %@", self.searchBar.text];
//                    [self.searchLocationArray addObject:loc];
//                }
//                loadingData = NO;
//                [self.tableView reloadData];
//            }
//            else {
//                NSLog(@"%@", error.localizedDescription);
//            }
//        }];
//    }
//}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self.searchLocationArray removeAllObjects];
//    [self.searchBar resignFirstResponder];
//    [self.tableView reloadData];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self.searchLocationArray removeAllObjects];
    [self.searchBar resignFirstResponder];
    [self searchUsingQuery:searchBar.text];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchLocationArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Location *loc = self.searchLocationArray[indexPath.row];
    if (![loc.fullPlaceName isEqualToString:@"No locations found"]) {
        LocationDetailsViewController *locDetailVC = [[LocationDetailsViewController alloc] init];
        locDetailVC.location = self.searchLocationArray[indexPath.row];
        locDetailVC.saveNewLocation = YES;
        [self.navigationController pushViewController:locDetailVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) didTapCancel {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
