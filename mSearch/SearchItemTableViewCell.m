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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.albumImage.layer.borderWidth = 1;
    self.albumImage.layer.cornerRadius = 8;
    self.albumImage.layer.masksToBounds = true;
    self.albumImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.albumImage.image = [UIImage imageNamed:@"albumcover"];
    self.trackName.text = @"Track Name";
    self.artistName.text = @"Artist Name";
    self.albumName.text = @"Album Name";
    [self setupConstraints];
}

+ (NSString *)reuseIdentifier {    
    return @"ID_TRACK_CELL";
}

#pragma mark Constraints

- (void)setupConstraints {
    // Album thumb image
    self.albumImage.translatesAutoresizingMaskIntoConstraints = false;
    //Aspect ratio and height
    [self.albumImage addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.albumImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0],
                                    [NSLayoutConstraint constraintWithItem:self.albumImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.albumImage attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],
                                  ]];
    //top and left
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.albumImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0],
                           [NSLayoutConstraint constraintWithItem:self.albumImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0],
                           ]];

    // Track Name
    self.trackName.translatesAutoresizingMaskIntoConstraints = false;
    // Height
    [self.trackName addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.trackName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0],
                                  ]];
    // top, left, right
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.trackName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0],
                           [NSLayoutConstraint constraintWithItem:self.trackName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.albumImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0],
                           [NSLayoutConstraint constraintWithItem:self.trackName attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0.0],
                           ]];

    // Artist Name
    self.artistName.translatesAutoresizingMaskIntoConstraints = false;
     // Height
    [self.artistName addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.artistName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0],
                                  ]];
    // top, left, right
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.artistName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.trackName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
                           [NSLayoutConstraint constraintWithItem:self.artistName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.albumImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0],
                           [NSLayoutConstraint constraintWithItem:self.artistName attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.albumName attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                           [NSLayoutConstraint constraintWithItem:self.artistName attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0.0],
                           ]];
    
    // Album Name
    self.albumName.translatesAutoresizingMaskIntoConstraints = false;
    // top, left, bottom, right
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.albumName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.artistName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
                           [NSLayoutConstraint constraintWithItem:self.albumName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.albumImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0],
                           [NSLayoutConstraint constraintWithItem:self.albumName attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
                           [NSLayoutConstraint constraintWithItem:self.albumName attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0.0],
                           ]];
}

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
