//
//  SearchScreenTableViewController.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "SearchScreenTableViewController.h"

#import "Track.h"
#import "SearchItemTableViewCell.h"
#import "TrackDetailsPageViewController.h"
#import "Common.h"

#define DELAY_TIME 1

@interface SearchScreenTableViewController () <UISearchBarDelegate> {
    NSTimer *searchDelayer;
}

@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SearchScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize the array
    self.searchResult = [NSMutableArray array];
    
    //view controller title
    self.title = @"Search Tracks";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (self.searchResult.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
       self.tableView.backgroundView   = nil;
    }
    else {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text             = @"Your search results will appear here.";
        noDataLabel.textColor        = [UIColor lightGrayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
        self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItemTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[SearchItemTableViewCell reuseIdentifier]];
    
    if (!cell) {
        [self.tableView registerNib:[UINib nibWithNibName:@"TrackCell" bundle:nil]
             forCellReuseIdentifier:[SearchItemTableViewCell reuseIdentifier]];
        cell = [self.tableView dequeueReusableCellWithIdentifier:[SearchItemTableViewCell reuseIdentifier]];
    }
    // setting data source
    cell.trackItem = self.searchResult[indexPath.row];
    [cell redraw];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView endEditing:true];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (storyboard) {
        TrackDetailsPageViewController *detailsViewController =
            (TrackDetailsPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ID_TRACK_PAGE_VC"];
        if (detailsViewController) {
            detailsViewController.trackItems = self.searchResult;
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            detailsViewController.selecteTaskIndex = path.row;
            [self.navigationController pushViewController:detailsViewController animated:true];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:true];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Cancel any existing timer whenever the text changes
    [searchDelayer invalidate], searchDelayer=nil;

    //user has clicked on clear X
    if (searchText.length == 0) {
        [self stopActivityIndicator];
    }
    else {
        [self startActivityIndicator];
        // Create and schedule a new one
        searchDelayer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                         target:self
                                                       selector:@selector(performSearch:)
                                                       userInfo:searchText
                                                        repeats:NO];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {   
    [self performSelector:@selector(callWebService:) withObject:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)performSearch:(NSTimer *)timer {
    assert(timer == searchDelayer);
    [self callWebService:searchDelayer.userInfo];
    // the timer is about to release and dealloc itself
    searchDelayer = nil;
}

#pragma mark - Web Service

- (void)callWebService:(NSString *)searchString {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlWithQuery = [NSString stringWithFormat:TRACKS_LOOKUP_URL, searchString];

    SearchScreenTableViewController* __weak weakSelf = self;
    
    // NSURLSessionDataTask API
    self.dataTask =
        [session dataTaskWithURL:[NSURL URLWithString:urlWithQuery]
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        SearchScreenTableViewController* strongSelf = weakSelf;

        NSDictionary *tracksData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else {
            //Flush out old results if any
            [strongSelf.searchResult removeAllObjects];
            NSArray *array = [tracksData objectForKey:@"results"];
            for (NSDictionary *track in array) {
                Track *trackItem = [[Track alloc] initWithJSONDictionary:track];
                [strongSelf.searchResult addObject:trackItem];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // perform on main
            [strongSelf stopActivityIndicator];
            [strongSelf.tableView reloadData];
        });
    }];

    if (self.dataTask) {
        [self.dataTask resume];
    }
}

#pragma mark - Activity Indicator

- (void)startActivityIndicator {
    if (self.spinner == nil) {
        self.spinner =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    CGRect frame = self.spinner.frame;
    frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2);
    frame.origin.y = (self.view.frame.size.height / 3 - frame.size.height / 2);
    self.spinner.frame = frame;
    [self.tableView addSubview:self.spinner];
    [self.spinner startAnimating];
}

- (void)stopActivityIndicator {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

@end
