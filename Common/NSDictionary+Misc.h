//
//  NSDictionary+Misc.h
//  webServiceCommunication
//
//  Created by Rushabh on 7/16/14.
//  Copyright (c) 2014 Rushabh Champaneri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Misc)
- (id)removeAndReturnObjectForKey:(id)key;
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;

@end
