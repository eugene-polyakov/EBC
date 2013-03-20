//
//  KeyUtils.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/20/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "KeyUtils.h"

@implementation KeyUtils

+ (NSString *)obfuscate:(NSString *)data withKey:(NSString *)key
{
    NSMutableData *result = [[data dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    char *dataPtr = (char *) [result mutableBytes];
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    int keyIndex = 0;

    for (int x = 0; x < [data length]; x++)
    {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

@end
