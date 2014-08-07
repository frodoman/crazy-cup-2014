//
//  WCMatchDetailsViewController.h
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import <MapKit/MapKit.h>

@class  OneMatch;
@class  WCMatchCellViewCell;

@interface WCMatchDetailsViewController : WCBaseViewController
<MKMapViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *imageViewTeamA;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewTeamB;
@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) IBOutlet UIButton *bnGetDirection;
@property(nonatomic, strong) IBOutlet UIView *matchInfoView;
@property(nonatomic, strong) IBOutlet WCMatchCellViewCell *matchInfoCellView;

@property(nonatomic, strong) OneMatch *matchData; 

-(id)initWithMatchData: (OneMatch*)matchData;

-(IBAction)buttonGetDirectionTapped:(id)sender;

@end
