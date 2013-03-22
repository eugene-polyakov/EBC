//
//  AppContext.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/19/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "AppContext.h"
#import <RestKit/RestKit.h>
#import "ModelMapping.h"
#import "KeyUtils.h"

static NSString * const keyPart2 = @"712LL4";// obfuscated @"IOL22J";
static NSString * const keyPart1 = @"C2XEX";
static NSString * const keyPart3 = @"PUE2DYQ";

static NSString * apiKey;

@implementation AppContext

+(AppContext*)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self == [super init]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        NSURL *baseURL = [NSURL URLWithString:@"https://www.eventbrite.com"];

        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

        RKObjectMapping *mapping = [ModelMapping eventMapping];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/json/event_get" keyPath:@"event" statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:responseDescriptor];

        RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:[ModelMapping eventMapping] pathPattern:@"/json/event_search" keyPath:@"events.event" statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:responseDescriptor2];

        for (NSString * ff in [UIFont familyNames]) {
            NSLog(@"%@", ff);
            for (NSString * fn in [UIFont fontNamesForFamilyName:ff]) {
                NSLog(@"--%@", fn);
            }
        }
    }
    return self;
}

-(NSString*)apiKey {
    if (!apiKey) {
        // Not realy an encryption, just some protection from casual hackers looking for strings
        apiKey = [[keyPart1 stringByAppendingString:[KeyUtils obfuscate:keyPart2 withKey:@"~~"]] stringByAppendingString:keyPart3];
    }
    return apiKey;
}

-(NSMutableDictionary*)parametersDictionaryWithAPIKey {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:[self apiKey], @"app_key", nil];
}

@end
