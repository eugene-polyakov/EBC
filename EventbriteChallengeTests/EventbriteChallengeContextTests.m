//
//  EventbriteChallengeContextTests.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "EventbriteChallengeContextTests.h"
#import "AppContext.h"
#import <RestKit/RestKit.h>
#import "EventbriteChallengeTests.h"

@implementation EventbriteChallengeContextTests

-(void)setUp {
    [AppContext sharedInstance];
    
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

}

-(void)testLoadMultiple {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    RKObjectManager * manager = [RKObjectManager sharedManager];

    [manager getObjectsAtPath:[@"/json/event_search?app_key=" stringByAppendingString:[EventbriteChallengeTests apiKey]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"It Worked: %@", [mappingResult array]);
         dispatch_semaphore_signal(semaphore);
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"It Failed: %@", error);
         dispatch_semaphore_signal(semaphore);
         STAssertTrue(NO, @"Operation failed with error - %@", error);
     }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
