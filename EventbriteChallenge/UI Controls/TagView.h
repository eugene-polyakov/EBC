//
//  TagView.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyingObject.h"

@interface TagView : UIButton<FlyingObject>

@property (nonatomic, strong) NSString * tagName;


@end
