//
//  TagCloudViewController.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagCloudView.h"

@interface TagCloudViewController : UIViewController

@property (nonatomic, strong) IBOutlet TagCloudView * tagView;

@end

@interface TagCloudViewController(Graphics)

-(void)addViewForTag:(NSString*)tag z:(int)z;
-(void)addClouds:(int)number;

@end

@interface TagCloudViewController(Sensors)<UIAccelerometerDelegate>

-(void)startTracking;
-(void)stopTracking;

@end
