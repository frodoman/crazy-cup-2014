//
//  WCNetworkOperation.m
//  WorldCup
//
//  Created by XH Liu on 14/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCNetworkOperation.h"
#import "NSObject+Consts.h"
#import "WCDataEntities.h"

const CGFloat kXTNetworkTimeoutTimeInSeconds = 39.0f;


@interface WCNetworkOperation()
{
    NSURLConnection *_urlConnection;
}

@property (readwrite) BOOL isExecuting;
@property (readwrite) BOOL isFinished;
@property (readwrite) BOOL wasSuccessful;

@end

@implementation WCNetworkOperation

+ (BOOL) automaticallyNotifiesObserversForKey: (NSString *) key {
    
    // We're lazy, so let Cocoa do all the KVO grooviness for these
    // attributes.
    if ([key isEqualToString: @"isFinished"]
        || [key isEqualToString:@"isExecuting"]) {
        return YES;
        
    } else {
        // Otherwise do whatever NSOperation does.
        return [super automaticallyNotifiesObserversForKey: key];
    }
    
} // automaticallyNotifiesObserversForKey

-(id) initWithURL: (NSURL*)theUrl
      requestType: (WCNetworkRequestType)requestType
{
    self = [super init];
    if(self)
    {
        self.urlOfRequest = theUrl;
        self.requestType = requestType;
        
    }
    return self;
}

-(void) start
{
    // Avoid unnecessary work.
    if (self.isCancelled)
    {
        return;
    }
    
    // In 10.6, all NSOperations are run on a thread.  NSURLConnection is
    // runloop based, and the thread that we are initially kick off the connect
    // with might disappear, courtesy of GCD, before we finish the loading
    // operation.
    // So we force the run of ourselves on the main thread, which we know will
    // stick around, and glom on to its runloop to run NSURLConnection.
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread: @selector(start)
                               withObject: nil
                            waitUntilDone: NO];
        return;
    }
    
    // Since we've started, we're executing.
    self.isExecuting = YES;
    
    // Build a request to fetch the json data
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlOfRequest
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval: kXTNetworkTimeoutTimeInSeconds];
    
    
    self.responseData = [NSMutableData data];
    
    _urlConnection = [[NSURLConnection alloc] initWithRequest: request
                                                     delegate: self];
    [_urlConnection start];
    [self startCheckingTimeout];
    
}

#pragma mark - KVO methods
- (void) done {
    _urlConnection = nil;
    
    self.isExecuting = NO;
    self.isFinished = YES;
    
    //avoid to fire the time out event after the operation is finished.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleRequestTimeout) object:nil];
}

-(void) cancel
{
    [_urlConnection cancel];
    self.responseData = nil;
    
    [self done ];
    
    [super cancel];
}

#pragma mark - NSURLConnectionDelegate
- (void) connection: (NSURLConnection *) c
 didReceiveResponse: (NSURLResponse *) response {
    
    // This can be called multple times (like for redirection),
    // so toss any accumulated data.
    
    [self.responseData setLength:0];
    
} // didReceiveResponse


- (void) connection: (NSURLConnection *) c
     didReceiveData: (NSData *) data {
    
    [self.responseData appendData: data];
    
} // didReceiveData


- (void) connection: (NSURLConnection *) c
   didFailWithError: (NSError *) error {
    
    self.responseData = nil;
    
    self.wasSuccessful = NO;
    [self done];
    
    if(self.target && self.errorSelector)
    {
        [self.target performSelectorOnMainThread: self.errorSelector withObject:nil waitUntilDone:YES];
    }
    
} // didFailWithError


- (void) connectionDidFinishLoading: (NSURLConnection *) c {
    
    self.wasSuccessful = YES;
    
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData: self.responseData
                                                               options:NSJSONReadingMutableLeaves error:&jsonError];
    if(jsonError)
    {
        if(self.target && self.errorSelector)
        {
            [self.target performSelectorOnMainThread:self.errorSelector
                                          withObject:jsonError
                                       waitUntilDone:YES];
        }
        [self done];
        return;
    }
    
    //we got the json result
    NSLog(@"Json Result: %@", jsonResult);
    
    [self handleJsonResult: jsonResult];
    
    if(self.target && self.completeSelector)
    {
        [self.target performSelectorOnMainThread: self.completeSelector
                                      withObject:nil
                                   waitUntilDone:YES];
    }
    
}

#pragma mark - Timeout

-(void) startCheckingTimeout
{
    [self performSelector:@selector(handleRequestTimeout) withObject:nil afterDelay:kXTNetworkTimeoutTimeInSeconds];
}

-(void)handleRequestTimeout
{
    if(self.isFinished)
    {
        return;
    }
    
    if(self.target && self.errorSelector)
    {
        [self.target performSelectorOnMainThread:self.errorSelector withObject:nil  waitUntilDone:YES];
    }
    
    [self cancel];
}


#pragma mark - Parsing Json

-(void) handleJsonResult: (NSDictionary*)jsonResult
{
    
    if(self.requestType == WCNetworkRequestTypeAllGames)
    {
        [self parseJsonAllGames:jsonResult];
    }
    else if (self.requestType == WCNetworkRequestTypeGroupGameResult)
    {
        [self parstJsonGroupResults: jsonResult];
    }
}

-(void) parseJsonAllGames: (id)jsonResult
{
    if(jsonResult == nil)
    {
        [self done];
        return;
    }
    NSDictionary *allGamesDic = [jsonResult objectForKey: kJsonKeyAllGames];
    if(allGamesDic == nil)
    {
        [self done];
        return;
    }
    
    // data manager
    WCDataEntities *dataManager = [WCDataEntities sharedDataManager];
    AllGames *allGameData = [[AllGames alloc ] initWithDictionary: allGamesDic ];
    
    dataManager.allGames = allGameData;
    [dataManager analyseGroupResults ];
    
    if(allGameData)
    {
        NSLog( @"AllGames.json: %@", allGameData);
    }
}

-(void)parstJsonGroupResults:(id)jsonResult
{
    
}

@end
