//
//  EventbriteChallengeTests.m
//  EventbriteChallengeTests
//
//  Created by Eugene Polyakov on 3/18/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "EventbriteChallengeTests.h"
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "Model.h"
#import "ModelMapping.h"
#import <SenTestingKit/SenTestingKit.h>


static NSString * apiKey;
static NSString * const API_KEY_KEY = @"EventBriteAPIKey";

@implementation EventbriteChallengeTests

+(NSString*)apiKey {
    if (!apiKey) {
        apiKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:API_KEY_KEY];
    }
    return apiKey;
}

- (void)setUp
{
    [super setUp];
    NSBundle *testTargetBundle = [NSBundle bundleForClass:self.class];
    [RKTestFixture setFixtureBundle:testTargetBundle];
}


-(void)testEventMapping {
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"singleEvent.json"];
	RKMappingTest *test = [RKMappingTest testForMapping:[ModelMapping eventMapping] sourceObject:parsedJSON destinationObject:nil];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"timezone" destinationKeyPath:@"timezone"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"num_attendee_rows" destinationKeyPath:@"numAttendeeRows"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"id" destinationKeyPath:@"eventId"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"venue" destinationKeyPath:@"venue"]];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"venue" destinationKeyPath:@"venue" evaluationBlock:^BOOL(RKPropertyMappingTestExpectation *expectation, RKPropertyMapping *mapping, id mappedValue, NSError **error) {
        NSString *title = [(Venue*)mappedValue name];
        return [title rangeOfString:@"Venue will be added"].length > 0;
    }]];

	STAssertTrue([test evaluate], @"Fields are not mapped properly");
}

- (void)testEventOperation
{
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ModelMapping eventMapping] pathPattern:nil keyPath:@"event" statusCodes:[NSIndexSet indexSetWithIndex:200]];
                                                
                                                
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbrite.com/json/event_get?app_key=%@&id=4928107101", [EventbriteChallengeTests apiKey]]];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
	[requestOperation start];
	[requestOperation waitUntilFinished];
	STAssertTrue([[requestOperation.mappingResult array] count] == 1, @"Expected to load one event");
}

-(void)testMultiEventOperation {
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ModelMapping eventMapping] pathPattern:nil keyPath:@"events.event" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    	NSURL *URL = [NSURL URLWithString:[@"https://www.eventbrite.com/json/event_search?app_key=" stringByAppendingString:[EventbriteChallengeTests apiKey]]];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
	[requestOperation start];
	[requestOperation waitUntilFinished];
	STAssertTrue(requestOperation.mappingResult.array.count == 11, @"Expected to load eleven events");
    
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

@end
