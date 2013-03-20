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
        RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        NSURL *baseURL = [NSURL URLWithString:@"https://eventbrite.com"];

        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

        RKObjectMapping *mapping = [ModelMapping eventMapping];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                           pathPattern:@"/json/event_get"
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [objectManager addResponseDescriptor:responseDescriptor];

    }
    return self;
}

@end
