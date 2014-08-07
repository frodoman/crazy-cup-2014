//
//  WCOneGroupResultViewController.h
//  WorldCup
//
//  Created by XH Liu on 28/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@class  OneGroupResult;

@interface WCOneGroupResultViewController : WCBaseViewController

@property(nonatomic, strong) OneGroupResult *groupResult;

@property(nonatomic, strong) IBOutlet UILabel *labelGroupName;
@property(nonatomic, strong) IBOutlet UILabel *labelPlayed;
@property(nonatomic, strong) IBOutlet UILabel *labelWon;
@property(nonatomic, strong) IBOutlet UILabel *labelDrawn;
@property(nonatomic, strong) IBOutlet UILabel *labelLost;
@property(nonatomic, strong) IBOutlet UILabel *labelGoalsFor;
@property(nonatomic, strong) IBOutlet UILabel *labelGoalsAgainst;
@property(nonatomic, strong) IBOutlet UILabel *labelGoalsDifference;
@property(nonatomic, strong) IBOutlet UILabel *labelPoint;

-(id)initWithOneGroupResult: (OneGroupResult*)groupResult;

-(void)addTeamIamges;

@end
