//
//  WCIAdViewController.m
//  WorldCup
//
//  Created by XH Liu on 23/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCIAdViewController.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import "UIFont+WCFont.h"
#import <QuartzCore/QuartzCore.h>

@interface WCIAdViewController ()

@end

@implementation WCIAdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initLayer];
    [self initLabels];
    [self initIAdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inits

-(void)initLayer
{
    self.view.layer.cornerRadius = kWCViewCornerRadius;
    self.view.layer.borderColor = [UIColor mainBorderColor].CGColor;
    self.view.layer.borderWidth = kWCViewBoarderWidth;
    
}
-(void)initLabels
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    self.labelVersion.text = nil;
    NSString *versionStr = [@"v" stringByAppendingString:version];
    
    
    NSString *footer = NSLocalizedString(@"Main Footer info", nil);
    self.labelMessage.text = [footer stringByAppendingFormat:@"( %@ )", versionStr];
    
    self.labelMessage.numberOfLines =0;
    self.labelMessage.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.labelMessage.textColor = [UIColor mainTextColor];
    self.labelVersion.textColor = [UIColor mainTextColor];
    
    self.labelVersion.font = [UIFont wcFont_H3];
    self.labelMessage.font = [UIFont wcFont_H3];
}


-(void)initIAdView
{
    // On iOS 6 ADBannerView introduces a new initializer, use it when available.
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)])
    {
        self.iAdView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    }
    else
    {
        self.iAdView = [[ADBannerView alloc] init];
    }
    self.iAdView.delegate = self;
    self.iAdView.alpha = 0.0f;
    self.iAdView.frame = CGRectOffset(self.view.bounds, 0, kWCIAdViewHeight) ;
    [self.view addSubview: self.iAdView ];
    self.iAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    self.iAdView.layer.borderColor = [UIColor mainBorderColor].CGColor;
    self.iAdView.layer.cornerRadius = kWCViewCornerRadius;
    self.iAdView.layer.borderWidth = kWCViewBoarderWidth;
}


#pragma mark - Animations
-(void)hideIAd
{
    if(self.iAdView.alpha==0.0f)
    {
        return;
    }
    
    CGRect iAdFrame = CGRectMake(0, self.view.frame.size.height ,
                                 self.iAdView.frame.size.width, self.iAdView.frame.size.height);
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds2x
                     animations:^{
                         self.iAdView.frame = iAdFrame;
                         self.iAdView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         if(finished)
                         {
                             
                         }
                     }];
}


-(void) showIAd
{
    if(!self.iAdView.bannerLoaded || self.iAdView.alpha>0.0f)
    {
        return;
    }
    
    CGRect iAdFrame = CGRectMake(0, 0,
                                 self.iAdView.frame.size.width, self.iAdView.frame.size.height);
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                     animations:^{
                         self.iAdView.frame = CGRectOffset(iAdFrame, 0, -kWCSpaceBetweenViews*4.0f);
                         self.iAdView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         if(finished)
                         {
                            [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                                             animations:^{
                                                 self.iAdView.frame = iAdFrame;
                                             }];
                         }
                     }];
}

#pragma mark - iAd (ADBannerViewDelegate)

//change this to NO to make screen shots
-(BOOL)shouldShowIAd
{
    return YES;
    //return NO;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if([self shouldShowIAd])
    {
        [self showIAd];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog( @"Could not load iAd: %@", error.debugDescription);
    [self hideIAd];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"bannerViewActionShouldBegin");
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerViewActionDidFinish");
}

@end
