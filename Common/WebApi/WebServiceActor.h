#import <Foundation/Foundation.h>
#import "Actor.h"
#import "Reachability.h"
#import "Communication.h"


@interface WebServiceActor : Actor {

}

@property (nonatomic, retain) Reachability *_reachability;
@property (getter=_isWebServiceReachable, nonatomic) BOOL _webServiceReachable;

- (void)sendRequestWithType:(NSString *)requestType parameter:(id)param successBlock:(CommunicationSuccessBlock)successBlock errorBlock:(CommunicationErrorBlock)errorBlock completeBlock:(CommunicationCompleteBlock)completeBlock;
@end
