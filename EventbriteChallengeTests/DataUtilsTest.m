//
//  DataUtilsTest.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "DataUtilsTest.h"
#import "Model.h"
#import "DataUtils.h"

@implementation DataUtilsTest

-(void)testEventGrouping {
    Venue * venue = [Venue new];
    venue.city = @"City";
    venue.name = @"Venue";
    Event * event1 = [Event new];
    event1.venue = venue;
    event1.category = @"Cat1";
    event1.title = @"Event1";
    Event * event2 = [Event new];
    event2.tags = @"City, Venue, Tag1, Tag2, Cat1";
    event2.title = @"Event2";
    STAssertTrue([DataUtils tagsFromEvent:event1].count == 3, @"Wrong tag extraction logic");
    NSDictionary * eventDic = [DataUtils groupedDictionaryOfEvents:[NSArray arrayWithObjects:event1, event2, nil]];
    STAssertTrue([[eventDic objectForKey:@"Cat1"] count] == 2, @"Wrong grouping logic");
    STAssertTrue([[eventDic objectForKey:@"City"] count] == 2, @"Wrong grouping logic");
    STAssertTrue([[eventDic objectForKey:@"Tag1"] count] == 1, @"Wrong grouping logic");
}

@end
