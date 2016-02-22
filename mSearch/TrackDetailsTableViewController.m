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
@property (nonatomic, copy) NSString *lyricContent;
@property (nonatomic, assign) CGFloat textViewCellHeight;
@end

@implementation TrackDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HEADER_REASUABLE_IDENTIFIER];
    
    //default Lyrics
    
    self.lyricContent = @"Fetching Lyrics...";
    self.textViewCellHeight = 44.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //fetch lyrics
    [self startFetchingSongLyrics:self.trackItem];
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
    if (indexPath.section == SECTION_ALBUM_COVER_CELL) {
        // height of album cover is 100px
        height = 100.0f;
    }
    else if (indexPath.section == SECTION_LYRICS_CELL) {
        //cell height calculated dynamically
        height = self.textViewCellHeight;
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
        lyricsCell.lyrics.text = self.lyricContent;
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

//    NSLog(@"Lyrics URL:%@", url);

    NSURLSession *session = [NSURLSession sharedSession];
    TrackDetailsTableViewController* __weak weakSelf = self;
    
    NSURLSessionDataTask *dataTask =
        [session dataTaskWithURL:[NSURL URLWithString:url]
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        TrackDetailsTableViewController* strongSelf = weakSelf;
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", responseString);
        if (error) {
            NSLog(@"text data error: %@", error);
            return;
        }
        else {
            responseString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //string is not whitespace
            if ([[responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
                strongSelf.lyricContent = responseString;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf) {
                // perform on main
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_LYRICS_CELL];
                LyricsCell *cell = (LyricsCell *)[strongSelf.tableView cellForRowAtIndexPath:indexPath];
                // calculate cell height
                strongSelf.textViewCellHeight = [strongSelf textViewHeight:responseString andWidth:cell.lyrics.contentSize.width];

                // reload the lyrics cell
                [strongSelf.tableView beginUpdates];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView endUpdates];
            }
        });
    }];

    [dataTask resume];
}

- (CGFloat)textViewHeight:(NSString *)text andWidth:(CGFloat)width {
    if (text.length < 20  ) {
        // return default height,
        return 44.0f;
    }

    UITextView *calculationView = [[UITextView alloc] init];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:text
                                        attributes:@{NSFontAttributeName: font}];
    [calculationView setAttributedText:attributedText];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    return size.height;
}

@end
