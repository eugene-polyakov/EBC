//
//  KeyUtils.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyUtils : NSObject

+ (NSString *)obfuscate:(NSString *)data withKey:(NSString *)key;

@end
