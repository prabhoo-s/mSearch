//
//  TrackDetailsTableViewController.h
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface TrackDetailsTableViewController : UITableViewController

@property (strong, nonatomic)Track *trackItem;

#pragma mark - Item controller information
@property (nonatomic) NSUInteger itemIndex;

@end
