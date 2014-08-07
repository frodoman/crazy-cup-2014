//
//  WCMainMenuItem.m
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMainMenuItem.h"
#import "NSObject+Consts.h"

static NSArray *_allMenuItems;
static NSArray *_moreMenuItems;


@implementation WCMainMenuItem

+(NSArray*)menuItemArrayWithFile: (NSString*)fileName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"json" ];
    NSData *data = [[NSData alloc] initWithContentsOfURL: url ];
    
    NSError *jsonError = nil;
    NSArray *jsonResult = [NSJSONSerialization JSONObjectWithData:  data
                                                          options:NSJSONReadingMutableLeaves error:&jsonError];
    if(jsonError)
    {
        NSLog( @"JSON Error: %@ \n", jsonError.debugDescription);
        return nil;
    }
    
    NSMutableArray *menuItems = [NSMutableArray array];
    for (NSDictionary *oneDic in jsonResult)
    {
        WCMainMenuItem *oneMenu = [[WCMainMenuItem alloc] initWithDictionary: oneDic ];
        [menuItems addObject: oneMenu];
    }
    
    return menuItems;
}

+(NSArray*) mainMenuItems
{
    if( _allMenuItems && _allMenuItems.count>0)
    {
        return _allMenuItems;
    }
    
    NSArray *items = [WCMainMenuItem menuItemArrayWithFile: @"MainMenu"];
    
    _allMenuItems = nil;
    _allMenuItems = [[NSArray alloc] initWithArray: items];
    return _allMenuItems;
}

+(NSArray*)moreMenuItems
{
    if(_moreMenuItems && _moreMenuItems.count>0)
    {
        return  _moreMenuItems;
    }
    NSArray *items = [WCMainMenuItem menuItemArrayWithFile: @"MoreMenuItems"];
    
    _moreMenuItems = nil;
    _moreMenuItems = [[NSArray alloc] initWithArray: items];
    return _moreMenuItems;
    
}


-(id)initWithDictionary:(NSDictionary *)oneDic
{
    self = [super init];
    if(self)
    {
        self.title =[oneDic objectForKey: kJsonKeyMainMenuTitle];
        
        NSString *strName = [oneDic objectForKey: kJsonKeyMainMenuImage];
        self.imageName = strName;
        
        self.controllerClassName = [oneDic objectForKey: kJsonKeyMainMenuClass];
    }
    return self;
}


@end
