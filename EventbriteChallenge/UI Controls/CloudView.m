//
//  CloudView.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "CloudView.h"

@implementation CloudView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}

@end
