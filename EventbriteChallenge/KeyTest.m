//
//  KeyTest.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "KeyTest.h"
#import "KeyUtils.h"
#import "AppContext.h"
#import "EventbriteChallengeTests.h"

@implementation KeyTest

-(void)testKeyEncryption {
    NSString * key = @"~~";
    NSString * orig = @"IOL22J";
    NSString * enc = [KeyUtils obfuscate:orig withKey:key];
    NSLog(@"%@", enc);
    NSString * dec = [KeyUtils obfuscate:enc withKey:key];
    STAssertEqualObjects(orig, dec, @"Something went wrong");
}

-(void)testAppKey {
    NSString * k = [[AppContext sharedInstance] apiKey];
    STAssertEqualObjects(k, [EventbriteChallengeTests apiKey], @"Keys do not match");
}

@end
