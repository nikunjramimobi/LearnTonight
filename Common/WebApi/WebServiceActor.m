#import "WebServiceActor.h"
#import "NSURLConnection+Blocks.h"
#import "NSString+Additions.h"
#import "XMLReader.h"


@implementation WebServiceActor

@synthesize _reachability, _webServiceReachable;

- (void)reachabilityChanged:(NSNotification *)note {
    @try{
        Reachability *aReachability = [note object];
        [self onWorkerThreadDoBlock:^{
            self._webServiceReachable = NotReachable != [aReachability currentReachabilityStatus];
            
            DLog(@"reachability changed. Is web-service reachable: %@", self._isWebServiceReachable ? @"YES" : @"NO");
            PostNoteBLE(@"WebServiceReachabilityChanged", [NSNumber numberWithBool:self._webServiceReachable]);
        }];
    } @catch (NSException *exception) {
        
    }
}
- (void)appDidBecomeActive:(NSNotification *)note {
    @try{
        [self onWorkerThreadDoBlock:^{
            NSString *hostName = [[NSURL URLWithString:WebServiceURL()] host];
            DLog(@"registering for reachability to host %@", hostName);
            self._reachability = [Reachability reachabilityWithHostName:hostName];
            self._webServiceReachable = NotReachable != [self._reachability currentReachabilityStatus];
        }];
    } @catch (NSException *exception) {
        
    }
}

- (void)initialize {
    @try{
        [super initialize];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    } @catch (NSException *exception) {
        
    }
    
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)_sendRequestToWebService:(NSMutableDictionary *)request {
    
    @try{
       if (!self._webServiceReachable) {
            CallCommunicationRequestErrorBlock(request,@"No internet connectivity", WEB_SERVICE_INTERNAL_RESPONSE_NOT_REACHABLE, YES);
            return;
        }
        NSString *requestType = [request valueForKey:@"type"];
        NSString *methodType = request[@"param"][kMethodType];
        BOOL isSoap = false;
        if (request[@"param"][kSoapAPI]) {
            isSoap = [request[@"param"][kSoapAPI] boolValue];
        }
        
        NSMutableURLRequest *httpRequest;
        
        if (isSoap) {
            
            NSString *requestMethod = request[@"param"][kRequestMethod];
            NSString *requestValue = request[@"param"][kRequestValue];
            
            NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                                     "<soap:Body>"
                                     "<%@ xmlns=\"http://tempuri.org/\">"
                                     "<scripts>%@</scripts>"
                                     "</%@>"
                                     "</soap:Body>"
                                     "</soap:Envelope>",requestMethod,requestValue,requestMethod];
            
            NSURL *url = [NSURL URLWithString:WebServiceURLForSoap()];
            httpRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
            
            [httpRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [httpRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",requestMethod] forHTTPHeaderField:@"SOAPAction"];
            [httpRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [httpRequest setHTTPMethod:methodType];
            [httpRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

            
        }else{
            SEL requestBodyBuilderSel = NSSelectorFromString([NSString stringWithFormat:@"_build%@RequestBodyData:docReadyBlock:", [requestType uppercasedFirstString]]);
            if (![self respondsToSelector:requestBodyBuilderSel]) {
                DLog(@"no request builder found: %@", NSStringFromSelector(requestBodyBuilderSel));
                CallCommunicationRequestErrorBlock(request, @"could not build web-service request", WEB_SERVICE_INTERNAL_RESPONSE_INVALID_STATE, YES);
                return;
            }
            
            
            NSData *httpRequestBodyData = [self performSelector:requestBodyBuilderSel withObject:[request valueForKey:@"param"] withObject:^id(NSDictionary *jsonDict) {
                NSError *error;
                NSMutableDictionary *Dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
                
                NSArray *keys = Dict.allKeys;
                NSMutableData *data = [NSMutableData data];
                
                for (int i=0; i<keys.count; i++) {
                    NSString *string;
                    if(i==0)
                        string = [NSString stringWithFormat:@"%@=%@",keys[i],Dict[keys[i]]];
                    else
                        string = [NSString stringWithFormat:@"&%@=%@",keys[i],Dict[keys[i]]];
                    
                    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                return data;
            }];
            
            if (nil == httpRequestBodyData) {
                CallCommunicationRequestErrorBlock(request, @"could not build web-service request", WEB_SERVICE_INTERNAL_RESPONSE_INVALID_STATE, YES);
                return;
            }
            
            DLog(@"jsonRequest %@",[[NSString alloc] initWithData:httpRequestBodyData encoding:NSUTF8StringEncoding]);
            
            NSMutableString *requestURL = [[self getURL:requestType] mutableCopy];
            
             httpRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:WEB_SERVICE_TIMEOUT];
            //    [httpRequest setValue:kAuthorizationValue forHTTPHeaderField:kAuthorization];
            
            
            if ([methodType isEqualToString:kMethodTypePost]){
                NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded" };
                [httpRequest setAllHTTPHeaderFields:headers];
                [httpRequest setHTTPMethod:methodType];
                [httpRequest setHTTPBody:httpRequestBodyData];
            }else if([methodType isEqualToString:kMethodTypeGet]){
                [httpRequest setHTTPMethod:methodType];
                [httpRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            }
            
        }
        
            [NSURLConnection connectionWithRequest:httpRequest startImmediately:YES successBlock:^(NSHTTPURLResponse *httpResponse, NSData *httpResponseBodyData) {
            SEL responseBodyParserSel = NSSelectorFromString([NSString stringWithFormat:@"_parse%@ResponseBodyData:errorBlock:", [requestType uppercasedFirstString]]);
            
            if ([self respondsToSelector:responseBodyParserSel]) {
                DLog(@"parsing web-service response");
                id response = [self performSelector:responseBodyParserSel withObject:httpResponseBodyData withObject:^(NSString *errStr, NSInteger code) {
                    CallCommunicationRequestErrorBlock(request, errStr, code, YES);
                }];
                if (nil != response) {
                    CallCommunicationRequestSuccessBlock(request, response, YES);
                }
                return;
            }
        } errorBlock:^(NSString *errStr,NSInteger errorCode) {
            NSString *errorMessge = [self errorMessageFromCode:errorCode];
            if (errorMessge != nil && [errorMessge isEqualToString:@""]) {
                CallCommunicationRequestErrorBlock(request,[NSString stringWithFormat:@"Communication error: %@", errStr],errorCode,YES);
            }else{
                CallCommunicationRequestErrorBlock(request, errorMessge, errorCode, YES);
            }
        } completeBlock:^{
            DLog(@"HTTP request completed");
        }];
    } @catch (NSException *exception) {
        DLog(@"ExceptionLog %@",exception.reason);
    }
}

-(NSString *)errorMessageFromCode:(NSInteger)code
{
    @try{
        switch (code) {
            case WEB_SERVICE_INTERNAL_RESPONSE_NOT_REACHABLE:
                return @"Internet connection appears to be offline";
                
            case WEB_SERVICE_RESPONSE_SESSION_EXPIRED:{
                return @"Session Expired, please login again";
            }
            default:
                break;
        }
        return @"";
    } @catch (NSException *exception) {
        DLog(@"ExceptionLog %@",exception.reason);
    }
}


- (void)sendRequestWithType:(NSString *)requestType parameter:(id)param successBlock:(CommunicationSuccessBlock)successBlock errorBlock:(CommunicationErrorBlock)errorBlock completeBlock:(CommunicationCompleteBlock)completeBlock {
    NSThread *callBacksThread = [NSThread currentThread];
    [self onWorkerThreadDoBlock:^{
        NSMutableDictionary *request = CommunicationRequest(requestType, param, callBacksThread, successBlock, errorBlock, completeBlock);
        [self _sendRequestToWebService:request];
    }];
}

- (void)cleanup {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super cleanup];
    DLog(@"shut down");
}

- (void)dealloc {
    DLog(@"web-service actor is done");
    self._reachability = nil;
}



#pragma mark - Login Sercvice Call

- (NSData *)_buildLoginRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseLoginResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"Login %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

#pragma mark - Registration Sercvice Call
- (NSData *)_buildRegistrationRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseRegistrationResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"Registration %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

#pragma mark - Dashboard Sercvice Call
- (NSData *)_buildDashboardRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseDashboardResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"Registration %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

#pragma mark - Other Sercvice Call

- (id)_parseGetALLResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
//        DLog(@"GetALL %@",jsonResponse);
        if (jsonResponse && [jsonResponse isKindOfClass:[NSString class]]) {
            
            NSError *error = nil;
            NSMutableDictionary *dicData  = [[XMLReader dictionaryForXMLString:jsonResponse error:&error] mutableCopy];
            NSString *result ;
            if (error == nil && dicData[@"soap:Envelope"][@"soap:Body"][@"GetALLResponse"][@"GetALLResult"][@"ResultData"]) {
                result = dicData[@"soap:Envelope"][@"soap:Body"][@"GetALLResponse"][@"GetALLResult"][@"ResultData"];
            }
            if (result) {
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
        }
        return jsonResponse;
    }, errorBlock);
}

- (id)_parseGetUpdateResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        //        DLog(@"GetALL %@",jsonResponse);
        if (jsonResponse && [jsonResponse isKindOfClass:[NSString class]]) {
            
            NSData *myData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSMutableDictionary *dicData  = [[XMLReader dictionaryForXMLData:myData error:&error] mutableCopy];
            NSString *result ;
            if (error == nil && dicData[@"soap:Envelope"][@"soap:Body"][@"GetALLResponse"][@"GetALLResult"][@"ResultData"]) {
                result = dicData[@"soap:Envelope"][@"soap:Body"][@"GetALLResponse"][@"GetALLResult"][@"ResultData"];
            }
            if (result) {
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
        }
        return jsonResponse;
    }, errorBlock);
}



- (NSData *)_buildAppVersionRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseAppVersionResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"AppVersion %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

- (NSData *)_buildChangePasswordRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseChangePasswordResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"Change Password %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

- (NSData *)_buildGetDeviceRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseGetDeviceResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"Get Device %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}

- (NSData *)_buildUserDetailRequestBodyData:(id)param docReadyBlock:(id(^)(NSDictionary *jsonDict))docReadyBlock {
    [param removeObjectForKey:kMethodType];
    return docReadyBlock(param);
}

- (id)_parseUserDetailResponseBodyData:(NSData *)httpResponseBodyData errorBlock:(CommunicationErrorBlock)errorBlock {
    return ParseResponseDoc(httpResponseBodyData, ^id(id jsonResponse) {
        DLog(@"UserDetail %@",jsonResponse);
        return jsonResponse;
    }, errorBlock);
}




id ParseResponseDoc(NSData *jsonData, id(^JsonContextBlock)(id jsonResponse), void(^errorBlock)(NSString *errStr, NSInteger code)) {
    NSError *jsonError = nil;
    
    @try{
        if (jsonData == nil) {
            return @{};
        }
        id dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        NSDictionary *dictNonNull;
        __block id ret = nil;
        if (dict == nil) {
            ret = JsonContextBlock([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            return ret;
        }
        else{
            dictNonNull = [dict dictionaryByReplacingNullsWithBlanks]; //[dict mutableCopy];
        }
        
        if(jsonError){
            errorBlock(@"Invalid Data", WEB_SERVICE_RESPONSE_ERROR);
            return ret;
        }
        ret = JsonContextBlock(dictNonNull);
        return ret;
    } @catch (NSException *exception) {
        DLog(@"ExceptionLog %@",exception.reason);
    }
}


- (NSString *)getURL:(NSString *)requestType{
    
    @try {
        if([requestType isEqualToString:WSLogin]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"login.php"];
        }else if([requestType isEqualToString:WSRegistration]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"registration.php"];
        }else if([requestType isEqualToString:WSDashboard]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"dashboard.php"];
        }
        
        else if([requestType isEqualToString:WSChangePassword]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"ChangePassword.php"];
        }else if([requestType isEqualToString:WSGetDevice]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"GetDevice.php"];
        }else if([requestType isEqualToString:WSUserDetail]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURL(),@"UserDetails.php"];
        }else if ([requestType  isEqualToString:WSGetALL]){
            return [NSString stringWithFormat:@"%@%@",WebServiceURLForSoap(),@"UserDetails.php"];
        }
        
    } @catch (NSException *exception) {
        DLog(@"ExceptionLog %@",exception.reason);
    }
    return nil;
}

@end