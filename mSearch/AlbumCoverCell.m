//
//  AlbumCoverCell.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "AlbumCoverCell.h"

@interface AlbumCoverCell()
@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
@end

@implementation AlbumCoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageWithName:(NSString *)imageURI {
    AlbumCoverCell* __weak weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AlbumCoverCell* strongSelf = weakSelf;
        NSData *dataFromUrl = nil;
        dataFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURI]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.imageView
                              duration:5.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                strongSelf.albumCover.image = [UIImage imageWithData:dataFromUrl];
                            } completion:nil];
        });
    });
}

@end
