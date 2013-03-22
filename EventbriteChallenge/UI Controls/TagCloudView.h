//
//  TagCloudView.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyingObject.h"

#define CLOUD_ANIMATION_DURATION .2

@interface TagCloudView : UIView

@property (nonatomic) float windDirection;
@property (nonatomic) float windSpeed;

-(void)addFlyingObject:(UIView<FlyingObject>*)object;
-(void)removeFlyingObject:(UIView<FlyingObject>*)object;
-(void)removeAll;

-(void)lockDown;
-(void)releaseLock;

-(void)setTargetSpeed:(float)targetSpeed rate:(float)rate;
-(void)runAway;

@end
