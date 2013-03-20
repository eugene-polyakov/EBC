//
//  ModelMapping.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/19/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ModelMapping : NSObject

+(RKEntityMapping*)venueMapping;
+(RKEntityMapping*)ticketMapping;
+(RKEntityMapping*)eventMapping;
+(RKEntityMapping*)organizerMapping;


@end

