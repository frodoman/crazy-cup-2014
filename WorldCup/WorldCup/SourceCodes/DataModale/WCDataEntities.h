//
//  WCDataEntities.h
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

// the Json file format will be like this:
/*
 
 .././AllGames.json
 {
    AllGames:
    {
        start: TimeItem,
        end:   TimeItem,
        groupGames: GameItem,
        eighthGams: GameItem,
        quarterGames: GameItem,
        simiGames: GameItem,
        thirdGame: GameItem,
        finalGame: GameItem
    }
 }
 
 TimeItem:
 {
    timeZone: -2,
    time:"20140622, 13:00"
 }
 
 
 
 
 
 
 
 .././GroupGameResult.json
 [
    OneGroupResult,
    OneGroupResult,
    ... 
    ( 8 groups )
 ]
 
 */
 

#import <Foundation/Foundation.h>


//Entities for objects coming from the Json file

//-------------------------------------------------------------
// data for common use
//
//
//-------------------------------------------------------------

@interface WCBaseData : NSObject
@property(nonatomic, copy) NSString *statusString;
@property(nonatomic) NSUInteger itemID;

-(id)initWithDictionary: (NSDictionary*)oneDic;
-(id)initWithArray: (NSArray*) itemArray;

@end

@interface LocationItem : WCBaseData
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *stadiumName;
@property(nonatomic) CGFloat  latitude;
@property(nonatomic) CGFloat  longitude;
@property(nonatomic) NSInteger timeZone;

+(NSArray *) locationArray;

+(LocationItem*)findLocationByCityName: (NSString*)cityName;

@end

@interface TimeItem : WCBaseData
@property(nonatomic) NSInteger timeZone;
@property(nonatomic, copy) NSString* timeInString;
@property(nonatomic, strong) NSDate *localTime;
@property(nonatomic, strong) NSDate *gmtTime;
@property(nonatomic, copy) NSString *localTimeString;

-(id)initWithDictionary: (NSDictionary*)timeDic;

//-(NSString*)localTimeString;

@end

// data about one team
@interface OneTeam : WCBaseData
@property(nonatomic) BOOL favourited;
@property (nonatomic, copy) NSString *teamName;

+(NSArray*)allTeams;

-(id)initWithTeamName:(NSString*)teamName;

@end

//-------------------------------------------------------------
// data for results
//
//
//-------------------------------------------------------------
//

// one team result in the group stage
@interface OneTeamResult : WCBaseData
@property (nonatomic,strong) OneTeam *teamDetails;

@property(nonatomic) NSUInteger played;
@property(nonatomic) NSUInteger won;
@property(nonatomic) NSUInteger drawn;
@property(nonatomic) NSUInteger lost;
@property(nonatomic) NSUInteger goalsFor;
@property(nonatomic) NSUInteger goalsAgainst;
@property(nonatomic) NSInteger goalDifference;
@property(nonatomic) NSUInteger points;

-(id)initWithTeamName: (NSString*)teamName;
-(NSArray*)resultArray;

@end



// result for one group
@interface OneGroupResult : WCBaseData

@property (nonatomic, copy) NSString *statusString; // ON/DONE/NotOn
@property (nonatomic, copy) NSString *groupName;

@property(nonatomic, strong) NSArray *teamResults;

-(id)initWithGroupName:(NSString*)groupName
                 teams: (NSArray*)arrayOfNames;


@end


//-------------------------------------------------------------
// data for matches/games
//
//
//-------------------------------------------------------------
//
@interface OneMatch : WCBaseData

@property(nonatomic, copy) NSString * status;
@property(nonatomic, strong) LocationItem *location;
@property(nonatomic, strong) TimeItem *startTime;
@property(nonatomic, strong) TimeItem *endTime;
@property(nonatomic, strong) OneTeam *teamA;
@property(nonatomic, strong) OneTeam *teamB;
@property(nonatomic) NSUInteger goalsCountA;
@property(nonatomic) NSUInteger goalsCountB;

@property(nonatomic, copy) NSString* matchEventID;

-(id)initWithDictionary: (NSDictionary*)matchDic;

-(BOOL) matchNotStarted;
-(BOOL) matchStarted;
-(BOOL) matchFinished;
-(BOOL) hasThisTeam: (NSString*)teamName;
-(BOOL) inTeamA: (NSString*)teamName;

@end

@interface GamesItem : WCBaseData
// each item will be OneMatch
@property(nonatomic, strong) NSMutableArray *games;
@property(nonatomic, strong) NSArray *sectionBySameDays;
@property(nonatomic, strong) NSArray *dayArray;

-(NSArray*)gamesByTheSameDate: (NSDate*)gameStartDate;

@end


@interface AllGames : WCBaseData
@property(nonatomic, strong) TimeItem *startTime;
@property(nonatomic, strong) TimeItem *endTime;
@property(nonatomic, strong) TimeItem *updatedTime;
@property(nonatomic, strong) GamesItem *groupGames;
@property(nonatomic, strong) GamesItem *eighthFinalGames;
@property(nonatomic, strong) GamesItem *quarterFinalGames;
@property(nonatomic, strong) GamesItem *semiFinalGames;
@property(nonatomic, strong) GamesItem *thirdPlaceGame;
@property(nonatomic, strong) GamesItem *finalGame;

@property(nonatomic) NSInteger latestMatchID;
@property(nonatomic) NSInteger latestMatchSection;

-(NSArray*)gamesForOneTeam: (NSString*)teamName;
-(NSArray*)gamesForOneLocation: (NSString*)cityName;

-(NSUInteger)findLatestMatchID;
-(NSUInteger)findLatestMatchInSection;


@end



//-------------------------------------------------------------
// Root data Manager
//
//
//-------------------------------------------------------------
//
@interface WCDataEntities : NSObject

//each item will be OneGroupResult
@property(nonatomic, strong) NSMutableArray *groupStageResults;

//array about all the matches
@property(nonatomic, strong) AllGames *allGames;

+(WCDataEntities*)sharedDataManager;

-(void)logAllGames;
-(void)logGroupResults;
-(void)analyseGroupResults;

@end
