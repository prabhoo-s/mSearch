//
//  Track.m
//  mSearch
//
//  Created by Prabhu.S on 21/02/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "Track.h"

@implementation Track

// Init the object with an information from a dictionary

- (id)initWithJSONDictionary:(NSDictionary *)dictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _trackName = [dictionary objectForKey:@"trackName"];
        _artistName = [dictionary objectForKey:@"artistName"];
        _albumName = [dictionary objectForKey:@"collectionName"];
        _albumImageUrl = [dictionary objectForKey:@"artworkUrl100"];
    }
    
    return self;
}

@end
