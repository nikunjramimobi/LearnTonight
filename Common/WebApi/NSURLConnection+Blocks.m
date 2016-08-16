#import "NSURLConnection+Blocks.h"

@interface _ConnectionDelegate : NSObject 

@property (nonatomic, retain) NSMutableData *httpResponseData;
@property (nonatomic, retain) NSHTTPURLResponse *httpResponse;
@property (nonatomic, copy) void(^successBlock)(NSHTTPURLResponse *httpResponse, NSData *httpResponseData);
@property (nonatomic, copy) void(^errorBlock)(NSString *errStr);
@property (nonatomic, copy) void(^completeBlock)();

@end


@implementation _ConnectionDelegate

@synthesize httpResponse;
@synthesize httpResponseData;
@synthesize successBlock, errorBlock, completeBlock;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    @try{
        self.httpResponse = (NSHTTPURLResponse *)aResponse;
        DLog(@"HTTP response: {status code: %ld, headers: %@}", (long)[self.httpResponse statusCode], [self.httpResponse allHeaderFields]);
    } @catch (NSException *exception) {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try{
        if (nil == self.httpResponseData) {
            self.httpResponseData = [NSMutableData data];
        }
        [self.httpResponseData appendData:data];
    } @catch (NSException *exception) {
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    @try{
        DLog(@"connection: %@, error: %@", connection, error);
        self.errorBlock([error localizedDescription]);
        self.completeBlock();
        self.completeBlock = nil;
        self.successBlock = nil;
    } @catch (NSException *exception) {
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @try{
        DLog(@"connectionDidFinishLoading >> connection original request %@ connection current request %@ ",[connection originalRequest],[connection currentRequest]);
        if ([self.httpResponse statusCode] >= 200 && [self.httpResponse statusCode] < 400) {
            if (nil != self.successBlock) {
                self.successBlock(self.httpResponse, self.httpResponseData);
            }
        }
        else {
            DLog(@"ErrorOnDidFinishLoading %@",[[self.httpResponse class] localizedStringForStatusCode:[self.httpResponse statusCode]]);
            self.errorBlock([[self.httpResponse class] localizedStringForStatusCode:[self.httpResponse statusCode]]);
        }

        if (nil != self.completeBlock) {
            self.completeBlock();
        }
    } @catch (NSException *exception) {
        
    }
}


- (void)dealloc {
    @try{
        self.httpResponseData = nil;
        self.httpResponse = nil;
        
        self.successBlock = nil;
        self.errorBlock = nil;
        self.completeBlock = nil;
    } @catch (NSException *exception) {
        
    }
    
}

@end


@implementation NSURLConnection (Blocks)

+ (NSURLConnection *)connectionWithRequest:(NSURLRequest *)httpRequest startImmediately:(BOOL)shouldStart successBlock:(void(^)(NSHTTPURLResponse *httpResponse, NSData *httpResponseBodyData))successBlock errorBlock:(void(^)(NSString *errStr,NSInteger errorCode))errorBlock completeBlock:(void(^)(void))completeBlock {
    DLog(@"HTTP request: %@ {method: %@, headers: %@}",httpRequest,[httpRequest HTTPMethod], [httpRequest allHTTPHeaderFields]);

    @try{
        if (![NSURLConnection canHandleRequest:httpRequest]) {
            errorBlock(@"cannot handle request",WEB_SERVICE_INTERNAL_RESPONSE_COMMUNICATION_ERROR);
            completeBlock();
            return nil;
        }
        _ConnectionDelegate *aDelegate = [[_ConnectionDelegate alloc] init] ;
        aDelegate.successBlock = InHeap(successBlock);
        aDelegate.errorBlock = InHeap(errorBlock);
        aDelegate.completeBlock = InHeap(completeBlock);
        NSURLConnection *connection = [[self class] connectionWithRequest:httpRequest delegate:aDelegate];
        if (nil == connection) {
            errorBlock(@"could not create connection",WEB_SERVICE_INTERNAL_RESPONSE_COMMUNICATION_ERROR);
            completeBlock();
            return nil;
        }
        if (shouldStart) {
            [connection start];
        }
        return connection;
    } @catch (NSException *exception) {
        
    }
}

@end
