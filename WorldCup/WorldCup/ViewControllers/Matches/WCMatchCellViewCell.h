//
//  WCMatchCellViewCell.h
//  WorldCup
//
//  Created by Xinghou Liu on 26/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneMatch;

@interface WCMatchCellViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *teamAImageView;
@property(nonatomic, strong) IBOutlet UIImageView *teamBImageView;
@property(nonatomic, strong) IBOutlet UILabel *labelTime;
@property(nonatomic, strong) IBOutlet UILabel *labelMatchID;
@property(nonatomic, strong) IBOutlet UILabel *labelTeamA;
@property(nonatomic, strong) IBOutlet UILabel *labelTeamB;
@property(nonatomic, strong) IBOutlet UILabel *labelGoalsA;
@property(nonatomic, strong) IBOutlet UILabel *labelGoalsB;
@property(nonatomic, strong) IBOutlet UIView *viewTitleBackground;
@property(nonatomic, strong) IBOutlet UIButton *buttonAddEvent;

@property(nonatomic) BOOL hideEventButton;
@property(nonatomic, strong) OneMatch *matchData;

-(id) initWithOneMatchData: (OneMatch*) matchData;
-(id) initWithOneMatchData: (OneMatch*) matchData hideEventButton: (BOOL)hideButton;


-(IBAction)buttonEventTapped:(id)sender;

@end
