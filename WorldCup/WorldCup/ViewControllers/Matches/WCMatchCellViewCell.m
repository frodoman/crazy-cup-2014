//
//  WCMatchCellViewCell.m
//  WorldCup
//
//  Created by Xinghou Liu on 26/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMatchCellViewCell.h"
#import "WCDataEntities.h"
#import "UIColor+WCColors.h"
#import "NSString+Common.h"
#import "UIFont+WCFont.h"
#import "UIImage+WCImage.h"
#import "WCMatchDetailsViewController.h"
#import "WCAppDelegate.h"
#import <EventKit/EventKit.h>
#import "WorldCup-Prefix.pch"


@implementation WCMatchCellViewCell

-(id) initWithOneMatchData: (OneMatch*) matchData
           hideEventButton: (BOOL)hideButton
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"WCOneMatchCell"];
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options:nil ];
    
    UIView *viewCell = nil;
    if(viewArray.count>0)
    {
        viewCell = [viewArray objectAtIndex: 0];
    }
    if(self)
    {
        self.hideEventButton = hideButton;
        
        self.matchData = matchData;
        viewCell.frame = self.bounds;
        [self addSubview: viewCell ];
        
        [self initUIs];
        
        [self parseMatchData];
        
        [self addGestureEvents];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return self;
}


-(id)initWithOneMatchData:(OneMatch *)matchData
{
    return  [self initWithOneMatchData: matchData hideEventButton:NO];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if(selected)
    {
        self.backgroundColor = [UIColor viewSelectedColor];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

-(void)parseMatchData
{
    self.labelTime.text = self.matchData.startTime.localTimeString;
    
    self.labelTeamA.text = NSLocalizedString(self.matchData.teamA.teamName, nil);
    self.labelTeamB.text = NSLocalizedString(self.matchData.teamB.teamName, nil);
    
    self.labelGoalsA.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.matchData.goalsCountA];
    self.labelGoalsB.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.matchData.goalsCountB];
    if([self.matchData matchNotStarted])
    {
        self.labelGoalsA.text = self.labelGoalsB.text = @"-";
    }
    
    self.labelMatchID.text = [NSString stringWithFormat:@"%@ %ld",
                              NSLocalizedString(@"Match",nil),
                              (unsigned long)self.matchData.itemID];
    
    UIImage *teamAImage = [UIImage imageForTeam: self.matchData.teamA.teamName];
    self.teamAImageView.image = teamAImage;
    
    UIImage *teamBImage =[UIImage imageForTeam: self.matchData.teamB.teamName ];
    self.teamBImageView.image = teamBImage;
    
    [self initEventButton];
}

-(void)initEventButton
{
    //init the event button
    self.buttonAddEvent.selected = NO;
    self.buttonAddEvent.backgroundColor = [UIColor whiteColor];
    self.buttonAddEvent.layer.cornerRadius = kWCViewCornerRadius;
    self.buttonAddEvent.layer.borderWidth = 0.6f;
    self.buttonAddEvent.layer.borderColor = [UIColor mainTextColor].CGColor;
    [self.buttonAddEvent.titleLabel setFont: [UIFont wcFont_H4]];
    self.buttonAddEvent.titleLabel.frame = CGRectMake(0, 0,
                                                      self.buttonAddEvent.frame.size.width,
                                                      self.buttonAddEvent.frame.size.height);
    
    [self.buttonAddEvent setTitleColor: [UIColor mainTextColor] forState: UIControlStateNormal];
    [self.buttonAddEvent setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
    [self.buttonAddEvent setTitle: NSLocalizedString(@"Add to Calendar", nil) forState:UIControlStateNormal];
    [self.buttonAddEvent setTitle: NSLocalizedString(@"Remove", nil) forState:UIControlStateSelected];
    
    //show the add event button
    if( self.hideEventButton)
    {
        self.buttonAddEvent.hidden = YES;
    }
    else
    {
        if([self.matchData.status  isEqualToString: kWCMatchStatusNotOn])
        {
            self.buttonAddEvent.hidden = NO;
        }
        else
        {
            self.buttonAddEvent.hidden = YES;
        }
    }
    
    // we have this event in the calendar ?
    OneMatch* matchInSettings = [WCUserSettings matchInCalendar: self.matchData];
    if(matchInSettings)
    {
        self.buttonAddEvent.selected = YES;
    }
    
    if(self.buttonAddEvent.selected)
    {
        self.buttonAddEvent.layer.borderColor = [UIColor redColor].CGColor;
    }
}

-(void)initUIs
{
 
    self.labelTime.font = [UIFont wcFont_H4];
    self.labelMatchID.font = [UIFont wcFont_H4];
    
    self.labelTeamA.font = [UIFont wcFont_H3];
    self.labelTeamB.font = [UIFont wcFont_H3];
 
    UIColor *textColor = [UIColor mainTextColor];
    
    self.labelGoalsA.textColor =
    self.labelGoalsB.textColor =
    self.labelMatchID.textColor =
    self.labelTeamA.textColor =
    self.labelTeamB.textColor =
    self.labelTime.textColor = textColor;
    
    if([self.matchData.status isEqualToString: kWCMatchStatusOn])
    {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0f;
    }

}
#pragma mark - Animations
-(void)animateEventButton
{
    [UIView animateWithDuration:kWCAnimationDurationInSeconds1x
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.buttonAddEvent.layer.transform = CATransform3DMakeScale(1.3f, 1.3, 1.0f);
                     } completion:^(BOOL finished){
                         if(finished)
                         {
                             [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                                              animations:^{
                                                  self.buttonAddEvent.layer.transform = CATransform3DIdentity;
                                              
                                              }];
                         }
                     
                     }];
}

#pragma mark - Actions
-(void)addGestureEvents
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(celViewTapped:) ];
    
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer: tap];
}

-(void)celViewTapped: (UITapGestureRecognizer*)tap
{
    CGPoint tapPoint = [tap locationInView: self];
    if( CGRectContainsPoint(self.buttonAddEvent.frame, tapPoint) &&
       !self.buttonAddEvent.hidden)
    {
        [self buttonEventTapped: self.buttonAddEvent];
        return;
    }
    
    UIImage *image = [UIImage imageForTeamLogo: self.matchData.teamA.teamName];
    if( image == nil )
    {
        return;
    }
    
    WCMatchDetailsViewController *detailsController = [[WCMatchDetailsViewController alloc] initWithMatchData: self.matchData];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsController];
    
    
    WCAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIViewController *rootController = app.window.rootViewController;
    [rootController presentViewController: navController animated:YES completion:nil];
}

-(IBAction)buttonEventTapped:(id)sender
{
    //remove from the calendar
    if(self.buttonAddEvent.selected)
    {
        [self removeEventFromCalendar];
    }
    // add to calendar
    else
    {
        [self addEventToCalendar];
    }
    
    self.buttonAddEvent.selected = !self.buttonAddEvent.selected;
    [self animateEventButton];
    
    if(self.buttonAddEvent.selected)
    {
        self.buttonAddEvent.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        self.buttonAddEvent.layer.borderColor = [UIColor mainTextColor].CGColor;
    }
}


-(void)addEventToCalendar
{
    [WCUserSettings addMatchToCalendar: self.matchData];
}

-(void)removeEventFromCalendar
{
    [WCUserSettings removeMatchFromCalendar: self.matchData];
}


#pragma mark - Public
-(void)setMatchData:(OneMatch *)matchData
{
    _matchData = matchData;
    
    [self parseMatchData];
}


@end
