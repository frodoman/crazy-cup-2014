//
//  WCMatchesViewController.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMatchesViewController.h"
#import "WCDataEntities.h"
#import "WCMatchCellViewCell.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import "WCMainMenuViewController.h"
#import "WCMatchDetailsViewController.h"
#import "WCViewController.h"
#import "WCUserSettings.h"
#import <QuartzCore/QuartzCore.h>

const NSUInteger kTableViewMaxCount = 6;

@interface WCMatchesViewController ()
@property(nonatomic) BOOL viewHasBeenShown;
@end

@implementation WCMatchesViewController

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
    
    
    self.mainScrollView.delegate = self;
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
       [self initTableViews];

        self.viewHasBeenShown = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark - Call back

-(void)showLatestInformation
{
    [self showLatestMatches];
}

-(void)showLatestMatches
{
    NSUInteger latestMatchID = [WCDataEntities sharedDataManager].allGames.latestMatchID;
    NSUInteger latestMatchSection = [WCDataEntities sharedDataManager].allGames.latestMatchSection;
    
    [self.mainScrollView scrollRectToVisible: CGRectMake(320.0f*latestMatchSection,
                                                         0,
                                                         320.0f,
                                                         self.mainScrollView.frame.size.height)
                                    animated:YES];
    
    if(latestMatchSection<self.tableViews.count)
    {
        UITableView *targetTable = [self.tableViews objectAtIndex: latestMatchSection];
        NSIndexPath *indexPath = [self findIndexPathForMatchID: latestMatchID tableViewIndex: latestMatchSection];
        [targetTable scrollToRowAtIndexPath: indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self.mainMenuController setSelectedPageWithIndex: latestMatchSection];
    [self.mainMenuController updateTitle:[self titleByPageIndex: latestMatchSection]];
    
}

-(NSIndexPath*)findIndexPathForMatchID: (NSUInteger)matchID
                        tableViewIndex: (NSUInteger)tableViewIndex
{
    NSArray* sectionArray = nil;
    switch (tableViewIndex)
    {
            //group games
        case 0:
            sectionArray = [WCDataEntities sharedDataManager].allGames.groupGames.sectionBySameDays;
            break;
        case 1:
            sectionArray = [WCDataEntities sharedDataManager].allGames.eighthFinalGames.sectionBySameDays;
            break;
        case 2:
            sectionArray = [WCDataEntities sharedDataManager].allGames.quarterFinalGames.sectionBySameDays;
            break;
        case 3:
            sectionArray = [WCDataEntities sharedDataManager].allGames.semiFinalGames.sectionBySameDays;
            break;
        case 4:
            sectionArray = [WCDataEntities sharedDataManager].allGames.thirdPlaceGame.sectionBySameDays;
            break;
        case 5:
            sectionArray = [WCDataEntities sharedDataManager].allGames.finalGame.sectionBySameDays;
            break;
            
        default:
            break;
    }
    
    NSUInteger foundSectionCount = 0;
    NSUInteger foundRowCount = 0;
    BOOL found = NO;
    
    if(sectionArray && sectionArray.count>0)
    {
        for(NSUInteger sectionCount=0; sectionCount<sectionArray.count; sectionCount++)
        {
            NSArray *matchInSameDay = [sectionArray objectAtIndex: sectionCount];
            for (NSUInteger rowCount = 0; rowCount<matchInSameDay.count; rowCount++)
            {
                OneMatch *aMatch = [matchInSameDay objectAtIndex: rowCount];
                if(aMatch.itemID == matchID)
                {
                    foundSectionCount = sectionCount;
                    foundRowCount = rowCount;
                    found = YES;
                    break;
                }
            }
            if(found)
            {
                break;
            }
        }
 
    }
    
    return [NSIndexPath indexPathForRow: foundRowCount inSection:foundSectionCount];

}


-(void)updateTitleAndPageController
{
    [self initPageController];
    [self scrollViewDidEndDecelerating: self.mainScrollView];
    
    
}

#pragma mark - Inits

-(void)initTableViews
{
    self.tableViews = [NSMutableArray array];
    
    CGRect viewFrame = CGRectMake(kWCSpaceBetweenViews, kWCSpaceBetweenViews,
                                  self.mainScrollView.frame.size.width - kWCSpaceBetweenViews*2.0f,
                                  self.mainScrollView.frame.size.height - kWCSpaceBetweenViews*2.0f);
    
    for(NSUInteger tableIndex = 0; tableIndex< kTableViewMaxCount; tableIndex++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:viewFrame style: UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = tableIndex;
        tableView.layer.cornerRadius = kWCViewCornerRadius;
        tableView.layer.borderColor = [UIColor mainBorderColor].CGColor;
        tableView.separatorColor = [UIColor clearColor];
        
        viewFrame = CGRectOffset(viewFrame, self.mainScrollView.frame.size.width, 0);
        
        [self.tableViews addObject: tableView ];
        
        [self.mainScrollView addSubview: tableView ];
    }
    
    // scroll View
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width* kTableViewMaxCount, self.mainScrollView.frame.size.height);
    self.mainScrollView.pagingEnabled = YES;
}

-(void)initPageController
{
        if(self.mainMenuController)
        {
            [self.mainMenuController setNumberOfPages: kTableViewMaxCount ];
            [self.mainMenuController showPageIndicator: YES ];
        }
}


#pragma mark - UITableView Delegate & Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* sectionArray = nil;// rowsCount = 1;
    switch (tableView.tag)
    {
            //group games
        case 0:
            sectionArray = [WCDataEntities sharedDataManager].allGames.groupGames.sectionBySameDays;
            break;
        case 1:
            sectionArray = [WCDataEntities sharedDataManager].allGames.eighthFinalGames.sectionBySameDays;
            break;
        case 2:
            sectionArray = [WCDataEntities sharedDataManager].allGames.quarterFinalGames.sectionBySameDays;
            break;
        case 3:
            sectionArray = [WCDataEntities sharedDataManager].allGames.semiFinalGames.sectionBySameDays;
            break;
        case 4:
            sectionArray = [WCDataEntities sharedDataManager].allGames.thirdPlaceGame.sectionBySameDays;
            break;
        case 5:
            sectionArray = [WCDataEntities sharedDataManager].allGames.finalGame.sectionBySameDays;
            break;
            
        default:
            break;
    }
    
    if(sectionArray && sectionArray.count>0)
    {
        if(section < sectionArray.count)
        {
            NSArray *matchInSameDay = [sectionArray objectAtIndex: section ];
            return  matchInSameDay.count;
        }
    }
    return  0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger rowsCount = 1;
    switch (tableView.tag)
    {
            //group games
        case 0:
            rowsCount = [WCDataEntities sharedDataManager].allGames.groupGames.sectionBySameDays.count;
            break;
        case 1:
            rowsCount = [WCDataEntities sharedDataManager].allGames.eighthFinalGames.sectionBySameDays.count;
            break;
        case 2:
            rowsCount = [WCDataEntities sharedDataManager].allGames.quarterFinalGames.sectionBySameDays.count;
            break;
        case 3:
            rowsCount = [WCDataEntities sharedDataManager].allGames.semiFinalGames.sectionBySameDays.count;
            break;
        case 4:
            rowsCount = [WCDataEntities sharedDataManager].allGames.thirdPlaceGame.sectionBySameDays.count;
            break;
        case 5:
            rowsCount = [WCDataEntities sharedDataManager].allGames.finalGame.sectionBySameDays.count;
            break;
            
        default:
            break;
    }
    
    return rowsCount;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray* dayArray = nil;
    switch (tableView.tag)
    {
            //group games
        case 0:
            dayArray = [WCDataEntities sharedDataManager].allGames.groupGames.dayArray;
            break;
        case 1:
            dayArray = [WCDataEntities sharedDataManager].allGames.eighthFinalGames.dayArray;
            break;
        case 2:
            dayArray = [WCDataEntities sharedDataManager].allGames.quarterFinalGames.dayArray;
            break;
        case 3:
            dayArray = [WCDataEntities sharedDataManager].allGames.semiFinalGames.dayArray;
            break;
        case 4:
            dayArray = [WCDataEntities sharedDataManager].allGames.thirdPlaceGame.dayArray;
            break;
        case 5:
            dayArray = [WCDataEntities sharedDataManager].allGames.finalGame.dayArray;
            break;
            
        default:
            break;
    }
 
    
    if( section <dayArray.count)
    {
        NSDate *theDate = [dayArray objectAtIndex: section];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        
        NSString *strFormat = @"dd MMM yyyy";
        if( [WCUserSettings systemLanguageInChinese ])
        {
            strFormat = @"yyyy MM dd";
        }
        [formater setDateFormat: strFormat];
        
        NSString *strDate = [formater stringFromDate: theDate];
        return strDate;
    }
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *text = [self tableView:tableView titleForHeaderInSection: section];
 
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, tableView.bounds.size.width, 22)] ;
 
    headerView.backgroundColor = [UIColor mainNavigationBarColor];
    
    headerView.text = text;
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.font = [UIFont wcFont_H2];
    headerView.textColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, 26)];
    
    bgView.backgroundColor = [UIColor mainNavigationBarColor];
    [bgView addSubview: headerView ];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWCMatchCellHeight;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [self cellIdentityForTableView:tableView]];
    
    if(cell == nil)
    {
        cell = [[WCMatchCellViewCell alloc] initWithOneMatchData:
                [self matchDataForTableView:tableView indexPath:indexPath]];
    }
    
    return cell;
}

-(OneMatch*)matchDataForTableView: (UITableView*)tableView indexPath: (NSIndexPath*)indexPath
{
    OneMatch  *matchData = nil;
    
    NSArray* sectionArray = nil;// rowsCount = 1;
    switch (tableView.tag)
    {
            //group games
        case 0:
            sectionArray = [WCDataEntities sharedDataManager].allGames.groupGames.sectionBySameDays;
            break;
        case 1:
            sectionArray = [WCDataEntities sharedDataManager].allGames.eighthFinalGames.sectionBySameDays;
            break;
        case 2:
            sectionArray = [WCDataEntities sharedDataManager].allGames.quarterFinalGames.sectionBySameDays;
            break;
        case 3:
            sectionArray = [WCDataEntities sharedDataManager].allGames.semiFinalGames.sectionBySameDays;
            break;
        case 4:
            sectionArray = [WCDataEntities sharedDataManager].allGames.thirdPlaceGame.sectionBySameDays;
            break;
        case 5:
            sectionArray = [WCDataEntities sharedDataManager].allGames.finalGame.sectionBySameDays;
            break;
            
        default:
            break;
    }
    
    
    if(indexPath.section < sectionArray.count)
    {
        NSArray *matchInSameDay = [sectionArray objectAtIndex: indexPath.section];
        
        if(indexPath.row < matchInSameDay.count)
        {
            matchData = [matchInSameDay objectAtIndex: indexPath.row];
        }
    }
    return matchData;
 
}

-(NSString*)cellIdentityForTableView: (UITableView*)tableView
{
    NSString * cellID = @"";
    switch (tableView.tag)
    {
        case 0:
            cellID = @"GroupGameCell";
            break;
        case 1:
            cellID = @"Round16GameCell";
            break;
        case 2:
            cellID = @"QuaterGameCell";
            break;
        case 3:
            cellID = @"SemiGameCell";
            break;
        case 4:
            cellID = @"ThirdGameCell";
            break;
        case 5:
            cellID = @"FinalGameCell";
            break;
        default:
            break;
    }
    
    return cellID;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneMatch *matchData = [self matchDataForTableView:tableView indexPath:indexPath];
    
    WCMatchDetailsViewController *detailsController = [[WCMatchDetailsViewController alloc] initWithMatchData: matchData];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsController];
    
    
    [self.rootController presentViewController: navController animated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //find the page index
    NSUInteger iIndex = (NSUInteger)(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width);
    
    if(iIndex>= kTableViewMaxCount)
    {
        return;
    }
    
    NSString *newTitle = [self titleByPageIndex: iIndex];
    
    if(self.mainMenuController)
    {
        [self.mainMenuController updateTitle: newTitle ];
        [self.mainMenuController setSelectedPageWithIndex: iIndex];
    }
 
}

-(NSString*)titleByPageIndex: (NSUInteger)pageIndex
{
    NSString *title = nil;
    
    if(pageIndex>=kTableViewMaxCount )
    {
        return nil;
    }
    
    switch (pageIndex) {
        case 0:
            title = NSLocalizedString(@"Group Matches", nil);
            break;
        case 1:
            title = NSLocalizedString(@"Round 16 Matches", nil);
            break;
        case 2:
            title = NSLocalizedString(@"Quater Final Matches", nil);
            break;
        case 3:
            title = NSLocalizedString(@"Semi Final Matches", nil);
            break;
        case 4:
            title = NSLocalizedString(@"Third Place Match", nil);
            break;
        case 5:
            title = NSLocalizedString(@"Final Match", nil);
            break;
        default:
            break;
    }
    return title;
}

@end
