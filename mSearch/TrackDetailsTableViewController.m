//
//  TrackDetailsTableViewController.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "TrackDetailsTableViewController.h"

#import "AlbumCoverCell.h"
#import "TrackNameCell.h"
#import "ArtistNamesCell.h"
#import "AlbumNameCell.h"
#import "LyricsCell.h"
#import "Common.h"

@interface TrackDetailsTableViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation TrackDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HEADER_REASUABLE_IDENTIFIER];
    
    //fetch lyrics
    [self startFetchingSongLyrics:self.trackItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *sectionHeaderView =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER_REASUABLE_IDENTIFIER];
    UILabel *lblSectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 42)];
    lblSectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sectionHeaderView.contentView addSubview:lblSectionHeader];
    [sectionHeaderView.contentView setBackgroundColor:TABLE_VIEW_SECTION_HEADER_COLOR];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 0.0f;
    if (indexPath.section == 0) {
        height = 100.0f;
    }
    else {
        height = 44.0f;
    }

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SECTION_ALBUM_COVER_CELL) {
        static NSString *cellIdentifier = @"ID_ALBUM_COVER_CELL";
        AlbumCoverCell *albumCoverCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        // load the image here
        [albumCoverCell setImageWithName:self.trackItem.albumImageUrl];
        cell = albumCoverCell;
    }
    else if (indexPath.section == SECTION_TRACK_NAME_CELL) {
        static NSString *cellIdentifier = @"ID_TRACK_NAME_CELL";
        TrackNameCell *trackNameCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        trackNameCell.trackName.text = self.trackItem.trackName;
        cell = trackNameCell;
    }
    else if (indexPath.section == SECTION_ARTIST_CELL) {
        static NSString *cellIdentifier = @"ID_ARTIST_CELL";
        ArtistNamesCell *artistCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        artistCell.artistName.text = self.trackItem.artistName;
        cell = artistCell;
    }
    else if (indexPath.section == SECTION_ALBUM_CELL) {
        static NSString *cellIdentifier = @"ID_ALBUM_CELL";
        AlbumNameCell *albumNameCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        albumNameCell.albumName.text = self.trackItem.albumName;
        cell = albumNameCell;
    }
    else if (indexPath.section == SECTION_LYRICS_CELL) {
        static NSString *cellIdentifier = @"ID_LYRICS_CELL";
        LyricsCell *lyricsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = lyricsCell;
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}


- (void)startFetchingSongLyrics:(Track *)trackItem {
    NSString *url =
        [NSString stringWithFormat:TRACK_DETAILS_URL, trackItem.artistName, trackItem.trackName];
    
    _Pragma("clang diagnostic push")
    _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_3) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    _Pragma("clang diagnostic pop")

    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask =
        [session dataTaskWithURL:[NSURL URLWithString:url]
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        if (error) {
            NSLog(@"JSON data error: %@", error);
            return;
        }
        else {
            NSLog(@"LYRICS:%@", responseString);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // perform on main
            // reload the lyrics cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];

            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

        });
    }];

    [dataTask resume];
}

//Counting lines of wrapped text

//- (NSInteger)linesofwrappedtext:(NSString)
//    NSLayoutManager *layoutManager = [textView layoutManager];
//    unsigned numberOfLines, index, numberOfGlyphs = [layoutManager numberOfGlyphs];
//    NSRange lineRange;
//    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
//        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
//                effectiveRange:&lineRange];
//        index = NSMaxRange(lineRange);
//    }
//    return numberOfLines;
//}

@end
