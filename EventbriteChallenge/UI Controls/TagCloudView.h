//
//  TagCloudView.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyingObject.h"

#define CLOUD_ANIMATION_DURATION .4

@interface TagCloudView : UIView

@property (nonatomic) CGFloat windDirection;
@property (nonatomic) CGFloat windSpeed;

-(void)addFlyingObject:(UIView<FlyingObject>*)object;
-(void)removeFlyingObject:(UIView<FlyingObject>*)object;

-(void)lockDown;
-(void)releaseLock;

@end
