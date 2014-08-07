//
//  WCOneGroupResultViewController.m
//  WorldCup
//
//  Created by XH Liu on 28/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCOneGroupResultViewController.h"
#import "WCDataEntities.h"
#import "UIFont+WCFont.h"
#import "UIColor+WCColors.h"
#import "NSObject+Consts.h"
#import "UIImage+WCImage.h"

const CGFloat kWCOneGroupResultCellStartY = 55.0f;
const CGFloat kWCOneGroupResultCellHeight = 50.0f;
const CGFloat kWCOneGroupResultCellWidth = 72.0f;

@interface WCOneGroupResultViewController ()

@end

@implementation WCOneGroupResultViewController

-(id)initWithOneGroupResult: (OneGroupResult*)groupResult
{
    self = [super initWithDefaultNib];
    if(self)
    {
        self.groupResult = groupResult;
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
    
    [self initLabels];
    [self createLabelsForGroupResults];
    [self initLayer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated]    ;
    
    if(!self.viewHasBeenShown)
    {
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Inits


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initLayer
{
    [self.view.layer setCornerRadius: kWCViewCornerRadius ];
    [self.view.layer setBorderColor: [UIColor mainBorderColor].CGColor];
    [self.view.layer setBorderWidth: kWCViewBoarderWidth];
}
-(void)initLabels
{
    self.labelGroupName.font = [UIFont wcFont_H2];
    self.labelGroupName.text = self.groupResult.groupName;
    self.labelGroupName.textColor = [UIColor mainTextColor];
    
    self.labelPlayed.font =
    self.labelWon.font =
    self.labelDrawn.font =
    self.labelLost.font =
    self.labelGoalsFor.font =
    self.labelGoalsAgainst.font =
    self.labelGoalsDifference.font =
    self.labelPoint.font = [UIFont wcFont_H4];
    
    self.labelPlayed.textColor =
    self.labelWon.textColor =
    self.labelDrawn.textColor =
    self.labelLost.textColor =
    self.labelGoalsFor.textColor =
    self.labelGoalsAgainst.textColor =
    self.labelGoalsDifference.textColor =
    self.labelPoint.textColor = [UIColor mainTextColor];
    
    self.labelPlayed.text = NSLocalizedString(@"Played", nil);
    self.labelWon.text = NSLocalizedString(@"Won", nil);
    self.labelDrawn.text = NSLocalizedString(@"Drawn", nil);
    self.labelLost.text = NSLocalizedString(@"Lost", nil);
    self.labelGoalsFor.text = NSLocalizedString(@"Goals for", nil);
    self.labelGoalsAgainst.text = NSLocalizedString(@"Goals Against", nil);
    self.labelGoalsDifference.text = NSLocalizedString(@"Goals Difference", nil);
    self.labelPoint.text = NSLocalizedString(@"Points", nil);
}

-(void)addTeamIamges
{
    CGFloat imageSize = 25.0f;
    CGFloat margin = 5.0f;
    for (NSUInteger cellIndex = 0; cellIndex < self.groupResult.teamResults.count; cellIndex++)
    {
        OneTeamResult * teamResult = [self.groupResult.teamResults objectAtIndex: cellIndex];
        
        //team image
        UIImageView *teamImage = [[UIImageView alloc] initWithFrame: CGRectMake(margin+self.view.frame.origin.x,
                                                                                margin*2.5f + kWCOneGroupResultCellHeight* (cellIndex+1) +
                                                                                self.view.frame.origin.y,
                                                                                imageSize, imageSize)];
        teamImage.image = [UIImage imageForTeam: teamResult.teamDetails.teamName ];
        [self.view.superview addSubview: teamImage ];
    }
}



-(void)createLabelsForGroupResults
{
    CGFloat imageSize = 25.0f;
    CGFloat margin = 5.0f;
    for (NSUInteger cellIndex = 0; cellIndex < self.groupResult.teamResults.count; cellIndex++)
    {
        OneTeamResult * teamResult = [self.groupResult.teamResults objectAtIndex: cellIndex];
        
        
        //team name
        UILabel *labelTeamName = [[UILabel alloc] initWithFrame: CGRectMake(self.labelGroupName.frame.origin.x+imageSize,
                                                                            margin + kWCOneGroupResultCellHeight* (cellIndex+1),
                                                                           self.labelGroupName.frame.size.width-imageSize,
                                                                           kWCOneGroupResultCellHeight-margin) ];
        labelTeamName.text = NSLocalizedString(teamResult.teamDetails.teamName, nil);
        labelTeamName.font = [UIFont wcFont_H3];
        labelTeamName.textAlignment = NSTextAlignmentLeft;
        labelTeamName.numberOfLines = 0;
        labelTeamName.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.view addSubview: labelTeamName];
        
        //labels for each number
        CGFloat xStart = 134.0f;
        CGFloat yStart = labelTeamName.frame.origin.y;
        
        for( NSUInteger numberIndex = 0; numberIndex<teamResult.resultArray.count; numberIndex++)
        {
            CGRect frame = CGRectMake(xStart + kWCOneGroupResultCellWidth*numberIndex,
                                      yStart, kWCOneGroupResultCellWidth, kWCOneGroupResultCellHeight);
            UILabel *labelNumber = [[UILabel alloc] initWithFrame: frame ];
            labelNumber.textAlignment = NSTextAlignmentCenter;
            labelNumber.font = [UIFont wcFont_H2];
            
            NSNumber *number = [ teamResult.resultArray objectAtIndex: numberIndex];
            // text for the number label
            labelNumber.text =[NSString stringWithFormat:@"%ld", [number integerValue]];
            
            [self.view addSubview: labelNumber ];
        }
        
        
    }
}

@end
