//
//  EventListControllerViewController.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"

@interface EventListViewController : UIViewController

-(id)initWithTagView:(TagView*)tagView events:(NSSet*)events;

@end
