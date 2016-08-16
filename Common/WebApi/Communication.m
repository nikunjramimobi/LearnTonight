#import "Communication.h"

NSMutableDictionary * CommunicationRequest(NSString *requestType, NSMutableDictionary *param, NSThread *callbacksThread, CommunicationSuccessBlock successBlock, CommunicationErrorBlock errorBlock, CommunicationCompleteBlock completeBlock) {
    NSMutableDictionary *request = [@{@"type": requestType,
                                     @"successBlock": InHeap(successBlock),
                                     @"errorBlock": InHeap(errorBlock),
                                     @"completeBlock": InHeap(completeBlock),
                                     @"callbacksThread": callbacksThread}mutableCopy];
    
    
    [request setValue:param forKey:@"param"];
//    DLog(@"request: %@", request);
    return request;
}

NSThread * ThreadForRequestCallbacks(NSMutableDictionary *request) {
    NSThread *thread = [request objectForKey:@"callbacksThread"];
    if (![thread isFinished]) {
//        DLog(@"thread: %@", thread);
        return thread;
    }
//    DLog(@"main thread: %@", thread);
    return [NSThread mainThread];
}

void CallCommunicationRequestSuccessBlock(NSMutableDictionary *request, id res, BOOL callComplete) {
//    DLog(@"communication success. {result: %@, request: %@}", res, request);
    [request removeObjectForKey:@"errorBlock"];
    CommunicationSuccessBlock block = (CommunicationSuccessBlock)[request removeAndReturnObjectForKey:@"successBlock"];
    OnThread(ThreadForRequestCallbacks(request), NO, ^{
        if (nil != block) {
            block(res);
        }
        if (callComplete) {
//            DLog(@"calling complete");
            CallCommunicationRequestCompleteBlock(request);
        }
    });
}

void CallCommunicationRequestErrorBlock(NSMutableDictionary *request, NSString *errStr, NSInteger status, BOOL callComplete) {
//    DLog(@"communication error: {error: %@, request: %@, status: %i}", errStr, request, status);
    [request removeObjectForKey:@"successBlock"];
    CommunicationErrorBlock block = (CommunicationErrorBlock)[request removeAndReturnObjectForKey:@"errorBlock"];
    if (nil == block) {
        return;
    }
    OnThread(ThreadForRequestCallbacks(request), NO, ^{
        block(errStr, status);
        if (callComplete) {
//            DLog(@"calling complete");
            CallCommunicationRequestCompleteBlock(request);
        }
    });
}

void CallCommunicationRequestCompleteBlock(NSMutableDictionary *request) {
//    DLog(@"communication complete: request: %@", request);
    CommunicationCompleteBlock block = (CommunicationCompleteBlock)[request removeAndReturnObjectForKey:@"completeBlock"];
    if (nil == block) {
        return;
    }
    OnThread(ThreadForRequestCallbacks(request), NO, block);
}

