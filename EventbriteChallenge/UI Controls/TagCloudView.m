//
//  TagCloudView.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "TagCloudView.h"
#import "UIImage+PDF.h"
#import "TagView.h"
#import "CloudView.h"

@interface TagCloudView()

@property (nonatomic) NSTimer * animationTimer;
@property (nonatomic, strong) NSMutableSet * knownFlyingObjects;
@property (nonatomic) BOOL locked;
@property (nonatomic) float targetSpeedInt;
@property (nonatomic) float rate;
@property (nonatomic) float random;

@end


@implementation TagCloudView

-(void)setTargetSpeed:(float)targetSpeed rate:(float)rate {
    self.targetSpeedInt = targetSpeed;
    self.rate = rate;
}

-(void)addFlyingObject:(UIView<FlyingObject> *)object {
    @synchronized (self.knownFlyingObjects) {
        [self.knownFlyingObjects addObject:object];
    }
    [self insertSubview:object atIndex:object.z];
}

-(void)removeFlyingObject:(UIView<FlyingObject> *)object {
    @synchronized (self.knownFlyingObjects) {
        [self.knownFlyingObjects removeObject:object];
    }
    [object removeFromSuperview];
}

-(void)removeAll {
    @synchronized (self.knownFlyingObjects) {
        [self.knownFlyingObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.knownFlyingObjects removeAllObjects];
    }
}

-(void)startTimer {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:CLOUD_ANIMATION_DURATION target:self selector:@selector(animationTimerFire) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(windTimerFire) userInfo:nil repeats:YES];
}

-(void)windTimerFire {
    self.windSpeed += (self.targetSpeedInt - self.windSpeed) * MAX(self.rate, 1./8.);
    self.random /= 2;
    int dWind = arc4random_uniform(4)-2;
    self.windSpeed += dWind;
    float dDir = (arc4random_uniform(10)-5.)/10.;
    self.windDirection += dDir;
}

-(void)animationTimerFire {
    if (self.locked) { return; }
    CGRect bounds = self.bounds;
    @synchronized (self.knownFlyingObjects) {
        [self.knownFlyingObjects enumerateObjectsUsingBlock:^(UIView<FlyingObject> * obj, BOOL *stop) {
            CGRect frame = obj.frame;
            float accident = (arc4random_uniform(10) - 5.)/30. + 1;
            float wd = self.windDirection + obj.individualDirection * self.random;
            CGFloat dx = 1/obj.z * accident * self.windSpeed * cos(wd);
            CGFloat dy = 1/obj.z * accident * self.windSpeed * sin(wd);
            BOOL animate = YES;
            frame = CGRectOffset(frame, dx, dy);
            if (CGRectGetMinX(frame) >= bounds.size.width && dx > 0) {
                frame.origin.x = -frame.size.width;
                animate = NO;
            }
            if (CGRectGetMaxX(frame) <= 0 && dx < 0) {
                frame.origin.x = bounds.size.width + frame.size.width;
                animate = NO;
            }
            if (CGRectGetMinY(frame) >= bounds.size.height && dy > 0) {
                frame.origin.y = -frame.size.height;
                animate = NO;
            }
            if (CGRectGetMaxY(frame) <= 0 && dy < 0) {
                frame.origin.y = bounds.size.height + frame.size.height;
                animate = NO;
            }
            if (animate) {
                [UIView animateWithDuration:CLOUD_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                    obj.frame = frame;
                } completion:^(BOOL finished){}];
            } else {
                obj.frame = frame;
            }
        }];
    }
}

-(void)performInit {
    self.windDirection = M_PI_4 / 2;
    self.windSpeed = 15.5;
    self.knownFlyingObjects = [NSMutableSet new];
    [self startTimer];
}

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self performInit];
    }
    return self;
}

-(void)awakeFromNib {
    [self performInit];
}


-(void)lockDown {
    self.locked = YES;
    // let's cancel animations
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         @synchronized (self.knownFlyingObjects) {
                             [self.knownFlyingObjects enumerateObjectsUsingBlock:^(UIView* obj, BOOL *stop) {
                                 obj.frame = ((CALayer *)obj.layer.presentationLayer).frame;
                             }];
                         }
                     }
                     completion:^(BOOL finished){}
     ];
}

-(void)runAway {
    for (UIView<FlyingObject> * fo in self.knownFlyingObjects) {
        fo.individualDirection = (arc4random_uniform(2) - 1) * M_PI;
    }
    self.random = 3.;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTargetSpeed:0. rate:.3];
}

-(void)releaseLock {
    self.locked = NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self releaseLock];
}


-(void)dealloc {
    [self.animationTimer invalidate]; self.animationTimer = nil;
}

@end
