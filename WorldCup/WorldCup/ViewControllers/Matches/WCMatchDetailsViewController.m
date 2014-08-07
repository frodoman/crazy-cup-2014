//
//  WCMatchDetailsViewController.m
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMatchDetailsViewController.h"
#import "WorldCup-Prefix.pch"
#import "WCMatchCellViewCell.h"
#import "WCAnnotation.h"

@interface WCMatchDetailsViewController ()

@end

@implementation WCMatchDetailsViewController

-(id)initWithMatchData: (OneMatch*)matchData
{
    self = [super initWithDefaultNib];
    if(self)
    {
        self.matchData = matchData;
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
    
    [self initUIs ];
    
    [self initMapView];
    
    if([self respondsToSelector: @selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
        [self initMatchData];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!self.viewHasBeenShown)
    {
        
    }
    [super viewDidAppear:animated];
    
}


#pragma mark - Inits

-(void)initUIs
{
    self.view.backgroundColor = [UIColor mainNavigationBarColor];
    self.title = NSLocalizedString(@"Match Details", nil);
    
    [self.bnGetDirection addBorderStyle];
    [self.bnGetDirection setBackgroundColor: [UIColor whiteColor]];
    
    [self.bnGetDirection setTitle: NSLocalizedString(@"Get Direction", nil)
                         forState:UIControlStateNormal];
    self.bnGetDirection.titleLabel.frame = CGRectOffset(self.bnGetDirection.titleLabel.frame, 0, 8.0f);
    self.bnGetDirection.titleLabel.numberOfLines = 2;
    self.bnGetDirection.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.bnGetDirection.titleLabel setFont: [UIFont wcFont_H1]];
    [self.bnGetDirection setTitleColor: [UIColor mainTextColor] forState:UIControlStateNormal];
    
    [self.imageViewTeamA addBorderStyle];
    self.imageViewTeamA.backgroundColor = [UIColor whiteColor];
    
    [self.imageViewTeamB addBorderStyle];
    self.imageViewTeamB.backgroundColor = [UIColor whiteColor];
    
    [self.mapView addBorderStyle];
}


-(void) initMatchData
{
    self.matchInfoCellView = [[WCMatchCellViewCell alloc] initWithOneMatchData: self.matchData hideEventButton:YES];
    self.matchInfoCellView.frame = self.matchInfoView.frame;
    self.matchInfoCellView.clipsToBounds = YES;
    [self.view insertSubview: self.matchInfoCellView aboveSubview: self.matchInfoView ];
    
    self.matchInfoCellView.layer.borderColor = [UIColor mainBorderColor].CGColor;
    self.matchInfoCellView.layer.borderWidth = kWCViewBoarderWidth;
    self.matchInfoCellView.layer.cornerRadius = kWCViewCornerRadius;
    
    self.imageViewTeamA.image = [UIImage imageForTeamLogo: self.matchData.teamA.teamName];
    self.imageViewTeamB.image = [UIImage imageForTeamLogo: self.matchData.teamB.teamName];
    

    
}


-(void)initMapView
{
    LocationItem *matchLocation = [LocationItem findLocationByCityName: self.matchData.location.cityName];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = matchLocation.latitude;
    zoomLocation.longitude= matchLocation.longitude;//-76.580806;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*kWCMetersPerMile, 0.5*kWCMetersPerMile);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
    
    //add the annotation to map
    WCAnnotation *anno = [[WCAnnotation alloc] initWithLocationItem: matchLocation];
    
    [_mapView addAnnotation: anno  ];
}


#pragma mark - Actions
-(IBAction)buttonGetDirectionTapped:(id)sender
{
    [self showDirectionsAlert];
}


#pragma mark - Directions
-(void) showDirectionsAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Showing Directions", nil)
                                                    message:NSLocalizedString(@"You are about to leave this app.", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                          otherButtonTitles:NSLocalizedString(@"OK",nil), nil ];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    //cancel
    if (buttonIndex == 0)
    {
        return;
    }
    //OK
    else
    {
        [self showDirections];
    }
}

-(void) showDirections
{
    //first create latitude longitude object
    CLLocationCoordinate2D startCoordinate = _mapView.userLocation.coordinate;
    CLLocationCoordinate2D coordinateDes;
    
    //find the match location
    LocationItem *desLocation = [LocationItem findLocationByCityName: self.matchData.location.cityName];
    coordinateDes.latitude = desLocation.latitude;
    coordinateDes.longitude = desLocation.longitude;
    
    //create MKMapItem out of destination coordinate
    MKPlacemark* startPlaceMark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate addressDictionary:nil];
    MKMapItem* startMapItem =  [[MKMapItem alloc] initWithPlacemark:startPlaceMark];
    
    //using iOS6 native maps app
    if([startMapItem respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        //create MKMapItem out of destination coordinate
        MKPlacemark* placeMark =[[MKPlacemark alloc] initWithCoordinate:coordinateDes addressDictionary:nil] ;
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark:placeMark];
        
        [MKMapItem openMapsWithItems:@[startMapItem, destination] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking }];
    }
 
    //using iOS 5 which has the Google Maps application
    else
    {
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                         startCoordinate.latitude, startCoordinate.longitude,
                         coordinateDes.latitude, coordinateDes.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}


#pragma mark - MKMapViewDelegate functions

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
}

-(void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location service is not available."
                                                    message:error.description
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation> ) annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"MatchDetailsAnnotationView";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if ( pinView == nil )
        {
            pinView = [[MKPinAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        [pinView setSelected:YES animated:YES ];
 
    }
    else
    {
        
    }
    
    return pinView;
}


@end
