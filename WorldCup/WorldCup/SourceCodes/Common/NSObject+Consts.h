//
//  NSObject+Consts.h
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

////*json file keys
extern NSString *const kJsonKeyAllGames;
extern NSString *const kJsonKeyStartTime;
extern NSString *const kJsonKeyTimeZone;
extern NSString *const kJsonKeyTime;
extern NSString *const kJsonKeyEndTime;
extern NSString *const kJsonKeyLastUpdateTime;

//group games
extern NSString *const kJsonKeyGroupGames;
extern NSString *const kJsonKeyMatchID;
extern NSString *const kJsonKeyLocation;
extern NSString *const kJsonKeyCity;
extern NSString *const kJsonKeyTeamA;
extern NSString *const kJsonKeyTeamB;
extern NSString *const kJsonKeyGoalsA;
extern NSString *const kJsonKeyGoalsB;
extern NSString *const kJsonKeyStatus;

extern NSString *const kJsonKeyRoundOf16Games;
extern NSString *const kJsonKeyQuarterGames;
extern NSString *const kJsonKeySemiGames;
extern NSString *const kJsonKeyThirdGame;
extern NSString *const kJsonKeyFinalGame;

extern NSString *const kJsonKeyName ;

//location key
extern NSString *const kJsonKeyStadium;
extern NSString *const kJsonKeyLatitude;
extern NSString *const kJsonKeyLongitude;

// notification
extern NSString *const kNotificationGetAllGamesFinished;
extern NSString *const kNotificationGetGroupResultsFinished;

// Network staff
extern NSString *const kURLGetAllGames;
extern NSString *const kURLGetGroupResults;

// animations
extern CGFloat const  kWCAnimationDurationInSeconds1x;
extern CGFloat const  kWCAnimationDurationInSeconds2x;
extern CGFloat const  kWCAnimationDurationInSeconds3x;
extern CGFloat const  kWCAnimationDurationInSeconds4x;
extern CGFloat const  kWCAnimationDurationInSeconds5x;
extern CGFloat const  kWCAnimationDurationInSeconds6x;
extern CGFloat const  kWCSecondsToShowIAdLater;

//main Menu
extern CGFloat const  kWCMainMenuCellViewHeight;
extern CGFloat const  kWCViewCornerRadius;
extern CGFloat const  kWCViewBoarderWidth;
extern CGFloat const  kWCMainMenuTitleHeight;
extern CGFloat const  kWCSpaceBetweenViews;
extern CGFloat const  kWCSystemStatusBarHeight;
extern CGFloat const  kWCIAdViewHeight;

extern NSString *const kJsonKeyMainMenuTitle;
extern NSString *const kJsonKeyMainMenuImage;
extern NSString *const kJsonKeyMainMenuClass;

//Match
extern NSString *const  kWCMatchStatusNotOn;
extern NSString *const  kWCMatchStatusOn;
extern NSString *const  kWCMatchStatusFinished;
extern CGFloat const    kWCMatchCellHeight;
extern CGFloat const    kWCOneTeamCellHeight;


// images
extern NSString *const kWCImageNameFootBall;
extern NSString *const kWCFavouriteTeamImage;
extern NSString *const kWCUnFavouriteTeamImage;
extern NSString *const kWCMainMenuMaskImageName;
extern NSString *const kWCImageNameForAppSharing;

//city names
extern NSString *const kWCCityNameForTimeZone4;
extern NSString *const kWCCityNameForTimeZone4_2;

// info plist
extern NSString *const kWCInfoPlistKeySupportIAd;
extern NSString *const kWCInfoPlistKeyAppOpenTimesWithOutIAd;

// for user settings
extern NSString *const kWCUserSettingsKeyGroupTeams;
extern NSString *const kWCUserSettingsKeyGroupData;
extern NSString *const kWCUserSettingsKeyAppOpenTiemCount;
extern NSString *const kWCUserSettingsKeyAppNeverOpened;

extern NSUInteger const kWCNumberOfTeamsInOneGroup;
extern NSUInteger const kWCNumberOfAllTeams;

//match event in Calendar
extern NSString *const  kWCUserSettingsKeyMatchesInCalendar;


// for map view
extern CGFloat const kWCMetersPerMile;


// for networking
#define  URL_TEST_GET_ALL_GAMES         [[NSBundle mainBundle] URLForResource:@"AllGames" withExtension:@".json"]
#define  URL_TEST_GET_GROUP_RESULTS     [[NSBundle mainBundle] URLForResource:@"GroupResults" withExtension:@".json"]
#define  URL_LIVE_GET_ALL_GAMES         [NSURL URLWithString: @"http://www.xmartcalc.com/wc2014/AllGames.json"]


@interface NSObject (Consts)

+(BOOL )shouldShowIAd;
+(CGFloat)iAdViewHeight;
+(CGFloat)transform3D_M34;

+(NSUInteger)applicationCanRunWithoutIAdMaxTime;

@end
