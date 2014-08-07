//
//  WCMatchArrayViewController.m
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMatchArrayViewController.h"
#import "WCDataEntities.h"
#import "UIFont+WCFont.h"
#import "UIColor+WCColors.h"
#import "NSObject+Consts.h"
#import "WCMatchCellViewCell.h"


@interface WCMatchArrayViewController ()

@end

@implementation WCMatchArrayViewController


-(id)initWithTeamName:(NSString*)teamName
{
    self = [super initWithDefaultNib];
    if(self)
    {
        self.matchArray = [[WCDataEntities sharedDataManager].allGames gamesForOneTeam: teamName];
        self.title = NSLocalizedString(teamName, nil);
    }
    
    return self;
}


-(id)initWithLocationCityName: (NSString*)cityName
{
    self = [super initWithDefaultNib];
    if(self)
    {
        self.matchArray = [[WCDataEntities sharedDataManager].allGames gamesForOneLocation: cityName];
        self.title = NSLocalizedString(cityName, nil);
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
    // Do any additional setup after loading the view from its nib.
    
    [self addCloseButtonToNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inits
 

#pragma mark - Actions


#pragma mark - UITableView Delegate & Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.matchArray.count;
 
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        OneMatch *matchData = [self.matchArray objectAtIndex: indexPath.row];
        cell = [[WCMatchCellViewCell alloc] initWithOneMatchData: matchData];
    }
    
    return cell;
}


-(NSString*)cellIdentityForTableView: (UITableView*)tableView
{
    NSString * cellID = @"MatchArrayTableViewCell";
    
    return cellID;
}


@end
