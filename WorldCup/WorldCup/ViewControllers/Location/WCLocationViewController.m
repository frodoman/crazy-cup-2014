//
//  WCLocationViewController.m
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCLocationViewController.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import "WCMainMenuViewController.h"
#import "WCAnnotation.h"
#import "WCMatchArrayViewController.h"

NSUInteger const  kWCLocationButtonTagCallOutMatches = 22;
NSUInteger const  kWCLocationButtonTagCallOutDirection = 21;
NSUInteger const  kWCLocationDirectionAlertViewTag = 29;


@interface WCLocationViewController ()

@end

@implementation WCLocationViewController

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
    [super viewWillAppear:animated];
    
    if(!self.viewHasBeenShown)
    {
        [self initUIs];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initMapView];
}

#pragma mark - Inits
-(void)updateTitleAndPageController
{
    [self.mainMenuController showPageIndicator: NO];
    [self.mainMenuController updateTitle: NSLocalizedString(@"Locations", nil)];
}


-(void) initUIs
{
    self.mapView.layer.borderColor = [UIColor mainBorderColor].CGColor;
    self.mapView.layer.borderWidth = kWCViewBoarderWidth;
    self.mapView.layer.cornerRadius = kWCViewCornerRadius;
}

-(void)initMapView
{
    self.mapView.delegate = self;
    
    // location of Brasilia in Brazil
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -15.511470f,
    zoomLocation.longitude= -47.869228f;
    
    // 2
    CGFloat distance = 2000.0f * kWCMetersPerMile;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, distance, distance);
    // 3
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    // 4
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    //add the annotation to map
    NSArray *locations = [LocationItem locationArray];
    
    for (LocationItem *oneLocation in locations )
    {
        WCAnnotation *anno = [[WCAnnotation alloc] initWithLocationItem: oneLocation];
        [self.mapView addAnnotation: anno  ];
    }

}

#pragma mark - Actions
-(void)annotationViewTapped: (UITapGestureRecognizer*)tap
{
    NSString *cityName = tap.accessibilityValue;
    
    if(cityName)
    {
        WCMatchArrayViewController * vController = [[WCMatchArrayViewController alloc] initWithLocationCityName: cityName];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController ];
        
        [vController addCloseButtonToNavigationBar ];
        
        [self.rootController presentViewController: navController animated:YES completion:nil ];
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
        
        CGFloat bnSize = 44.0f;
        
        UIButton *bnMatches = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, bnSize, bnSize) ];
        UIImage *image =[UIImage imageNamed:kWCImageNameFootBall];
        [bnMatches setImage:image forState:UIControlStateNormal];
        bnMatches.tag = kWCLocationButtonTagCallOutMatches;
        pinView.rightCalloutAccessoryView = bnMatches ;
        
        UIButton *bnDirection = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, bnSize*2, bnSize) ];
        [bnDirection setTitle: NSLocalizedString(@"Direction", nil) forState: UIControlStateNormal ];
        [bnDirection setTitleColor: [UIColor mainTextColor] forState: UIControlStateNormal ];
        bnDirection.titleLabel.font = [UIFont wcFont_H3];
        bnDirection.tag = kWCLocationButtonTagCallOutDirection;
        pinView.leftCalloutAccessoryView = bnDirection;
 
    }
    else
    {
        // This is the user's current location
        // use default view
    }
    
    return pinView;
}

-(void)addTapEventToAnnotationView: (MKAnnotationView*)annoView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(annotationViewTapped:) ];
    tap.numberOfTapsRequired = 1;
    
    WCAnnotation *anno = (WCAnnotation*)annoView.annotation;
    
    tap.accessibilityValue = anno.locationData.cityName;

    [annoView addGestureRecognizer: tap];
}

//why this is not being called?
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)view;
    pinView.pinColor = MKPinAnnotationColorGreen;
    
    self.selectedAnnotation = (WCAnnotation*)pinView.annotation;
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)view;
    pinView.pinColor = MKPinAnnotationColorRed;
}

-(void)mapView:(MKMapView *)mapView
annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if( control.tag == kWCLocationButtonTagCallOutMatches)
    {
        WCAnnotation *anno = (WCAnnotation*)view.annotation;
        NSString *cityName = anno.locationData.cityName;
        
        WCMatchArrayViewController * vController = [[WCMatchArrayViewController alloc] initWithLocationCityName: cityName];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController ];
        [vController addCloseButtonToNavigationBar ];
        
        [self.rootController presentViewController: navController animated:YES completion:nil ];
    }
    else if (control.tag == kWCLocationButtonTagCallOutDirection)
    {
        [self showDirectionsAlert];
    }
}

#pragma mark - Directions
-(void) showDirectionsAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Showing Directions", nil)
                                                    message:NSLocalizedString(@"You are about to leave this app.", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                          otherButtonTitles:NSLocalizedString(@"OK",nil), nil ];
    alert.tag = kWCLocationDirectionAlertViewTag;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kWCLocationDirectionAlertViewTag)
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
}

-(void) showDirections
{
    //first create latitude longitude object
    CLLocationCoordinate2D startCoordinate = _mapView.userLocation.coordinate;
    CLLocationCoordinate2D coordinateDes;
    
    //find the match location
    LocationItem *desLocation = [LocationItem findLocationByCityName: self.selectedAnnotation.locationData.cityName];
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

@end
