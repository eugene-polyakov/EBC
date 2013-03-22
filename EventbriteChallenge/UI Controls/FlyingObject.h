//
//  FlyingObject.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlyingObject

-(CGFloat)z;
-(void)setZ:(CGFloat)z;
-(CGSize)originalSize;
-(void)setOriginalSize:(CGSize)originalSize;
-(float)individualDirection;
-(void)setIndividualDirection:(float)individualDirection;

@end
