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

#define HEADER_REASUABLE_IDENTIFIER @"HEADER_REASUABLE_IDENTIFIER"
#define TABLE_VIEW_SECTION_HEADER_COLOR [UIColor colorWithRed:113.0f/225.0f green:193.0f/225.0f blue:147.0f/225.0f alpha:1.0f]

@interface TrackDetailsTableViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation TrackDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HEADER_REASUABLE_IDENTIFIER];
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
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ID_ALBUM_COVER_CELL";
        AlbumCoverCell *albumCoverCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // load the image here
        [albumCoverCell setImageWithName:self.trackItem.albumImageUrl];
        cell = albumCoverCell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"ID_TRACK_NAME_CELL";
        TrackNameCell *trackNameCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        trackNameCell.trackName.text = self.trackItem.trackName;
        cell = trackNameCell;
    }
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"ID_ARTIST_CELL";
        ArtistNamesCell *artistCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        artistCell.artistName.text = self.trackItem.artistName;
        cell = artistCell;
    }
    else if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"ID_ALBUM_CELL";
        AlbumNameCell *albumNameCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        albumNameCell.albumName.text = self.trackItem.albumName;
        cell = albumNameCell;
    }
    else if (indexPath.section == 4) {
        static NSString *CellIdentifier = @"ID_LYRICS_CELL";
        LyricsCell *lyricsCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        lyricsCell.albumName.text = [self startFetchingLyrics];
        cell = lyricsCell;
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

@end
