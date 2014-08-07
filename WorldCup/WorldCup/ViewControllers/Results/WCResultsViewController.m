//
//  WCResultsViewController.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCResultsViewController.h"
#import "NSObject+Consts.h"
#import "WCDataEntities.h"
#import "WCOneGroupResultViewController.h"
#import "UIColor+WCColors.h"
#import "UIFont+WCFont.h"
#import "WCMainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

const  CGFloat kWCOneResultSubScrollViewHeight = 255.0f;
const  CGFloat kWCOneResultSubScrollViewContentWidth = 710.0f;


@interface WCResultsViewController ()

@end

@implementation WCResultsViewController

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
 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.viewHasBeenShown)
    {
        [self initScrollView];
        
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)updateTitleAndPageController
{
    [self.mainMenuController showPageIndicator:NO];
    [self.mainMenuController updateTitle:NSLocalizedString(@"Group Results", nil)];
    
}


#pragma mark - Inits
-(void)initTableView
{
    self.mainScrollView.layer.cornerRadius = kWCViewCornerRadius;
}

-(void)initScrollView
{
    NSUInteger groupCount = [OneTeam allTeams].count/ kWCNumberOfTeamsInOneGroup;
    NSString *groupNameStart = NSLocalizedString(@"Group", nil);
    
    CGRect subScrollViewFrame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, kWCOneResultSubScrollViewHeight);
    
    self.subScrollViews = [NSMutableArray array];
    for (NSUInteger groupIndex = 0; groupIndex<groupCount; groupIndex++)
    {
        NSString *groupName = [NSString stringWithFormat:@"%@ %c", groupNameStart, (char)((int)'A'+(int)groupIndex)];
        NSArray *teamsInOneGroup = [NSArray arrayWithObjects:
                                     ((OneTeam*)[[OneTeam allTeams] objectAtIndex: 0+groupIndex*4]).teamName,
                                     ((OneTeam*)[[OneTeam allTeams] objectAtIndex: 1+groupIndex*4]).teamName,
                                     ((OneTeam*)[[OneTeam allTeams] objectAtIndex: 2+groupIndex*4]).teamName,
                                     ((OneTeam*)[[OneTeam allTeams] objectAtIndex: 3+groupIndex*4]).teamName,nil];
        
        OneGroupResult *groupResutl = [[OneGroupResult alloc] initWithGroupName: groupName teams: teamsInOneGroup ];
        WCOneGroupResultViewController *groupResultController = [[WCOneGroupResultViewController alloc] initWithOneGroupResult: groupResutl ];
        groupResultController.view.frame =subScrollViewFrame;
        ((UIScrollView*)groupResultController.view).contentSize = CGSizeMake(kWCOneResultSubScrollViewContentWidth , kWCOneResultSubScrollViewHeight);
        
        [self.mainScrollView addSubview: groupResultController.view ];
        [groupResultController addTeamIamges];
        //[self.subScrollViews addObject: groupResultController ];
        
        subScrollViewFrame = CGRectOffset(subScrollViewFrame, 0, kWCOneResultSubScrollViewHeight+kWCSpaceBetweenViews);
    }
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width,
                                                 (kWCOneResultSubScrollViewHeight+kWCSpaceBetweenViews)*groupCount);
}



@end
