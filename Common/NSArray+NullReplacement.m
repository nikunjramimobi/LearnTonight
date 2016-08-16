//
//  NSString+Additions.h
//  webServiceCommunication
//
//  Created by Rushabh on 7/16/14.
//  Copyright (c) 2014 Rushabh Champaneri. All rights reserved.
//

#import "NSArray+NullReplacement.h"
#import "NSDictionary+Misc.h"

@implementation NSArray (NullReplacement)

- (NSArray *)arrayByReplacingNullsWithBlanks  {
    @try{
        NSMutableArray *replaced = [self mutableCopy];
        const id nul = [NSNull null];
        const NSString *blank = @"";
        for (int idx = 0; idx < [replaced count]; idx++) {
            id object = [replaced objectAtIndex:idx];
            if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
            else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
            else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
        }
        return [replaced copy];
    } @catch (NSException *exception) {
        
    }
}

@end
