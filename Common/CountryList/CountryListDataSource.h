//
//  CountryListDataSource.h
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kName        @"name"
#define kCountryCallingCode @"dial_code"
#define kCountryCode        @"code"

@interface CountryListDataSource : NSObject

- (NSArray *)countries;
@end

@interface LanguageListDataSource : NSObject

- (NSArray *)languages;
@end
