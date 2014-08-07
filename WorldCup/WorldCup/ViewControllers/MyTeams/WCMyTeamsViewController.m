//
//  WCMyTeamsViewController.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMyTeamsViewController.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import "WCUserSettings.h"
#import "WCDataEntities.h"
#import "UIImage+WCImage.h"
#import "UIFont+WCFont.h"
#import "WCMainMenuViewController.h"
#import "WCFavouriteButtonViewController.h"
#import "WCMatchArrayViewController.h"
#import "WCViewController.h"
#import "WCTitleViewController.h"

NSUInteger const kTableViewTeamsMaxCount = 2;
NSInteger  const kTableViewTagAllTeams = 0;
NSInteger  const kTableViewTagFavouritedTeams = 1;

@interface WCMyTeamsViewController ()
@property(nonatomic, strong) NSMutableArray *favouritedButtons;
@property(nonatomic) NSUInteger currentPageIndex;

@end

@implementation WCMyTeamsViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if(!self.viewHasBeenShown)
    {
        [self initTableViews];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)updateTitleAndPageController
{
    [self initTitleView];
    [self scrollViewDidEndDecelerating: self.mainScrollView];
}


#pragma mark - Inits

-(void)addGestureEventToScrollView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScrollViewTapped:) ];
    
    tap.numberOfTapsRequired = 1;
    [self.mainScrollView addGestureRecognizer: tap];
    
}

-(void)initTitleView
{
    [self.mainMenuController showPageIndicator: YES];
    [self.mainMenuController  setNumberOfPages: kTableViewTeamsMaxCount];
}


-(void)initTableViews
{
    self.tableViews = [NSMutableArray array];
    
    CGRect viewFrame = CGRectMake(kWCSpaceBetweenViews, kWCSpaceBetweenViews,
                                  self.mainScrollView.frame.size.width - kWCSpaceBetweenViews*2.0f,
                                  self.mainScrollView.frame.size.height - kWCSpaceBetweenViews*2.0f);
    
    for(NSUInteger tableIndex = 0; tableIndex< kTableViewTeamsMaxCount; tableIndex++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame: viewFrame ];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = tableIndex;
        tableView.layer.cornerRadius = kWCViewCornerRadius;
        tableView.layer.borderColor = [UIColor mainBorderColor].CGColor;
        //tableView.separatorColor = [UIColor clearColor];
        
        viewFrame = CGRectOffset(viewFrame, self.mainScrollView.frame.size.width, 0);
        
        [self.tableViews addObject: tableView ];
        
        [self.mainScrollView addSubview: tableView ];
    }
    
    // scroll View
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width* kTableViewTeamsMaxCount,
                                                 self.mainScrollView.frame.size.height);
    self.mainScrollView.pagingEnabled = YES;
}

#pragma mar - Actions
-(void)mainScrollViewTapped: (UITapGestureRecognizer*  )tap
{
    NSUInteger viewIndex = [self.mainMenuController currentPageIndex];
    
    UITableView *tableView = nil;
    if(viewIndex< self.tableViews.count)
    {
        tableView = [self.tableViews objectAtIndex: viewIndex];
    }
    if(tableView)
    {
        CGPoint pLocation = [tap locationInView: tableView];
        NSUInteger cellIndex = pLocation.y / kWCOneTeamCellHeight;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UITableViewCell *selectedCell = nil;
        for(NSUInteger sectionIndex = 0; sectionIndex<tableView.numberOfSections; sectionIndex++)
        {
            for(NSUInteger rowIndex = 0; rowIndex<[tableView numberOfRowsInSection: sectionIndex]; rowIndex++)
            {
                indexPath = [NSIndexPath indexPathForItem: rowIndex inSection:sectionIndex];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath ];
                
                if(CGRectContainsPoint( cell.frame, pLocation))
                {
                    cellIndex = cell.tag;
                    selectedCell = cell;
                    NSLog(@"Cell Index: %ld, Frame: %@", cell.tag, NSStringFromCGRect( cell.frame));
                    break;
                }
                
                
            }
        }
        [self tableView: tableView didSelectRowAtIndexPath: indexPath];
 
    }
    
    
    
}

-(void)tableView:(UITableView*)tableView tappedOnCell: (UITableViewCell*)theCell
{
    
}

#pragma mark - UITableView Delegate & Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = 1;
    switch (tableView.tag)
    {
            //all teams
        case kTableViewTagAllTeams:
            rowsCount =  kWCNumberOfTeamsInOneGroup;
            break;
            //favourited teams
        case kTableViewTagFavouritedTeams:
        {
            NSArray *teams = [WCUserSettings favouritedTeams];
            if(teams)
            {
                rowsCount = teams.count;
            }
            else
            {
                rowsCount = 0;
            }
            break;
        }
            
        default:
            break;
    }
    
    return rowsCount;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = NSLocalizedString(@"Group", nil);
    NSString *returnTitle = nil;
    switch (tableView.tag) {
        case kTableViewTagAllTeams:
        {
            returnTitle = [title stringByAppendingFormat:@" %c", (char)((int)'A' + (int)section)];
            break;
        }
        case kTableViewTagFavouritedTeams:
        {
            break;
        }
        default:
            break;
    }
    return returnTitle;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    switch (tableView.tag)
    {
            //all teams
        case kTableViewTagAllTeams:
            sections =  kWCNumberOfAllTeams/kWCNumberOfTeamsInOneGroup;
            break;
            //favourited teams
        case kTableViewTagFavouritedTeams:
        {
            break;
        }
            
        default:
            break;
    }
    return sections;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWCOneTeamCellHeight;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [self cellIdentityForTableView:tableView]];
    
    if(cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: [self cellIdentityForTableView: tableView]];
    }
    
    //init the cell
    cell.textLabel.font = [UIFont wcFont_H2];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor mainTextColor];
    
    switch (tableView.tag)
    {
        case kTableViewTagAllTeams:
        {
            NSUInteger cellIndex = indexPath.section *kWCNumberOfTeamsInOneGroup + indexPath.row;
            cell.tag = cellIndex;
            
            if(cellIndex< kWCNumberOfAllTeams)
            {
                NSArray *teams = [WCUserSettings allTeams];
                OneTeam *aTeam = [teams objectAtIndex: cellIndex];
                
                [self updateCellDataWithTeam: aTeam forCell:cell];
                [self addFavouriteButtonToCell: cell];
            }
            break;
        }
        case kTableViewTagFavouritedTeams:
        {
            NSArray *fTeams = [WCUserSettings favouritedTeams];
            if(fTeams)
            {
                OneTeam *aTeam = [fTeams objectAtIndex: indexPath.row];
                [self updateCellDataWithTeam:aTeam forCell:cell];
            }
            
            break;
        }
        default:
            break;
    }
    
    
    return cell;
}

-(void)addFavouriteButtonToCell: (UITableViewCell*)theCell
{
    WCFavouriteButtonViewController *bnController = [[WCFavouriteButtonViewController alloc  ] initWithDefaultNib];
    bnController.view.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    bnController.view.tag = theCell.tag;
    
    if(self.favouritedButtons == nil)
    {
        self.favouritedButtons = [NSMutableArray array];
    }
    
    [self.favouritedButtons addObject: bnController];
    
    theCell.accessoryView = bnController.view;
}

-(void)updateCellDataWithTeam:(OneTeam*)teamData forCell: (UITableViewCell*)targetCell
{
    targetCell.imageView.image = [UIImage imageForTeam: teamData.teamName];
    targetCell.textLabel.text = NSLocalizedString( teamData.teamName, nil);
}



-(NSString*)cellIdentityForTableView: (UITableView*)tableView
{
    NSString * cellID = @"";
    switch (tableView.tag)
    {
            //all teams
        case kTableViewTagAllTeams:
            cellID =   @"AllTeamsCell";
            break;
            //favourited teams
        case kTableViewTagFavouritedTeams:
        {
            cellID = @"FavouritedTeamsCell";
            break;
        }
            
        default:
            break;
    }
    
    return cellID;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    NSString *teamName = nil;
    
    switch (tableView.tag)
    {
        case kTableViewTagAllTeams:
        {
            NSUInteger cellIndex = indexPath.section *kWCNumberOfTeamsInOneGroup + indexPath.row;
            
            if(cellIndex< kWCNumberOfAllTeams)
            {
                NSArray *teams = [WCUserSettings allTeams];
                OneTeam *aTeam = [teams objectAtIndex: cellIndex];
                teamName  = aTeam.teamName;
            }
            break;
        }
        case kTableViewTagFavouritedTeams:
        {
            NSArray *fTeams = [WCUserSettings favouritedTeams];
            if(fTeams)
            {
                OneTeam *aTeam = [fTeams objectAtIndex: indexPath.row];
                teamName = aTeam.teamName;
            }
            
            break;
        }
        default:
            break;
    }
    
    if(teamName)
    {
        WCMatchArrayViewController *vController = [[WCMatchArrayViewController alloc] initWithTeamName:teamName];
        //vController.title = teamName;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: vController ];
        navController.navigationBar.backgroundColor = [UIColor mainNavigationBarColor];
        
        [self.rootController presentViewController:navController animated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //find the page index
    NSUInteger iIndex = (NSUInteger)(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width);
    
    if(iIndex>= kTableViewTeamsMaxCount)
    {
        return;
    }
    
    NSString *newTitle = [self titleByPageIndex: iIndex];
    
    if(self.mainMenuController)
    {
        [self.mainMenuController updateTitle: newTitle ];
        [self.mainMenuController setSelectedPageWithIndex: iIndex];
    }
    
    [[self.tableViews objectAtIndex: iIndex] becomeFirstResponder];
    [[self.tableViews objectAtIndex: kTableViewTeamsMaxCount-1] reloadData];
 
}

-(NSString*)titleByPageIndex: (NSUInteger)pageIndex
{
    NSString *title = nil;
    
    if(pageIndex>=kTableViewTeamsMaxCount )
    {
        return nil;
    }
    
    switch (pageIndex) {
        case kTableViewTagAllTeams:
            title = NSLocalizedString(@"Group", nil);
            break;
        case kTableViewTagFavouritedTeams:
            title = NSLocalizedString(@"Favourited Teams", nil);
            break;
        default:
            break;
    }
    return title;
}


@end
