//
//  WCAnnotation.h
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class LocationItem;

//define the annotation
@interface WCAnnotation : NSObject<MKAnnotation>
{
}

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) LocationItem *locationData;


-(id)initWithLocationItem: (LocationItem*)locationData;

@end