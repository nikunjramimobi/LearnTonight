#import <Foundation/Foundation.h>
#import "BlocksAdditions.h"
#import "NSDictionary+Misc.h"


#define DEVICE_INTERNAL_RESPONSE_GENERIC 200
#define DEVICE_INTERNAL_RESPONSE_INVALID_STATE 202
#define DEVICE_INTERNAL_RESPONSE_TIMEOUT 203
#define DEVICE_INTERNAL_RESPONSE_DEVICE_CONNECTION_SHUTDOWN 204
#define DEVICE_INTERNAL_RESPONSE_UNKNOWN_DEVICE_RESPONSE 205

#define WEB_SERVICE_RESPONSE_ERROR 404
#define WEB_SERVICE_RESPONSE_USER_DOES_NOT_EXIST 403
#define WEB_SERVICE_RESPONSE_SESSION_EXPIRED 401
#define WEB_SERVICE_INTERNAL_RESPONSE_XML_QUERY_ERROR 402
#define WEB_SERVICE_INTERNAL_RESPONSE_WRONG_RESPONSE_FORMAT 405
#define WEB_SERVICE_INTERNAL_RESPONSE_NOT_REACHABLE 400
#define WEB_SERVICE_INTERNAL_RESPONSE_INVALID_STATE 406
#define WEB_SERVICE_INTERNAL_RESPONSE_COMMUNICATION_ERROR 407


typedef void(^CommunicationSuccessBlock)(id);
typedef void(^CommunicationErrorBlock)(NSString *, NSInteger);
typedef void(^CommunicationCompleteBlock)(void);

NSMutableDictionary * CommunicationRequest(NSString *requestType, NSMutableDictionary *param, NSThread *callbacksThread, CommunicationSuccessBlock successBlock, CommunicationErrorBlock errorBlock, CommunicationCompleteBlock completeBlock);
void CallCommunicationRequestSuccessBlock(NSMutableDictionary *request, id res, BOOL callComplete);
void CallCommunicationRequestErrorBlock(NSMutableDictionary *request, NSString *errStr, NSInteger status, BOOL callComplete);
void CallCommunicationRequestCompleteBlock(NSMutableDictionary *request);
