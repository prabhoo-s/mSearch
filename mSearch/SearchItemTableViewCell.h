//
//  SearchItemTableViewCell.h
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface SearchItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *albumName;

@property (strong, nonatomic)Track *trackItem;

- (void)redraw;

@end
