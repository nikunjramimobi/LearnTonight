//
//  ModelClass.h
//  APITest
//
//  Created by Evgeny Kalashnikov on 03.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "JSON.h"
#import "ASIHTTP/ASIHTTPRequest.h"


@protocol ModelClassDelegate <NSObject>

@optional
-(void)finishedRequest:(NSString *)jid withResult:(NSMutableDictionary *)result;
-(void)failRequest:(NSString *)jid;
-(void)incrementUploadSizeBy:(long long)newLength;
-(void)incrementDownloadSizeBy:(long long)newLength;
-(void)didSendBytes:(long long)bytes;
-(void)didReceiveBytes:(long long)bytes;

@end

@class DarckWaitView;

@interface ModelClass : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate> {
    SEL mainSel;
    SBJSON *parser;
    DarckWaitView *drkSignUp;
    ASIHTTPRequest *httpRequest;
    int totalSize;
    int uploadedSize;
}

@property (nonatomic, retain, strong) id delegate;
@property (nonatomic, retain) id returnData;
@property (nonatomic, readwrite) BOOL success;
@property (nonatomic, strong) id<ModelClassDelegate> mcDelegate;
- (NSString *) getFunc:(NSURL *)url;
- (void)serviceCall:(NSArray *)keys value:(NSArray *)value url:(NSString *)str selector:(SEL)sel;
- (void)serviceCallForMultipart:(NSArray *)keys value:(NSArray *)value url:(NSString *)str selector:(SEL)sel;
-(void)cancelRequest;
@end
