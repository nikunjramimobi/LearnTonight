//
//  NSDictionary+Misc.m
//  webServiceCommunication
//
//  Created by Rushabh on 7/16/14.
//  Copyright (c) 2014 Rushabh Champaneri. All rights reserved.
//

#import "NSDictionary+Misc.h"
#import "NSArray+NullReplacement.h"

@implementation NSMutableDictionary (Misc)

- (id)removeAndReturnObjectForKey:(id)key {
    @try{
        id value = [self valueForKey:key];
        __strong id strongValue = value;
        [self setValue:nil forKey:key];
        return strongValue;
    } @catch (NSException *exception) {
        
    }
}

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks {

    @try{
        const NSMutableDictionary *replaced = [self mutableCopy];
        const id nul = [NSNull null];
        const NSString *blank = @"";
        
        for (NSString *key in self) {
            id object = [self objectForKey:key];
            if (object == nul) [replaced setObject:blank forKey:key];
            else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
            else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
        }
        return [NSDictionary dictionaryWithDictionary:[replaced copy]];
    } @catch (NSException *exception) {
        
    }
}

@end