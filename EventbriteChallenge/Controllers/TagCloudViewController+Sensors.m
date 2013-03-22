//
//  TagCloudViewController+Sensors.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "TagCloudViewController.h"
#import <CoreMotion/CoreMotion.h>

@implementation TagCloudViewController (Sensors)

static CMMotionManager * __mmgr;

-(void)startTracking {
    if (!__mmgr) {
        __mmgr = [CMMotionManager new];
    }
    [__mmgr startDeviceMotionUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        NSLog(@"%f", motion.attitude.roll);
    }];
}

-(void)stopTracking {
    [__mmgr stopDeviceMotionUpdates];
}

@end
