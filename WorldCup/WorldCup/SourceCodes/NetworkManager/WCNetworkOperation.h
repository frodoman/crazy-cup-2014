//
//  WCNetworkOperation.h
//  WorldCup
//
//  Created by XH Liu on 14/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    WCNetworkRequestTypeAllGames=0,
    WCNetworkRequestTypeGroupGameResult = 1
} WCNetworkRequestType;


@interface WCNetworkOperation : NSOperation
<NSURLConnectionDelegate>

@property(nonatomic, weak) id target;
@property(nonatomic) SEL errorSelector;
@property(nonatomic) SEL completeSelector;

//kvo
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property (readonly) BOOL wasSuccessful;
@property (nonatomic) WCNetworkRequestType requestType;

@property(nonatomic, strong) NSURL *urlOfRequest;
@property(nonatomic, strong) NSMutableData *responseData;


-(id) initWithURL: (NSURL*)theUrl requestType: (WCNetworkRequestType)requestType;

@end
