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
static UIAcceleration * __last;

static BOOL shake(UIAcceleration* last, UIAcceleration* current, double threshold) {
	double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
	return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

-(void)startTracking {
    if (!__mmgr) {
        __mmgr = [CMMotionManager new];
    }
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [__mmgr startDeviceMotionUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (motion.attitude) {
            float p = motion.attitude.pitch - M_PI_4;
            float r = motion.attitude.roll;
            float a = atanf(p / r);
            if (r < 0) { a += M_PI; }
            float speed = sqrtf(p*p+r*r) * 100;
            self.tagView.windDirection = a;
            [self.tagView setTargetSpeed:speed rate:.5];
        }
    }];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (shake(__last, acceleration, .9)) {
        [self.tagView runAway];
    }
}

-(void)stopTracking {
    [__mmgr stopDeviceMotionUpdates];
}

@end
