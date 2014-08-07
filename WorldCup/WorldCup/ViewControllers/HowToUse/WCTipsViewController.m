//
//  WCTipsViewController.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCTipsViewController.h"
#import "WCOneTipViewController.h"
#import "WorldCup-Prefix.pch"

@interface WCTipsViewController ()

@end

@implementation WCTipsViewController

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
    [self initUIs];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"How to use", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if(!self.viewHasBeenShown)
    {
        [self initViewControllers];
        [self initPageController];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self scrollViewDidEndDecelerating:self.mainScrollView  ];

}


#pragma mark - Inits
-(void)initUIs
{
    self.title = NSLocalizedString(@"How to use", nil);
    self.view.backgroundColor = [UIColor mainNavigationBarColor];
    
    self.labelMessage.font = [UIFont wcFont_H1];
    self.labelMessage.textColor = [UIColor whiteColor];
    
    self.mainScrollView.backgroundColor = [UIColor clearColor];
}

-(void)initViewControllers
{
    CGFloat viewWidth =self.mainScrollView.frame.size.width/2.0f;
    CGRect frameStart = CGRectMake(viewWidth/2.0f, 0,
                                   viewWidth,
                                   self.mainScrollView.frame.size.height);
    
    NSArray *tips = [self tipsTitleIDs];
    
    self.tipsControllers = [NSMutableArray array];
    for(NSUInteger viewIndex = 0; viewIndex<tips.count; viewIndex++)
    {
        WCOneTipViewController *tipController = [[WCOneTipViewController alloc] initWithNibName: [tips objectAtIndex:viewIndex] bundle:nil];
        tipController.view.frame = frameStart;
        tipController.view.layer.borderWidth = 1.0f;
        tipController.view.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.mainScrollView addSubview: tipController.view];
        [self.tipsControllers addObject: tipController];
        
        frameStart = CGRectOffset(frameStart, self.mainScrollView.frame.size.width, 0);
    }
    
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width*tips.count,
                                                 self.mainScrollView.frame.size.height);
    
}

-(void)initPageController
{
    [self.pageController setNumberOfPages: [self tipsTitleIDs].count];
    
}

-(NSArray*)tipsTitleIDs
{
    NSArray *array = [NSArray arrayWithObjects: @"Tips_0",@"Tips_1",@"Tips_2",@"Tips_3",@"Tips_4", nil];
    return array;
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger iIndex = (NSUInteger)(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width);
    
    //update the page indicator
    [self.pageController setCurrentPage: iIndex];
    
    //update the message
    NSString *msgID = [[self tipsTitleIDs] objectAtIndex: iIndex];
    self.labelMessage.text = NSLocalizedString(msgID, nil);
    
}


@end
