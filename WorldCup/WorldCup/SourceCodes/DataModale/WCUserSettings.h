//
//  WCUserSettings.h
//  WorldCup
//
//  Created by XH Liu on 30/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OneMatch;

@interface WCUserSettings : NSObject

+(void)updateTeamData;
+(NSArray*)allTeams;
+(NSArray*)favouritedTeams;
+(BOOL)hasGroupData;

+(void)setFavourite: (BOOL)shouldFavourite withIndex: (NSInteger)teamIndex;
+(BOOL)favouriteOrNotTeamWithIndex: (NSInteger)teamIndex;

+(void)setAppHasBeenOpenedCount;
+(NSUInteger) getAppHasBeenOpenedCount;

// editing matches to calendar
+(NSArray*)matchesInCalendar;
+(OneMatch*)matchInCalendar: (OneMatch*)matchToFind;
+(void)addMatchToCalendar: (OneMatch* )matchToAdd;
+(void)removeMatchFromCalendar: (OneMatch*)matchToRemove;

+(BOOL)systemLanguageInChinese;

+(BOOL)appNeverOpened;

@end
