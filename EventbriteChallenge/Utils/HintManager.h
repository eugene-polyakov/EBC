//
//  HintManager.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/22/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HintManager : NSObject

+(void)showHint:(NSString*)hint inView:(UIView*)v afterDelay:(NSTimeInterval)delay key:(NSString*)key;

@end
