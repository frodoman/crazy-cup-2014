//
//  WCNetworkManager.h
//  WorldCup
//
//  Created by XH Liu on 14/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WCNetworkManager : NSObject

@property(nonatomic, strong) NSOperationQueue *operationQueue;

+(WCNetworkManager*)sharedNetworkManager;

-(void) requestAllGamesWithTarget: (id)target
                  completeHandler: (SEL)completeSelector
                     errorHandler: (SEL)errorSelector;

-(void) requestGroupResultsWithTarget: (id)target
                  completeHandler: (SEL)completeSelector
                     errorHandler: (SEL)errorSelector;


@end
