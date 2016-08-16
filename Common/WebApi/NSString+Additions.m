//
//  NSString+Additions.m
//  webServiceCommunication
//
//  Created by Rushabh on 7/16/14.
//  Copyright (c) 2014 Rushabh Champaneri. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)
- (NSString *)uppercasedFirstString {
    @try{
        ZAssert([self length] > 0, @"string must have at least one character");
        return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
    } @catch (NSException *exception) {
        
    }
}


+(NSString*)formatNumber:(NSString*)mobileNumber
{
    @try{
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        NSLog(@"%@", mobileNumber);
        
        int length = [mobileNumber length];
        if(length > 10)
        {
            mobileNumber = [mobileNumber substringFromIndex: length-10];
            NSLog(@"%@", mobileNumber);
            
        }
        return mobileNumber;
    } @catch (NSException *exception) {
        
    }
}


@end
