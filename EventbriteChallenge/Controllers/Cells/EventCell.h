//
//  EventCell.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface EventCell : UITableViewCell

-(void)applyEvent:(Event*)event;
+(EventCell*)cellForEvent:(Event*)event;

+(CGFloat)height;

@end
