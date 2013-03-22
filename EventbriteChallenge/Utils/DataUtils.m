//
//  DataUtils.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils

+(NSArray*)tagsFromEvent:(Event*)event {
    NSCharacterSet * breakers = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    if (event.tags.length) {
        return [event.tags componentsSeparatedByCharactersInSet:breakers];
    } else {
        NSMutableArray * cats = [[event.category componentsSeparatedByCharactersInSet:breakers ] mutableCopy];
        [cats addObject:event.venue.name];
        [cats addObject:event.venue.city];
        return cats;
    }
}

+(NSDictionary*)groupedDictionaryOfEvents:(NSArray*)events {
    // Of course, real implementation will have CoreData store and this will be done as SQL query
    NSMutableDictionary * ret = [NSMutableDictionary new];
    [events enumerateObjectsUsingBlock:^(Event * event, NSUInteger idx, BOOL *stop) {
        for (NSString * tag in [self tagsFromEvent:event]) {
            NSMutableSet * eventsForTag = [ret objectForKey:tag];
            if (!eventsForTag) {
                eventsForTag = [NSMutableSet new];
                [ret setObject:eventsForTag forKey:tag];
            }
            [eventsForTag addObject:event];
        }
    }];
    return ret;
}


@end
