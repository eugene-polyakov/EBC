//
//  CloudView.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyingObject.h"

@interface CloudView : UIImageView<FlyingObject>

@property (nonatomic) CGFloat z;
@property (nonatomic) CGSize originalSize;

@property (nonatomic, strong) void(^tapBlock)(CloudView* cloud);

@end
