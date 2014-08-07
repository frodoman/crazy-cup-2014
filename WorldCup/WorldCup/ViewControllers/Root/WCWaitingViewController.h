//
//  WCWaitingViewController.h
//  WorldCup
//
//  Created by XH Liu on 03/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WCWaitingViewController : WCBaseViewController

@property(nonatomic, strong )IBOutlet UILabel *labelMessage;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewError;

@property(nonatomic) NSUInteger animationCount;
@property(nonatomic) BOOL firstAnimationFinished;

@property(nonatomic)BOOL stopAnimatingTeamLogos;

+(WCWaitingViewController*)sharedController;

-(void)startWaitingAnimation;
-(void)stopWaitingAnimation;
-(void)showErrorMessage;

-(void)showFirstAnimation;
-(void)showWaitingAnimation;

@end
