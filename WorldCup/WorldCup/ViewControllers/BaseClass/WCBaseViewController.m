//
//  WCBaseViewController.m
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import "ILTranslucentView.h"
#import "WCMainMenuViewController.h"
#import "WCAppDelegate.h"
#import "WCViewController.h"
#import "WCWaitingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WCBaseViewController ()

@end

@implementation WCBaseViewController

-(id)initWithDefaultNib
{
    self = [super initWithNibName: NSStringFromClass([self class]) bundle:nil];
    if(self)
    {
        
    }
    
    return self;
}

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
	// Do any additional setup after loading the view.
    
    WCAppDelegate *app = [UIApplication sharedApplication].delegate;
    self.rootController = (WCViewController*)app.window.rootViewController;
    
    self.mainMenuController = self.rootController.mainMenuController;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.viewHasBeenShown = YES;
}


#pragma mark - Public
-(void)startWaiting
{

}

-(void)stopWaiting
{

}

-(void)addBackgroundViewWithColor: (UIColor*)tintColor
{
    
}

-(void)updateTitleAndPageController
{
    
}

-(void)showLatestInformation
{
    
}


-(void)addCloseButtonToNavigationBar
{
    UIBarButtonItem *bnClose = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Close", nil)
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:) ];
    self.navigationItem.rightBarButtonItem = bnClose;
}

-(void)closeButtonTapped: (id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES  completion:nil];
}

//TODO: ...
-(void)setTranslusionEffectWithColor: (UIColor*)color
{

    UIToolbar *bgView = [[UIToolbar alloc] initWithFrame: self.view.bounds ];
    bgView.tintColor = color;
    
    NSArray *subViews = self.view.subviews;
    if(subViews.count>0)
    {
        UIView *lastView = [subViews lastObject];
        [self.view insertSubview: bgView belowSubview:  lastView];
    }
    else
    {
        [self.view addSubview: bgView];
    }
}

-(UIView*)translusionBackgroundViewWithColor : (UIColor*)color
{
    UIToolbar *bgView = [[UIToolbar alloc] initWithFrame: self.view.bounds ];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.tintColor = [UIColor whiteColor];
    bgView.alpha = 0.6f;
    
    return bgView;
}


-(void) initViewControllers
{
    
}

@end
