//
//  WCAnnotation.m
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCAnnotation.h"

@implementation WCAnnotation

-(id)initWithLocationItem: (LocationItem*)locationData
{
    self = [super init];
    if(self)
    {
        self.locationData = locationData;
        
        [self parseLocationData ];
    }
    
    return self;
}

-(void)parseLocationData
{
    self.coordinate = CLLocationCoordinate2DMake(self.locationData.latitude,  self.locationData.longitude);
    self.title = NSLocalizedString(self.locationData.stadiumName, nil);
    self.subtitle = NSLocalizedString( self.locationData.cityName,nil);
}


@end
