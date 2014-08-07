//
//  WCMainMenuItem.h
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCDataEntities.h"

@interface WCMainMenuItem : WCBaseData

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *controllerClassName;
@property(nonatomic, strong) NSString *imageName;

+(NSArray*) mainMenuItems;
+(NSArray*) moreMenuItems;

@end
