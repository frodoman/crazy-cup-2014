//
//  WCNetworkManager.m
//  WorldCup
//
//  Created by XH Liu on 14/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCNetworkManager.h"
#import "WCNetworkOperation.h"
#import "NSObject+Consts.h"

static WCNetworkManager *_networkManager;

@implementation WCNetworkManager

+(WCNetworkManager*)sharedNetworkManager
{
    if( _networkManager == nil )
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _networkManager = [[WCNetworkManager alloc] init];
        });
    }
    return  _networkManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _operationQueue = [[NSOperationQueue alloc] init ];
    }
    
    return self;
}


#pragma mark - Public 
-(void) requestAllGamesWithTarget: (id)target
                  completeHandler: (SEL)completeSelector
                     errorHandler: (SEL)errorSelector
{
    // for fast debugging use the local url:  URL_TEST_GET_ALL_GAMES
    // for live testing, use the live url: URL_LIVE_GET_ALL_GAMES
    WCNetworkOperation *operation = [[WCNetworkOperation alloc] initWithURL: URL_TEST_GET_ALL_GAMES
                                                                requestType:WCNetworkRequestTypeAllGames];
    operation.target = target;
    operation.completeSelector = completeSelector;
    operation.errorSelector = errorSelector;
    
    [_operationQueue addOperation: operation ];
}

-(void) requestGroupResultsWithTarget: (id)target
                      completeHandler: (SEL)completeSelector
                         errorHandler: (SEL)errorSelector
{
    WCNetworkOperation *operation = [[WCNetworkOperation alloc] initWithURL: URL_TEST_GET_GROUP_RESULTS
                                                                requestType:WCNetworkRequestTypeGroupGameResult];
    operation.target = target;
    operation.completeSelector = completeSelector;
    operation.errorSelector = errorSelector;
    
    [_operationQueue addOperation: operation ];
}


@end
