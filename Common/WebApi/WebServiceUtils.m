//
//  WebServiceUtils.m
//  WebService
//
//  Created by Rushabh on 29/09/14.
//  Copyright (c) 2014 Rushabh. All rights reserved.
//

#import "WebServiceUtils.h"


@implementation WebServiceUtils

@end

void SendRequestToWebService(NSString *requestType, id param, CommunicationSuccessBlock successBlock, CommunicationErrorBlock errorBlock, CommunicationCompleteBlock completeBlock)
{
    @try{
        DLog(@"Before request %@",param);
    //    [AppDelegate_.webServiceRequestsTracker willSendWebServiceRequestWithType:requestType param:param];
        [AppDelegate_.webServiceActor sendRequestWithType:requestType parameter:param successBlock:^(id res) {
    //        [AppDelegate_.webServiceRequestsTracker endedWebServiceRequestWithType:requestType param:param successResult:res];
            successBlock(res);
        } errorBlock:^(NSString *errStr, NSInteger code) {
    //        [AppDelegate_.webServiceRequestsTracker endedWebServiceRequestWithType:requestType param:param withError:errStr errorCode:code];
            errorBlock(errStr, code);
        } completeBlock:completeBlock];
    } @catch (NSException *exception) {
        
    }
}
