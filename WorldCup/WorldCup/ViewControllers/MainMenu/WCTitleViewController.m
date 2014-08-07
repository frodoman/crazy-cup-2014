//
//  WCTitleViewController.m
//  WorldCup
//
//  Created by XH Liu on 22/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCTitleViewController.h"
#import "UIColor+WCColors.h"
#import "UIFont+WCFont.h"
#import <QuartzCore/QuartzCore.h>

@interface WCTitleViewController ()

@end

@implementation WCTitleViewController

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
    [self initLabels];
    [self initLayer];
    [self initPageController];
    
    [self addGestureEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Inits
-(void)initLabels
{
    self.labelTitle.textColor = [UIColor mainTextColor];
    self.labelTitle.font = [UIFont wcFont_H1];
}

-(void)initLayer
{
    self.view.layer.borderColor = [UIColor darkGreenColor].CGColor;
    self.view.layer.borderWidth = kWCViewBoarderWidth;
    self.view.layer.cornerRadius = 2.0f;
}

-(void)initPageController
{
    [self.pageController setPageIndicatorTintColor: [UIColor lightGrayColor]];
    [self.pageController setCurrentPageIndicatorTintColor:[UIColor lightGreenColor]];
}
-(void)addGestureEvents
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action: @selector(mainViewTapped:) ];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tap];
}


#pragma mark - Actions
-(void)mainViewTapped: (UITapGestureRecognizer*)tap
{
    if(self.target && self.onTapAction)
    {
        [self.target performSelectorOnMainThread: self.onTapAction
                                      withObject:nil  waitUntilDone:YES];
    }
}


@end
