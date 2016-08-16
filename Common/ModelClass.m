//
//  ModelClass.m
//  APITest
//
//  Created by Evgeny Kalashnikov on 03.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModelClass.h"
#import "ASIFormDataRequest.h"

@implementation ModelClass

@synthesize delegate = _delegate;
@synthesize mcDelegate = _mcDelegate;

@synthesize success;
@synthesize returnData = _returnData;

- (id)init
{
    self = [super init];
    if (self) {
        parser = [[SBJSON alloc] init];
        success = NO;
        httpRequest = [[ASIHTTPRequest alloc]init];
        httpRequest.delegate = self;
       // [httpRequest setTimeOutSeconds:120];
    }
    
    return self;
}


- (void)serviceCall:(NSArray *)keys value:(NSArray *)value url:(NSString *)str selector:(SEL)sel
{
    
    if(sel != nil){
        mainSel = sel;
    }
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",APIURL,str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.shouldContinueWhenAppEntersBackground = YES;
    [request setRequestMethod:@"POST"];
    for (int i = 0; i<[keys count]; i++) {
        [request setPostValue:[value objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"response >>>%@",[request responseString]);
    NSString *func = [self getFunc:[request url]];
    if ([func isEqual:@"php"]) {
        if ([[parser objectWithString:[request responseString] error:nil] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *results = [parser objectWithString:[request responseString] error:nil];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            if(mainSel != nil){
                //[self.mcDelegate finishedRequest:jid withResult:results];
                [self.delegate performSelector:mainSel withObject:results];
            }
           
#pragma clang diagnostic pop
        }
        else
        {
            NSMutableDictionary *results = [parser objectWithString:[request responseString] error:nil];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            
            if(mainSel != nil){
                [self.delegate performSelector:mainSel withObject:results];
            }
            
            
#pragma clang diagnostic pop
        }
    }
}


- (void)failWithError:(NSError *)theError
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.delegate performSelector:mainSel withObject:nil];
#pragma clang diagnostic pop
}

- (NSString *) getFunc:(NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@",url];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    return [arr lastObject];
}


- (void)serviceCallForMultipart:(NSArray *)keys value:(NSArray *)value url:(NSString *)str selector:(SEL)sel
{
    if (sel != nil) {
        mainSel = sel;
    }
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@",APIURL,str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.shouldContinueWhenAppEntersBackground = YES;
    [request setRequestMethod:@"POST"];
    
    for (int i = 0; i<[keys count]; i++) {
        if(i < (keys.count - 1))
        {
            [request setPostValue:[value objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        }
        else
        {
            [request addData:[value objectAtIndex:i] withFileName:[NSString stringWithFormat:@"%@.png",[keys objectAtIndex:i]] andContentType:@"image/png" forKey:[keys objectAtIndex:i]];
        }
    }
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request startAsynchronous];
    
    
}
-(void)cancelRequest{
    
    
    
    for (ASIFormDataRequest *request in ASIFormDataRequest.sharedQueue.operations)
    {
        
        [request cancel];
        [request setDelegate:nil];
        [request clearDelegatesAndCancel];
        
        [request setDelegate:nil];
        [request setDidFailSelector:nil];
        [request setDidFinishSelector:nil];
        //request.sharedQueue = nil;
        
    }
    [ASIFormDataRequest.sharedQueue cancelAllOperations];
    
    
    for (ASIHTTPRequest *request in ASIHTTPRequest.sharedQueue.operations)
    {
        
            [request cancel];
            [request setDelegate:nil];
            [request clearDelegatesAndCancel];
            
            [request setDelegate:nil];
            [request setDidFailSelector:nil];
            [request setDidFinishSelector:nil];
            //request.sharedQueue = nil;
      
    }
    
    [ASIHTTPRequest.sharedQueue cancelAllOperations];
}


-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength{
    
    ////NSLog(@"incrementUploadSizeBy 1>>>%lld",newLength);
    //[_delegate incrementUploadSizeBy:newLength];
    
    
}
-(void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
    ////NSLog(@"incrementDownloadSizeBy 1>>>%lld",newLength);
    //[_delegate incrementDownloadSizeBy:newLength];
}

-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
    
    //[_delegate didSendBytes:bytes];
    
    
}
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    ////NSLog(@"didReceiveBytes 1>>>%lld",bytes);
    //[_delegate didReceiveBytes:bytes];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *message = NULL;
    
    NSError *error = [request error];
    switch ([error code])
    {
        case ASIRequestTimedOutErrorType:
            message = @"kAlertMsgTimeoutError";
            
            break;
        case ASIConnectionFailureErrorType:
            message = @"kAlertMsgConnectionFailError";
            break;
        case ASIAuthenticationErrorType:
            message = @"kAlertMsgAuthFailError";
            break;
        case ASITooMuchRedirectionErrorType:
            message = @"kAlertMsgTooManyRedirect";
            break;
        case ASIRequestCancelledErrorType:
            message = @"kAlertMsgReqCancelledError";
            break;
        case ASIUnableToCreateRequestErrorType:
            message = @"kAlertMsgUnableCreateReqError";
            break;
        case ASIInternalErrorWhileBuildingRequestType:
            message = @"kAlertMsgUnableBuildReqError";
            break;
        case ASIInternalErrorWhileApplyingCredentialsType:
            message = @"kAlertMsgUnableApplyCredError";
            break;
        case ASIFileManagementError:
            message = @"kAlertMsgFileManageError";
            break;
        case ASIUnhandledExceptionError:
            message = @"kAlertMsgUnhandledExcepError";
            break;
        case ASICompressionError:
            message = @"kAlertMsgCompressionError";
            break;
        default:
            message = @"kAlertMsgGenericError";
            break;
    }
    
    if (NULL != message)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"kApplicationTitle"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
       // [alert show];
        
        [_delegate failRequest:message];
    } 
}

@end
