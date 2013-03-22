//
//  AppContext.h
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/19/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppCTX [AppContext sharedInstance]

@interface AppContext : NSObject

+(AppContext*)sharedInstance;

-(NSString*)apiKey;
-(NSMutableDictionary*)parametersDictionaryWithAPIKey;

@end
