//
//  SearchItemTableViewCell.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "SearchItemTableViewCell.h"

@implementation SearchItemTableViewCell

#pragma mark Initializers

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark Constraints

- (void)redraw {
    self.trackName.text = self.trackItem.trackName;
    self.artistName.text = self.trackItem.artistName;
    self.albumName.text = self.trackItem.albumName;
    
    // activitiy indicator before loading the actual image from url
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.albumImage addSubview:activityIndicator];
    [activityIndicator startAnimating];
    CGSize boundsSize = self.albumImage.bounds.size;
    CGRect frameToCenter = activityIndicator.frame;
    //horizontal
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    //vertical
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

    //center the activity indicator
    activityIndicator.frame = frameToCenter;
    __weak typeof(self) weakSelf = self;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *dataFromUrl = nil;
        dataFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.trackItem.albumImageUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.albumImage.image = [UIImage imageWithData:dataFromUrl];
            [activityIndicator removeFromSuperview];
        });
    });
}

@end
