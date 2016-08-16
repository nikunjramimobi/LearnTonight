//
//  WebServiceUtils.h
//  WebService
//
//  Created by Rushabh on 29/09/14.
//  Copyright (c) 2014 Rushabh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communication.h"
#import "AppDelegate.h"

#define kSoapAPI            @"SoapAPI"
#define kRequestMethod      @"requestMethod"
#define kRequestValue       @"requestValue"

#define kMethodType         @"methodType"
#define kMethodTypeGet      @"GET"
#define kMethodTypePost     @"POST"
#define kMethodTypeDelete   @"DELETE"


#define WSLogin            @"Login"
#define WSRegistration     @"Registration"
#define WSDashboard     @"Dashboard"


#define WSChangePassword   @"ChangePassword"
#define WSAppVersion       @"AppVersion"
#define WSGetDevice        @"GetDevice"
#define WSUserDetail       @"UserDetail"

#define WSGetALL            @"GetALL"
#define WSGetUpdates        @"GetUpdate"
#define WSMapping           @"Mapping"


#define AppDelegate_ ((AppDelegate *)[UIApplication sharedApplication].delegate)



@interface WebServiceUtils : NSObject

@end



void SendRequestToWebService(NSString *requestType, id param, CommunicationSuccessBlock successBlock, CommunicationErrorBlock errorBlock, CommunicationCompleteBlock completeBlock);