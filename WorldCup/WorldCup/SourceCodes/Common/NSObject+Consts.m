//
//  NSObject+Consts.m
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "NSObject+Consts.h"

//json file keys
NSString *const kJsonKeyAllGames = @"allGames";
NSString *const kJsonKeyStartTime = @"startTime";
NSString *const kJsonKeyTimeZone= @"timeZone";
NSString *const kJsonKeyTime= @"time";
NSString *const kJsonKeyEndTime= @"endTime";
NSString *const kJsonKeyLastUpdateTime = @"lastUpdated";

//group games
NSString *const kJsonKeyGroupGames= @"groupGames";
NSString *const kJsonKeyMatchID= @"matchID";
NSString *const kJsonKeyLocation= @"location";
NSString *const kJsonKeyCity= @"city";
NSString *const kJsonKeyTeamA= @"teamA";
NSString *const kJsonKeyTeamB= @"teamB";
NSString *const kJsonKeyGoalsA= @"goalsA";
NSString *const kJsonKeyGoalsB= @"goalsB";
NSString *const kJsonKeyStatus = @"status";

NSString *const kJsonKeyRoundOf16Games= @"roundOf16Games";
NSString *const kJsonKeyQuarterGames= @"quarterGames";
NSString *const kJsonKeySemiGames= @"semiGames";
NSString *const kJsonKeyThirdGame= @"thirdGame";
NSString *const kJsonKeyFinalGame= @"finalGame";

NSString *const kJsonKeyName = @"name";

//location key
NSString *const kJsonKeyStadium = @"stadium";
NSString *const kJsonKeyLatitude = @"latitude";
NSString *const kJsonKeyLongitude = @"longitude";

// notification
NSString *const kNotificationGetAllGamesFinished = @"NotificationGetAllGamesFinished";
NSString *const kNotificationGetGroupResultsFinished = @"otificationGetGroupResultsFinished";

// Network staff
NSString *const kURLGetAllGames = @"http://www.xmartcalc.com/wc2014/AllGames.json";
NSString *const kURLGetGroupResults = @"http://www.xmartcalc.com/wc2014/GroupResults.json";

// animations
CGFloat const  kWCAnimationDurationInSeconds1x = 0.3f;
CGFloat const  kWCAnimationDurationInSeconds2x = 0.6f;
CGFloat const  kWCAnimationDurationInSeconds3x = 0.9f;
CGFloat const  kWCAnimationDurationInSeconds4x = 1.2f;
CGFloat const  kWCAnimationDurationInSeconds5x = 1.5f;
CGFloat const  kWCAnimationDurationInSeconds6x = 1.6f;
CGFloat const  kWCSecondsToShowIAdLater = 6.0f;

//main Menu
CGFloat const  kWCMainMenuCellViewHeight = 120.0f;
CGFloat const  kWCViewCornerRadius = 3.0f;
CGFloat const  kWCViewBoarderWidth = 2.0f;

CGFloat const  kWCMainMenuTitleHeight = 64.0f;
CGFloat const  kWCSpaceBetweenViews = 3.0f;
CGFloat const  kWCSystemStatusBarHeight = 20.0f;
CGFloat const  kWCIAdViewHeight = 49.0f;

NSString *const kJsonKeyMainMenuTitle = @"title";
NSString *const kJsonKeyMainMenuImage = @"image";
NSString *const kJsonKeyMainMenuClass = @"class";

//Match
NSString *const  kWCMatchStatusNotOn = @"NotOn";
NSString *const  kWCMatchStatusOn = @"On";
NSString *const  kWCMatchStatusFinished = @"Done";
CGFloat const    kWCMatchCellHeight =110.0f ;
CGFloat const    kWCOneTeamCellHeight = 70.0f ;

// images
NSString *const kWCImageNameFootBall = @"football";
NSString *const kWCFavouriteTeamImage = @"heart_red";
NSString *const kWCUnFavouriteTeamImage = @"heart_grey";
NSString *const kWCMainMenuMaskImageName = @"tileMask2";
NSString *const kWCImageNameForAppSharing = @"icon120";


// info plist
NSString *const kWCInfoPlistKeySupportIAd = @"SupportIAd";
NSString *const kWCInfoPlistKeyAppOpenTimesWithOutIAd=@"AppCanRunWithoutIAdFor";


//city names
NSString *const kWCCityNameForTimeZone4 =@"Cuiabá";
NSString *const kWCCityNameForTimeZone4_2=@"Arena da Amazônia";


// for user settings
NSString *const kWCUserSettingsKeyGroupTeams =@"GroupAndTeams";
NSString *const kWCUserSettingsKeyGroupData = @"GroupData";
NSString *const kWCUserSettingsKeyAppOpenTiemCount = @"AppOpenTiemCount";
NSString  *const kWCUserSettingsKeyAppNeverOpened = @"AppNeverOpened";
NSUInteger const kWCNumberOfTeamsInOneGroup = 4;
NSUInteger const kWCNumberOfAllTeams = 32;



//match event in Calendar
NSString *const  kWCUserSettingsKeyMatchesInCalendar = @"MatchesInCalendar";


// for map view
CGFloat const kWCMetersPerMile = 1609.344f;

// for networking


@implementation NSObject (Consts)

+(BOOL )shouldShowIAd
{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary ];
    
    NSNumber *number = [dic objectForKey:  kWCInfoPlistKeySupportIAd];
    if( [number integerValue]>0)
    {
        NSUInteger openCount = [WCUserSettings getAppHasBeenOpenedCount];
        if(openCount > [NSObject applicationCanRunWithoutIAdMaxTime] )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

+(NSUInteger)applicationCanRunWithoutIAdMaxTime
{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary ];
    
    NSNumber *number = [dic objectForKey:  kWCInfoPlistKeyAppOpenTimesWithOutIAd];
    if(number)
    {
        return [number integerValue];
    }
    return 0;
}


+(CGFloat)iAdViewHeight
{
    if( [NSObject shouldShowIAd])
    {
        return  kWCIAdViewHeight;
    }
    else
    {
        return  0.0f;
    }
}

+(CGFloat)transform3D_M34
{
    return 2.0f/800.0f;
}

@end
