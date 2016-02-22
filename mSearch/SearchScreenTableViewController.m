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

@interface SearchScreenTableViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
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
    static NSString *cellIdentifier = @"ID_SEARCH_RESULTS_ITEM_CELL";
    SearchItemTableViewCell *cell =
        (SearchItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
 
    cell.trackItem = self.searchResult[indexPath.row];
    [cell redraw];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SEGUE_PUSH_VIEW_TRACK"]) {
        TrackDetailsPageViewController *tdViewController = (TrackDetailsPageViewController *)[segue destinationViewController];;
        tdViewController.trackItems = self.searchResult;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        tdViewController.selecteTaskIndex = path.row;
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text  {
        NSString *trimDot = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([trimDot isEqualToString:@"."]) {
            return YES;
        }

//    if(If Interrupted){
//        [connection cancel];
//    }
//    NSString *appendStr;
//       if([text length] == 0)
//    {
//        NSRange rangemak = NSMakeRange(0, [searchbar.text length]-1);
//        appendStr = [searchbar.text substringWithRange:rangemak];
//    }
//    else
//    {
//        appendStr = [NSString stringWithFormat:@"%@%@",searchbar.text,text];
//    }
    [self performSelector:@selector(callWebService:) withObject:@""];

    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [self performSelector:@selector(callWebService:) withObject:searchBar.text];
//    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self stopActivityIndicator];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {   
    [self performSelector:@selector(callWebService:) withObject:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)callWebService:(NSString*)searchString {
    [self startActivityIndicator];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlWithQuery = [NSString stringWithFormat:TRACKS_LOOKUP_URL, searchString];
    NSURLSessionDataTask *dataTask =
        [session dataTaskWithURL:[NSURL URLWithString:urlWithQuery]
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *tracksData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (error) {
            NSLog(@"JSON data error: %@", error);
            return;
        }
        else {
//            NSLog(@"TRACKS:%@", tracksData);
            //Flush out old results if any
            [self.searchResult removeAllObjects];
            NSArray *array = [tracksData objectForKey:@"results"];
            for (NSDictionary *track in array) {
                Track *trackItem = [[Track alloc] initWithJSONDictionary:track];
                [self.searchResult addObject:trackItem];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // perform on main
            [self stopActivityIndicator];
            [self.tableView reloadData];
        });
    }];

    [dataTask resume];
}

- (void)startActivityIndicator {
    self.spinner =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = self.spinner.frame;
    frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2);
    frame.origin.y = (self.view.frame.size.height / 2.5f - frame.size.height / 2);
    self.spinner.frame = frame;
    [self.tableView.backgroundView addSubview:self.spinner];
    [self.spinner startAnimating];
}

- (void)stopActivityIndicator {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

@end
