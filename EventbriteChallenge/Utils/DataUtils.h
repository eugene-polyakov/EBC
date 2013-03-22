//
//  DataUtils.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/21/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface DataUtils : NSObject

+(NSArray*)tagsFromEvent:(Event*)event;
+(NSDictionary*)groupedDictionaryOfEvents:(NSArray*)events;

@end
