//
//  TagView.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "TagView.h"

@interface TagView()

@property (nonatomic) CGFloat z;
@property (nonatomic) CGSize originalSize;
@property (nonatomic) float individualDirection;

@end

@implementation TagView

-(NSString*)description {
    return [self.tagName stringByAppendingString:[super description]];
}

@end
