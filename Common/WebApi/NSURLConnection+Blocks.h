#import <Foundation/Foundation.h>
#import "BlocksAdditions.h"



@interface NSURLConnection (Blocks) 

+ (NSURLConnection *)connectionWithRequest:(NSURLRequest *)httpRequest startImmediately:(BOOL)shouldStart successBlock:(void(^)(NSHTTPURLResponse *httpResponse, NSData *httpResponseBodyData))successBlock errorBlock:(void(^)(NSString *errStr,NSInteger errorCode))errorBlock completeBlock:(void(^)(void))completeBlock;

@end
