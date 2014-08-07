//
//  WCUserSettings.m
//  WorldCup
//
//  Created by XH Liu on 30/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCUserSettings.h"
#import "WCDataEntities.h"
#import "NSObject+Consts.h"
#import <EventKit/EventKit.h>

@implementation WCUserSettings


+(void)load
{
    if(![WCUserSettings hasGroupData])
    {
        [self updateTeamData];
    }
}

+(void)updateTeamData
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    NSArray *teams = [OneTeam allTeams];
    //NSMutableDictionary *groupData = [[NSMutableDictionary alloc] init ];
    //[groupData setObject: teams forKey: kWCUserSettingsKeyGroupTeams];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: teams];
    [settings setObject: data forKey:kWCUserSettingsKeyGroupTeams];
    [settings synchronize];
    
}

+(void)updateTeamData: (NSArray*)teams
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: teams];
    [settings setObject: data forKey:kWCUserSettingsKeyGroupTeams];
    [settings synchronize];
}

+(NSArray*)allTeams
{
    if( [WCUserSettings hasGroupData])
    {
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        NSData *data = [settings objectForKey: kWCUserSettingsKeyGroupTeams];
        NSArray *teams = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        return teams;
    }
    else
    {
        return nil;
    }
}

+(NSArray*)favouritedTeams
{
    NSArray *teams = [WCUserSettings allTeams];
    
    NSMutableArray *favouritedTeams = [NSMutableArray array];
    for( OneTeam *aTeam in teams )
    {
        if(aTeam.favourited )
        {
            [favouritedTeams addObject: aTeam ];
        }
    }
    
    if(favouritedTeams.count>0)
    {
        return favouritedTeams;
    }
    else
    {
        return  nil;
    }
}

+(BOOL)hasGroupData
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSArray *groupData = [settings objectForKey: kWCUserSettingsKeyGroupTeams];
    if(groupData == nil)
    {
        return NO;
    }
    else
    {
        return  YES;
    }
}

+(void)setFavourite: (BOOL)shouldFavourite
          withIndex: (NSInteger)teamIndex
{
    NSArray *teams = [WCUserSettings allTeams];
    if(teamIndex<teams.count)
    {
        OneTeam *aTeam = [teams objectAtIndex: teamIndex];
        aTeam.favourited = shouldFavourite;
    }
    [WCUserSettings updateTeamData:teams];
}

+(BOOL)favouriteOrNotTeamWithIndex: (NSInteger)teamIndex
{
    NSArray *teams = [WCUserSettings allTeams];
    if(teamIndex< teams.count)
    {
        OneTeam *aTeam = [teams objectAtIndex: teamIndex];
        return aTeam.favourited;
    }
    
    return NO;
}

+(void)setAppHasBeenOpenedCount
{
    NSUInteger currentCount = [WCUserSettings getAppHasBeenOpenedCount];
    
    NSNumber *newCount = [NSNumber numberWithInteger: currentCount+1];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:newCount forKey:kWCUserSettingsKeyAppOpenTiemCount ];
    [settings synchronize ];
}

+(NSUInteger) getAppHasBeenOpenedCount
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [settings objectForKey: kWCUserSettingsKeyAppOpenTiemCount];
    if(number)
    {
        return [number integerValue];
    }
    return 0;
}

#pragma mark - Matches in Calendar
// editing matches to calendar
+(NSArray*)matchesInCalendar
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSData *data = [settings objectForKey: kWCUserSettingsKeyMatchesInCalendar];
    NSArray *teams = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    return teams;
}

+(void)saveMatchesInCalendarToSettings: (NSArray*)matchArray
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: matchArray];
    [settings setObject: data forKey:kWCUserSettingsKeyMatchesInCalendar];
    [settings synchronize];
}

+(OneMatch*)matchInCalendar:(OneMatch *)matchToFind
{
    NSArray *oldMatches = [WCUserSettings matchesInCalendar];
    if(oldMatches==nil || oldMatches.count == 0)
    {
        return nil;
    }
    
    OneMatch *foundMatch = nil;
    for(OneMatch *aMatch in oldMatches)
    {
        if(aMatch.itemID == matchToFind.itemID)
        {
            foundMatch = aMatch;
            break;
        }
    }
    
    return foundMatch;
}


+(void)addMatchToCalendar: (OneMatch* )matchToAdd
{
    //add to the calendar
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent
                          completion:^(BOOL granted, NSError *error)
     {
         if (!granted) { return; }
         
         //add to calendar
         EKEvent *event = [EKEvent eventWithEventStore:store];
         event.title = [NSLocalizedString(@"World Cup Match", nil) stringByAppendingFormat:@" %ld\n%@ vs %@",
                        (unsigned long)matchToAdd.itemID,
                        matchToAdd.teamA.teamName, matchToAdd.teamB.teamName ];
         event.startDate = matchToAdd.startTime.gmtTime;
         event.endDate = [event.startDate dateByAddingTimeInterval:60*60*2];  //set 2 hour meeting
         
         //add alarm to the event
         NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
         EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-1800]; // 30 minutes
         EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:-3600]; // 1 Hour
         [myAlarmsArray addObject:alarm1];
         [myAlarmsArray addObject:alarm2];
         event.alarms = myAlarmsArray;
         
         [event setCalendar:[store defaultCalendarForNewEvents]];
         NSError *err = nil;
         [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
         matchToAdd.matchEventID = event.eventIdentifier;
 
         
         //add to user settings
         NSArray *oldMatches = [WCUserSettings matchesInCalendar];
         NSMutableArray *newMatches = [NSMutableArray array];
         if(oldMatches.count>0)
         {
             newMatches = [NSMutableArray arrayWithArray: oldMatches];
         }
         if(matchToAdd)
         {
             [newMatches addObject: matchToAdd];
             [WCUserSettings saveMatchesInCalendarToSettings: newMatches];
         }
         
     }];
    
}


+(void)removeMatchFromCalendar: (OneMatch*)matchToRemove
{
    if(matchToRemove == nil)
    {
        return;
    }
    OneMatch *targetMatch = [WCUserSettings matchInCalendar: matchToRemove];
    if(targetMatch == nil)
    {
        return;
    }
    
    //remove from user settings
    NSArray *oldMatches = [WCUserSettings matchesInCalendar];
    NSMutableArray *newMatches = [NSMutableArray array];
    if(oldMatches.count>0   )
    {
        newMatches = [NSMutableArray arrayWithArray: oldMatches];
    }
    
    //find the match to remove
    NSInteger foundIndex = -1;
    for(NSUInteger matchIndex = 0; matchIndex< newMatches.count; matchIndex++)
    {
        OneMatch *aMatch = [newMatches objectAtIndex: matchIndex];
        if(aMatch.itemID == targetMatch.itemID)
        {
            foundIndex = matchIndex;
            break;
        }
    }
    //remove from settings
    if(foundIndex>=0)
    {
        [newMatches removeObjectAtIndex: foundIndex];
    }
    [WCUserSettings saveMatchesInCalendarToSettings: newMatches];
    
    //remove from calendar
    EKEventStore* store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent* eventToRemove = [store eventWithIdentifier: targetMatch.matchEventID];
        if (eventToRemove) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
        }
    }];
}

//system settings
+(BOOL)systemLanguageInChinese
{
    NSString *defaultSystemLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([defaultSystemLanguage  isEqualToString:@"zh-Hans"])
    {
        return YES;
    }
    return NO;
}

//App never opened ?
+(BOOL)appNeverOpened
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSNumber *neverUsedFlag = [settings objectForKey: kWCUserSettingsKeyAppNeverOpened];
    
    if(neverUsedFlag)
    {
        return NO;
    }
    else
    {
        [settings setObject: [NSNumber numberWithInteger: 1] forKey: kWCUserSettingsKeyAppNeverOpened];
        [settings synchronize];
        
        return YES;
    }
}

@end
