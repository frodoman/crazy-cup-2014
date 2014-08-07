//
//  WCViewController.m
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCViewController.h"
#import "WCNetworkManager.h"
#import "WCMainMenuViewController.h"
#import "WorldCup-Prefix.pch"
#import "NSObject+Consts.h"
#import "ILTranslucentView.h"
#import "WCIAdViewController.h"
#import "UIColor+WCColors.h"
#import "WCWaitingViewController.h"

@interface WCViewController ()

@property(nonatomic, strong) NSDate *requestAtTime;
@property(nonatomic) BOOL gotAllGamesData;

@end

@implementation WCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initColors];
    [WCUserSettings setAppHasBeenOpenedCount];
    
    [self startWaiting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static BOOL hasDoneThis = NO;
    if(!hasDoneThis)
    {
        
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static BOOL hasDoneThis = NO;
    if(!hasDoneThis)
    {
        self.requestAtTime = [NSDate date];
        [[WCNetworkManager sharedNetworkManager] requestAllGamesWithTarget:self
                                                           completeHandler: @selector(requestAllGamesFinished)
                                                              errorHandler: @selector(requestAllGamesFailed)];
        
        hasDoneThis = YES;
        
        //make sure the waiting animation has played for 2 seconds
        [self performSelector:@selector(initAllForFirstTimeDisplay) withObject:nil afterDelay:3.0f];
    }
    else
    {
        if([WCWaitingViewController sharedController].view.superview)
        {
            [[WCWaitingViewController sharedController].view removeFromSuperview];
        }
    }
}

#pragma mark - Networking

-(void)requestAllGamesFinished
{
    self.gotAllGamesData = YES;
}

-(void)requestAllGamesFailed
{
    [[WCWaitingViewController sharedController] showErrorMessage];
}


#pragma mark - Inits

-(void)initAllForFirstTimeDisplay
{
    if(self.gotAllGamesData)
    {
        [self stopWaiting];
        //init the contents
        [self initViewControllers];
        [self initNavigationBar];
        
        [self animateToShowContents];
        
        [self animateToShowIAdView];
    }
    else
    {
        [self performSelector:@selector(initAllForFirstTimeDisplay) withObject:nil afterDelay:0.3f];
    }
}

-(void)initNavigationBar
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont wcFont_H1], NSFontAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}


-(void)initColors
{
    self.view.backgroundColor = [UIColor lightGreenColor];
}

-(void)initViewControllers
{
    BOOL showIAd = [NSObject shouldShowIAd];
    CGFloat iAdHeight = kWCIAdViewHeight;
    if(!showIAd)
    {
        iAdHeight = 0.0f;
    }
    
    self.mainMenuController = [[WCMainMenuViewController alloc ] initWithDefaultNib ];
    self.mainMenuController.view.frame = CGRectMake(0, 0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height - iAdHeight );
    
    [self.view addSubview: self.mainMenuController.view ];
    
    if( showIAd)
    {
        self.iAdController = [[WCIAdViewController alloc] initWithDefaultNib];
        self.iAdController.view.frame = CGRectMake(0,
                                                   self.view.frame.size.height - kWCIAdViewHeight,
                                                   self.view.frame.size.width,  kWCIAdViewHeight);
        [self.view addSubview: self.iAdController.view];
        self.iAdController.view.alpha = 0.0f;
    }
    
}

-(void)showIAdView
{
    // don't show this when the presentation view is displayed
    // before the iAd is shown
    if(self.mainMenuController.showingPresentationView ||
       self.mainMenuController.animationHappening)
    {
        
        return;
    }
    
    if(self.showingIAdView)
    {
        return;
    }
    
    BOOL showIAd = [NSObject shouldShowIAd];
    if(!showIAd)
    {
        return;
    }
    
    if( showIAd)
    {
        self.iAdController = [[WCIAdViewController alloc] initWithDefaultNib];
        self.iAdController.view.frame = CGRectMake(0,
                                                   self.view.frame.size.height - kWCIAdViewHeight,
                                                   self.view.frame.size.width,  kWCIAdViewHeight);
        [self.view addSubview: self.iAdController.view];
        self.iAdController.view.alpha = 0.0f;
    }
    
    CGRect mainViewFrame = self.mainMenuController.view.frame;
    self.mainMenuController.view.frame = CGRectMake(mainViewFrame.origin.x, mainViewFrame.origin.y,
                                                    mainViewFrame.size.width,
                                                    mainViewFrame.size.height - kWCIAdViewHeight);
    
    [self animateToShowIAdView];
}

#pragma mark - Animations

-(void)animateToShowContents
{
 
}

-(void)animateToShowIAdView
{
    CGRect iAdFrame = self.iAdController.view.frame;
 
    
    self.iAdController.view.frame = CGRectOffset(iAdFrame, 0, kWCIAdViewHeight);
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                          delay:kWCAnimationDurationInSeconds4x
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.iAdController.view.alpha =1.0f;
                         self.iAdController.view.frame = iAdFrame;
                        
                     }
                     completion:^(BOOL finished){
                     if(finished)
                     {
                         self.showingIAdView = YES;
                     }
                     
                     }];
}

-(void)startWaiting
{
    WCWaitingViewController *controller = [WCWaitingViewController sharedController];
    controller.view.frame = self.view.bounds;
    controller.view.alpha = 1.0f;
    
    [self.view addSubview: controller.view];
 
}

-(void)stopWaiting
{
    WCWaitingViewController *controller = [WCWaitingViewController sharedController];
    
    [controller stopWaitingAnimation];
    
}


@end
