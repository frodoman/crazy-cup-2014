//
//  WCLocationViewController.h
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import <MapKit/MapKit.h>

@class  WCAnnotation;

@interface WCLocationViewController : WCBaseViewController
< MKMapViewDelegate >

@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) WCAnnotation *selectedAnnotation;

@end
