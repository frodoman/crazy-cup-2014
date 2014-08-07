//
//  WCDataEntities.m
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCDataEntities.h"
#import "NSObject+Consts.h"
#import "WCUserSettings.h"
//-------------------------------------------------------------
// data for common use
//
//
//-------------------------------------------------------------
//

//---------------------
// WCBaseData Start
//---------------------
@implementation WCBaseData
-(id)initWithArray:(NSArray *)itemArray
{
    self = [super init];
    return self;
}

-(id)initWithDictionary:(NSDictionary *)oneDic
{
    self = [super init];
    return self;
}
@end
//---------------------
// WCBaseData End
//---------------------


//---------------------
// LocationItem
//---------------------

static NSArray *_locationArray;

@implementation LocationItem

+(NSArray *) locationArray
{
    if(_locationArray != nil && _locationArray.count > 0)
    {
        return _locationArray;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Locations" withExtension:@"json" ];
    NSData *data = [[NSData alloc] initWithContentsOfURL: url ];
    
    NSError *jsonError = nil;
    NSArray *jsonResult = [NSJSONSerialization JSONObjectWithData:  data
                                                               options:NSJSONReadingMutableLeaves error:&jsonError];
    if(jsonError)
    {
        NSLog( @"JSON Error: %@", jsonError.debugDescription);
        return nil;
    }
    
    NSMutableArray *locations = [NSMutableArray array];
    for (NSDictionary *oneDic in jsonResult)
    {
        LocationItem *oneLocation = [[LocationItem alloc] initWithDictionary: oneDic ];
        [locations addObject: oneLocation ];
    }
    
    _locationArray = nil;
    _locationArray = [[NSArray alloc] initWithArray: locations ];
    return _locationArray;
}

+(LocationItem*)findLocationByCityName: (NSString*)cityName
{
    NSArray *locations = [LocationItem locationArray];
    
    LocationItem *foundLocation = nil;
    
    for( LocationItem *oneLocation in locations)
    {
        if( [oneLocation.cityName isEqualToString: cityName])
        {
            foundLocation = oneLocation;
            break;
        }
    }
    
    return foundLocation;
}


-(id)initWithDictionary:(NSDictionary *)oneDic
{
    self = [super init];
    if(self)
    {
        [self parseDictionary: oneDic];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_cityName forKey:@"cityName"];
    [encoder encodeObject:_stadiumName forKey:@"stadiumName"];
    
    NSNumber *numberLat = [NSNumber numberWithBool: self.latitude];
    [encoder encodeObject:numberLat forKey:@"latitude"];
    
    NSNumber *numberLong = [NSNumber numberWithBool: self.longitude];
    [encoder encodeObject:numberLong forKey:@"longitude"];
    
    NSNumber *numberTimeZone = [NSNumber numberWithBool: self.timeZone];
    [encoder encodeObject:numberTimeZone forKey:@"timeZone"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.cityName = [decoder decodeObjectForKey:@"cityName"];
    self.stadiumName = [decoder decodeObjectForKey:@"stadiumName"];
    
    NSNumber *numberLat =[decoder decodeObjectForKey:@"latitude"];
    self.latitude = [numberLat floatValue];

    NSNumber *numberLong =[decoder decodeObjectForKey:@"longitude"];
    self.longitude = [numberLong floatValue];
    
    NSNumber *numberTimeZone =[decoder decodeObjectForKey:@"timeZone"];
    self.timeZone = [numberTimeZone floatValue];
    
    return self;
}

-(void)parseDictionary:(NSDictionary*)oneDic
{
    NSString *city = [oneDic objectForKey: kJsonKeyCity];
    if(city)
    {
        self.cityName = city;
    }
 
    NSString *stadium = [oneDic objectForKey: kJsonKeyStadium];
    if(stadium)
    {
        self.stadiumName = stadium;
    }
    else
    {
        [self findLocationWithCityName: city forLocationItem: self];
        return;
    }
    
    NSNumber *numberLat = [oneDic objectForKey: kJsonKeyLatitude];
    if( numberLat)
    {
        self.latitude = [numberLat floatValue];
    }
    
    NSNumber *numberLog = [oneDic objectForKey: kJsonKeyLongitude];
    if(numberLog)
    {
        self.longitude = [numberLog floatValue];
    }
    
    NSNumber *numberTimeZone = [oneDic objectForKey: kJsonKeyTimeZone];
    if(numberTimeZone)
    {
        self.timeZone = [numberTimeZone integerValue];
    }
}

-(void)findLocationWithCityName: (NSString*)cityName
                forLocationItem: (LocationItem*)targetLocation
{
    BOOL found = NO;
    NSArray *locations = [LocationItem locationArray];
    
    for (LocationItem *oneLocation in locations)
    {
        if( [oneLocation.cityName isEqualToString: cityName])
        {
            targetLocation.stadiumName = oneLocation.stadiumName;
            targetLocation.latitude = oneLocation.latitude;
            targetLocation.longitude= oneLocation.longitude;
            targetLocation.timeZone = oneLocation.timeZone;
            
            found = YES;
            break;
        }
    }
    if(!found)
    {
        NSLog(@"Location with City Name Not Found! %@ ", cityName);
    }
    return;
}


@end
//---------------------
// LocationItem End
//---------------------


//---------------------
// TimeItem
//---------------------
@implementation TimeItem
-(id)initWithDictionary: (NSDictionary*)timeDic
{
    self = [super init];
    if(self)
    {
        [self parseDataFromDictionary: timeDic];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_timeInString forKey:@"timeInString"];
    [encoder encodeObject:_localTime forKey:@"localTime"];
    
    NSNumber *numberTimeZone = [NSNumber numberWithBool: self.timeZone];
    [encoder encodeObject:numberTimeZone forKey:@"timeZone"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.timeInString = [decoder decodeObjectForKey:@"timeInString"];
    self.localTime = [decoder decodeObjectForKey:@"localTime"];
    
    NSNumber *numberTimeZone =[decoder decodeObjectForKey:@"timeZone"];
    self.timeZone = [numberTimeZone integerValue];
    
    return self;
}


-(void) parseDataFromDictionary: (NSDictionary*)timeDic
{
    NSNumber *timeZoneNumber = [timeDic objectForKey: kJsonKeyTimeZone];
    if(timeZoneNumber)
    {
        self.timeZone = [timeZoneNumber integerValue];
    }
    else
    {
        self.timeZone = -3;
    }
    
    NSString *timeString = [timeDic objectForKey: kJsonKeyTime];
    if(timeString)
    {
        self.timeInString = timeString;
    }
 
    [self calculateLocalTime];
     
}

-(void)setTimeZone:(NSInteger)timeZone
{
    _timeZone = timeZone;
    
    [self calculateLocalTime];
}


-(void)calculateLocalTime
{
    if(self.timeInString == nil || self.timeInString.length==0)
    {
        return;
    }
    
    NSString* input = self.timeInString;
    NSString* format = @"yyyyMMdd, HH:mm";
    
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:self.timeZone*60*60]];
    
    // Cast the input string to UTC time: GMT-0
    self.gmtTime = [formatterUtc dateFromString:input];
    
    NSString* formatString = @"dd/MMM/yyyy, HH:mm";
    if( [WCUserSettings systemLanguageInChinese])
    {
        formatString = @"yyyy/MM/dd, HH:mm";
    }
    
    // UTC time in string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
    //NSString *utcDateString= [formatter stringFromDate: self.gmtTime];
    
    
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = [tz secondsFromGMT];
    NSTimeZone *localTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: seconds];
    
    // format it for local time string
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init] ;
    [localDateFormatter setDateFormat:formatString];
    [localDateFormatter setTimeZone :localTimeZone];
    self.localTimeString = [localDateFormatter stringFromDate: self.gmtTime];
    
    // local time
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    //[formatter setTimeZone: localTimeZone];
    NSDate* dateTemp =[self.gmtTime dateByAddingTimeInterval:timeZoneSeconds];
    self.localTime = [dateTemp dateByAddingTimeInterval:-60*60];
    //[self convertDate:dateTemp toTimeZone:@"GMT"];
    //[formatter dateFromString: utcDateString];
    //[localDateFormatter dateFromString: [formatterUtc stringFromDate: utcDate]];
    

//    NSString *dateString = self.localTimeString;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: formatString];
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:sourceTimeZone];
//    self.localTime = [dateFormatter dateFromString:dateString];
//    self.localTime = [self.localTime dateByAddingTimeInterval: -60*60];
    
//    NSLog(@"------------------\nTime Zone: %ld", self.timeZone);
//    NSLog(@"In file: %@", self.timeInString);
//    NSLog(@"utc:   %@", self.gmtTime);
//    NSLog(@"utc String: %@", utcDateString);
//    NSLog(@"local: %@", self.localTime);
//    NSLog(@"LocalTimeString: %@", self.localTimeString);
}

- (NSDate *) convertDate:(NSDate *) date
              toTimeZone:(NSString *) timeZoneAbbreviation {
    
    NSTimeZone *systemZone  = [NSTimeZone systemTimeZone];
    NSTimeZone *zoneUTC     = [NSTimeZone timeZoneWithAbbreviation:timeZoneAbbreviation];
    NSTimeInterval s        = [zoneUTC secondsFromGMT];
    
    NSTimeZone *myZone      = [NSTimeZone timeZoneWithAbbreviation:[systemZone abbreviationForDate:date]];
    NSTimeInterval p        = [myZone secondsFromGMT];
    
    NSTimeInterval i = s-p;
    NSDate *d = [NSDate dateWithTimeInterval:i sinceDate:date];
    
    return d;
    
}

//-(NSString*)localTimeString
//{
//    NSString* format = @"dd MMM yyyy, HH:mm";
//    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
//    [formatterLocal setDateFormat:format];
//    
//    NSString *strTime = [formatterLocal stringFromDate: self.localTime];
//    return strTime;
//}


@end
//---------------------
// TimeItem End
//---------------------


//---------------------
// OneTeam
//---------------------

static NSArray *_allTeams;
@implementation OneTeam

+(NSArray*)allTeams
{
    if(_allTeams != nil && _allTeams.count>0 )
    {
        return _allTeams;
    }
    
    if([WCUserSettings hasGroupData])
    {
        return [WCUserSettings allTeams];
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"AllTeamNames" withExtension:@"json" ];
    NSData *data = [[NSData alloc] initWithContentsOfURL: url ];
    
    NSError *jsonError = nil;
    NSArray *jsonResult = [NSJSONSerialization JSONObjectWithData:  data
                                                          options:NSJSONReadingMutableLeaves error:&jsonError];
    if(jsonError)
    {
        NSLog( @"JSON Error: %@ \n\u3305", jsonError.debugDescription);
        return nil;
    }
    
    NSMutableArray *teams = [NSMutableArray array];
    for (NSString *teamName in jsonResult)
    {
        OneTeam *aTeam = [[OneTeam alloc] initWithTeamName: teamName];
        [teams addObject: aTeam ];
    }
    _allTeams = nil;
    _allTeams = [[NSMutableArray alloc] initWithArray: teams] ;
    
    return _allTeams;
}

+(OneTeam*)teamByName: (NSString*)teamName
{
    OneTeam *foundTeam = nil;
    
    for (OneTeam *aTeam in [OneTeam allTeams])
    {
        if([aTeam.teamName isEqualToString: teamName ])
        {
            foundTeam = aTeam;
            break;
        }
    }
    
    if(!foundTeam)
    {
        foundTeam = [[OneTeam alloc] initWithTeamName: teamName ];
    }
    
    return foundTeam;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_teamName forKey:@"teamName"];
    
    NSNumber *number = [NSNumber numberWithBool: _favourited];
    [encoder encodeObject:number forKey:@"favourited"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.teamName = [decoder decodeObjectForKey:@"teamName"];
    
    NSNumber *number =[decoder decodeObjectForKey:@"favourited"];
    self.favourited = [number boolValue];
    
    return self;
}

-(id)initWithTeamName:(NSString*)teamName
{
    self = [super init];
    if(self)
    {
        self.teamName = teamName;
        self.favourited = NO;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)oneDic
{
    NSString *name = [oneDic objectForKey: kJsonKeyName ];
    if(name)
    {
        return  [OneTeam teamByName: name ];
    }
    else
    {
     return nil;
    }
}

@end
//---------------------
// OneTeam End
//---------------------



//-------------------------------------------------------------
// data for matches
//
//
//-------------------------------------------------------------
//


//---------------------
// OneMatch
//---------------------
@implementation OneMatch

-(id)initWithDictionary:(NSDictionary *)matchDic
{
    self = [super init];
    if(self)
    {
        [self parseMatchDictionary:matchDic];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    NSNumber *numberID = [NSNumber numberWithInteger: self.itemID];
    [encoder encodeObject: numberID forKey:@"itemID"];
    
    [encoder encodeObject:_status forKey:@"status"];
    [encoder encodeObject: _location forKey:@"location"];
    [encoder encodeObject: _startTime forKey:@"startTime"];
    [encoder encodeObject: _endTime   forKey:@"endTime"];
    [encoder encodeObject: _teamA forKey:@"teamA"];
    [encoder encodeObject: _teamB forKey:@"teamB"];
    [encoder encodeObject: _matchEventID forKey:@"matchEventID"];
    
    NSNumber *numberA = [NSNumber numberWithBool: _goalsCountA];
    [encoder encodeObject:numberA forKey:@"goalsCountA"];
    
    NSNumber *numberB = [NSNumber numberWithBool: _goalsCountB];
    [encoder encodeObject:numberB forKey:@"goalsCountB"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    NSNumber *numberID = [decoder decodeObjectForKey: @"itemID"];
    self.itemID = [numberID integerValue];
    
    self.status = [decoder decodeObjectForKey:@"status"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.endTime = [decoder decodeObjectForKey:@"endTime"];
    self.teamA = [decoder decodeObjectForKey:@"teamA"];
    self.teamB =[decoder decodeObjectForKey:@"teamB"];
    self.matchEventID = [decoder decodeObjectForKey: @"matchEventID"];
    
    NSNumber *numberA = [decoder decodeObjectForKey:@"goalsCountA"];
    self.goalsCountA = [numberA integerValue];
    
    NSNumber *numberB = [decoder decodeObjectForKey:@"goalsCountB"];
    self.goalsCountB =  [numberB integerValue];
    
    return self;
}

-(void) parseMatchDictionary: (NSDictionary*)matchDic
{
    //match ID
    NSNumber *numberId = [matchDic objectForKey: kJsonKeyMatchID];
    if(numberId)
    {
        self.itemID = [numberId integerValue];
    }
    
    NSString *statusString = [matchDic objectForKey: kJsonKeyStatus];
    if( statusString)
    {
        self.status = statusString;
    }
    
    //location
    NSDictionary *locationDic = [matchDic objectForKey: kJsonKeyLocation];
    if(locationDic)
    {
        LocationItem *oneLocation = [[LocationItem alloc] initWithDictionary: locationDic];
        self.location = oneLocation;
    }
    
    //start time
    NSDictionary *timeDic = [matchDic objectForKey: kJsonKeyStartTime];
    if(timeDic)
    {
        self.startTime = [[TimeItem alloc] initWithDictionary: timeDic];
        
        if([self.location.cityName isEqualToString: kWCCityNameForTimeZone4 ] ||
           [self.location.cityName isEqualToString: kWCCityNameForTimeZone4_2 ])
        {
            self.startTime.timeZone = -4;
        }
    }
    
    //teamA
    NSDictionary *teamADic = [matchDic objectForKey: kJsonKeyTeamA];
    if(teamADic)
    {
        self.teamA = [[OneTeam alloc] initWithDictionary: teamADic];
    }
    
    //teamB
    NSDictionary *teamBDic = [matchDic objectForKey: kJsonKeyTeamB];
    if(teamBDic)
    {
        self.teamB = [[OneTeam alloc] initWithDictionary: teamBDic];
    }
    
    //goal A
    NSNumber *numberA = [matchDic objectForKey: kJsonKeyGoalsA];
    if( numberA)
    {
        self.goalsCountA = [numberA integerValue];
    }
    
    //goal B
    NSNumber *numberB = [matchDic objectForKey: kJsonKeyGoalsB];
    if(numberB)
    {
        self.goalsCountB = [numberB integerValue];
    }
}

-(BOOL) matchNotStarted
{
    if([self.status isEqualToString: kWCMatchStatusNotOn ])
    {
        return YES;
    }
    return NO;
}

-(BOOL) matchStarted
{
    if([self.status isEqualToString: kWCMatchStatusOn])
    {
        return YES;
    }
    return NO;
}

-(BOOL) matchFinished
{
    if([self.status isEqualToString: kWCMatchStatusFinished])
    {
        return YES;
    }
    return NO;
}

-(BOOL) hasThisTeam: (NSString*)teamName
{
    if( [teamName isEqualToString: self.teamA.teamName ] ||
        [teamName isEqualToString: self.teamB.teamName])
    {
        return YES;
    }
    return NO;
}

-(BOOL)inTeamA: (NSString*)teamName
{
    if( [teamName isEqualToString: self.teamA.teamName ])
    {
        return YES;
    }
    return NO;
}

@end
//---------------------
// OneMatch
//---------------------


//---------------------
// GamesItem
//---------------------
@implementation GamesItem

-(id ) initWithArray:(NSArray *)arrayOfMatches
{
    self = [super init];
    if(self)
    {
        [self parseAllMatches: arrayOfMatches];
    }
    return self;
}
-(void)parseAllMatches:(NSArray*) arrayOfMatches
{
    self.games = [NSMutableArray array];
        for(NSDictionary * oneMatchDic in arrayOfMatches)
        {
            OneMatch *aMatch = [[OneMatch alloc] initWithDictionary: oneMatchDic];
            [self.games addObject: aMatch];
        }
}

-(NSArray*)sectionBySameDays
{
    if(_sectionBySameDays&& _sectionBySameDays.count>0)
    {
        return _sectionBySameDays;
    }
    
    //how many difference days
    [self findDayArray];
    
    NSMutableArray *sections = [NSMutableArray array];
    for(NSDate *tempDate in self.dayArray)
    {
        NSArray *gameInSameDay = [self gamesByTheSameDate: tempDate];
        [sections addObject: gameInSameDay];
    }
    
    _sectionBySameDays = [[NSArray alloc] initWithArray: sections];
    return  _sectionBySameDays;
}

-(void)findDayArray
{
    if(self.dayArray && self.dayArray.count>0)
    {
        return;
    }
    
    if(self.games.count == 0)
    {
        return;
    }
    
    NSMutableArray *arrayOfDay = [NSMutableArray array];
    OneMatch *firstMatch = [self.games firstObject];
    
    NSDate *date1 = firstMatch.startTime.localTime;
    [arrayOfDay addObject: date1];
    
    //more than 1 games
    if(self.games.count>1)
    {
        for(NSUInteger gameIndex = 1; gameIndex<self.games.count; gameIndex++)
        {
            OneMatch *theMatch = [self.games objectAtIndex: gameIndex];
            NSDate *date2 =theMatch.startTime.localTime;
            if(date2)
            {
            if(![self date: date1 isOnTheSameDateWith: date2] &&
               ![self dayArray: arrayOfDay hasThisDate: date2])
            {
                [arrayOfDay addObject: date2];
                date1 = date2;
            }
            }
        }
    }
    
    self.dayArray = [[NSArray alloc] initWithArray: arrayOfDay ];
}

-(BOOL) dayArray: (NSArray*)dayArray hasThisDate: (NSDate*)aDate
{
    if(dayArray.count == 0)
    {
        return NO;
    }
    BOOL foundDate = NO;
    for(NSDate *dayInArray in dayArray)
    {
        if( [self date: dayInArray isOnTheSameDateWith: aDate])
        {
            foundDate = YES;
            break;
        }
    }
    return foundDate;
}

-(NSArray*)gamesByTheSameDate:(NSDate *)gameStartDate
{
    NSMutableArray *array = [NSMutableArray array];
    for (OneMatch *aMatch in self.games)
    {
        NSDate *matchDate = aMatch.startTime.localTime;
        if( [self date:matchDate isOnTheSameDateWith:gameStartDate])
        {
            [array addObject: aMatch];
        }
    }
    
    return  array;
}

-(BOOL) date: (NSDate*)date1 isOnTheSameDateWith: (NSDate*)date2
{
    if(date1 == nil || date2 == nil)
    {
        return NO;
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    if([comp1 day]   == [comp2 day] &&
       [comp1 month] == [comp2 month] &&
       [comp1 year]  == [comp2 year])
    {
        return YES;
    }
    return NO;
}

@end
//---------------------
// GamesItem
//---------------------



//---------------------
// AllGames
//---------------------
@implementation AllGames

/*
 
*/
-(id) initWithDictionary: (NSDictionary*)allGamesDic
{
    self = [super init];
    if(self)
    {
        [self parseAllData: allGamesDic];
        
        self.latestMatchID = -1;
        self.latestMatchSection= -1;
        
        [self findLatestMatchInSection];
    }
    return self ;
}

-(void)parseAllData:(NSDictionary*)allGamesDic
{
    NSDictionary *startTimeDic = [allGamesDic objectForKey: kJsonKeyStartTime];
    if(startTimeDic)
    {
        TimeItem *timeItem = [[TimeItem alloc] initWithDictionary:startTimeDic];
        self.startTime = timeItem;
    }
    
    NSDictionary *updateTimeDic = [allGamesDic objectForKey: kJsonKeyLastUpdateTime];
    if(updateTimeDic)
    {
        TimeItem *timeItem = [[TimeItem alloc] initWithDictionary: updateTimeDic];
        self.updatedTime= timeItem;
    }
    
    //pars in group games
    NSArray *groupGameArray = [allGamesDic objectForKey: kJsonKeyGroupGames];
    if(groupGameArray && groupGameArray.count>0)
    {
        self.groupGames = [[GamesItem alloc] initWithArray: groupGameArray];
    }
    
    //parse in games of round 16
    NSArray *round16Games = [allGamesDic objectForKey: kJsonKeyRoundOf16Games];
    if( round16Games && round16Games.count>0)
    {
        self.eighthFinalGames = [[GamesItem alloc] initWithArray: round16Games];
    }
    
    //parse in quater final games
    NSArray *quaterGames = [allGamesDic objectForKey: kJsonKeyQuarterGames];
    if( quaterGames && quaterGames.count>0)
    {
        self.quarterFinalGames = [[GamesItem alloc] initWithArray: quaterGames];
    }
    
    // semi final games
    NSArray *semiGames = [allGamesDic objectForKey: kJsonKeySemiGames];
    if( semiGames && semiGames.count>0)
    {
        self.semiFinalGames = [[GamesItem alloc] initWithArray: semiGames];
    }

    //third place game
    NSArray *thirdGame = [allGamesDic objectForKey: kJsonKeyThirdGame];
    if( thirdGame && thirdGame.count>0)
    {
        self.thirdPlaceGame = [[GamesItem alloc] initWithArray: thirdGame];
    }

    // final game
    NSArray *finalGame = [allGamesDic objectForKey: kJsonKeyFinalGame];
    if( finalGame && finalGame.count>0)
    {
        self.finalGame = [[GamesItem alloc] initWithArray: finalGame];
    }

}

-(NSArray*)gamesForOneTeam: (NSString*)teamName
{
    NSMutableArray *games =[ NSMutableArray array];
    
    [self findMatchesInGames: self.groupGames.games forMatchArray:games withTeamName: teamName inCity:nil];
    [self findMatchesInGames: self.eighthFinalGames.games forMatchArray:games withTeamName:teamName inCity:nil];
    [self findMatchesInGames: self.quarterFinalGames.games forMatchArray: games withTeamName:teamName inCity:nil];
    [self findMatchesInGames: self.semiFinalGames.games forMatchArray: games withTeamName:teamName inCity:nil];
    [self findMatchesInGames: self.thirdPlaceGame.games forMatchArray: games withTeamName:teamName inCity:nil];
    [self findMatchesInGames: self.finalGame.games forMatchArray: games withTeamName:teamName inCity:nil];
    
    return  (NSArray*)games;
}

-(NSArray*)gamesForOneLocation: (NSString*)cityName
{
    NSMutableArray *games =[ NSMutableArray array];
    
    [self findMatchesInGames: self.groupGames.games forMatchArray: games withTeamName: nil inCity:cityName];
    [self findMatchesInGames: self.eighthFinalGames.games forMatchArray: games withTeamName:nil inCity:cityName];
    [self findMatchesInGames: self.quarterFinalGames.games forMatchArray: games withTeamName:nil inCity:cityName];
    [self findMatchesInGames: self.semiFinalGames.games forMatchArray: games withTeamName:nil inCity:cityName];
    [self findMatchesInGames: self.thirdPlaceGame.games forMatchArray: games withTeamName:nil inCity:cityName];
    [self findMatchesInGames: self.finalGame.games forMatchArray: games withTeamName:nil inCity:cityName];
    
    return (NSArray*)games;
}

-(void)findMatchesInGames: (NSArray*) games
            forMatchArray: (NSMutableArray*)targetArray
             withTeamName: (NSString*)teamName
                   inCity: (NSString*)cityName
{
 
    for (OneMatch *aMatch in games)
    {
        if(teamName )
        {
            if([aMatch.teamA.teamName isEqualToString: teamName]||
               [aMatch.teamB.teamName isEqualToString: teamName])
            {
                [targetArray addObject: aMatch];
            }
        }
        
        if(cityName)
        {
            if([aMatch.location.cityName isEqualToString: cityName])
            {
                [targetArray addObject: aMatch];
            }
        }
    }
}

-(NSUInteger)findLatestMatchID
{
    if(self.latestMatchID>0)
    {
        return self.latestMatchID;
    }
    
    NSMutableArray *allMatches = [NSMutableArray array];
    [allMatches addObjectsFromArray: self.groupGames.games];
    [allMatches addObjectsFromArray: self.eighthFinalGames.games];
    [allMatches addObjectsFromArray: self.quarterFinalGames.games];
    [allMatches addObjectsFromArray: self.semiFinalGames.games ];
    [allMatches addObjectsFromArray: self.thirdPlaceGame.games];
    [allMatches addObjectsFromArray: self.finalGame.games];
    
    NSUInteger matchID = 1;
    for( OneMatch *aMatch in allMatches)
    {
        if([aMatch.status isEqualToString: kWCMatchStatusOn] ||
           [aMatch.status isEqualToString: kWCMatchStatusFinished])
        {
            if( aMatch.itemID > matchID)
            {
                matchID = aMatch.itemID;
            }
        }
    }
    
    self.latestMatchID = matchID;
    return  matchID;
}

-(NSUInteger)findLatestMatchInSection
{
    if(self.latestMatchSection>0)
    {
        return self.latestMatchSection;
    }
    
    NSUInteger matchID = [self findLatestMatchID];
 
    if(matchID<=48)
    {
        self.latestMatchSection = 0;
    }
    else if( matchID>48 && matchID<=56)
    {
        self.latestMatchSection = 1;
    }
    else if(matchID>56 && matchID<=60)
    {
        self.latestMatchSection = 2;
    }
    else if( matchID == 61 || matchID==62)
    {
        self.latestMatchSection = 3;
    }
    else if(matchID == 63)
    {
        self.latestMatchSection = 4;
    }
    else if(matchID == 64)
    {
        self.latestMatchSection = 5;
    }
    
    return self.latestMatchSection;
}


@end
//---------------------
// AllGames
//---------------------



//-------------------------------------------------------------
// Root data Manager
//
//
//-------------------------------------------------------------
//
static WCDataEntities * _dataManager;

@implementation WCDataEntities

+(WCDataEntities*)sharedDataManager
{
    if( _dataManager == nil )
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _dataManager = [[WCDataEntities alloc] init];
        });
    }
    return  _dataManager;
}

#pragma mark - Public
-(void)logAllGames
{
    
}


-(void)logGroupResults
{
    
}

-(void)analyseGroupResults
{
    
}


@end

//-------------------------------------------------------------
// data for results
//
//
//-------------------------------------------------------------
//

//---------------------
// OneTeamResult
//---------------------
@implementation OneTeamResult

-(id)initWithTeamName: (NSString*)teamName
{
    self = [super init];
    if(self)
    {
        self.teamDetails = [OneTeam teamByName: teamName];
        
        [self calculateTeamResults];
    }
    return  self;
}

-(void)calculateTeamResults
{
    NSArray *matches =[WCDataEntities sharedDataManager].allGames.groupGames.games;
    
    for(NSUInteger gameIndex = 0; gameIndex< matches.count; gameIndex++)
    {
        OneMatch *aMatch = [matches objectAtIndex: gameIndex];
        if([aMatch matchFinished] &&
           [aMatch hasThisTeam: self.teamDetails.teamName] )
        {
            BOOL inTeamA = [aMatch inTeamA: self.teamDetails.teamName];
            
            // played
            self.played ++;
            
            //is Team A
            if(inTeamA)
            {
                if(aMatch.goalsCountA > aMatch.goalsCountB)
                {
                    self.won ++;
                }
                else if(aMatch.goalsCountA < aMatch.goalsCountB)
                {
                    self.lost ++;
                }
                else
                {
                    self.drawn ++;
                }
                
                self.goalsFor += aMatch.goalsCountA;
                self.goalsAgainst += aMatch.goalsCountB;
            }
            //is team B
            else
            {
                if(aMatch.goalsCountB > aMatch.goalsCountA)
                {
                    self.won ++;
                }
                else if(aMatch.goalsCountB < aMatch.goalsCountA)
                {
                    self.lost ++;
                }
                else
                {
                    self.drawn ++;
                }
                
                self.goalsFor += aMatch.goalsCountB;
                self.goalsAgainst += aMatch.goalsCountA;
            }
            
            self.goalDifference = self.goalsFor - self.goalsAgainst;
            self.points = 3* self.won + 1*self.drawn;
        }
    }
}

-(NSArray*)resultArray
{
    NSArray *array = [[NSArray alloc] initWithObjects: [NSNumber numberWithInteger: self.played ],
                      [NSNumber numberWithInteger: self.won],
                      [NSNumber numberWithInteger: self.drawn],
                      [NSNumber numberWithInteger: self.lost],
                      [NSNumber numberWithInteger: self.goalsFor],
                      [NSNumber numberWithInteger: self.goalsAgainst],
                      [NSNumber numberWithInteger: self.goalDifference],
                      [NSNumber numberWithInteger: self.points], nil];
    
    return array;
}

@end
//---------------------
// OneTeamResult End
//---------------------

//---------------------
// OneGroupResult
//---------------------
@implementation OneGroupResult

-(id)initWithGroupName:(NSString*) groupName
                 teams: (NSArray*)arrayOfNames
{
    self = [super init];
    if(self)
    {
        self.groupName = groupName;
        
        if( arrayOfNames.count == 4)
        {
            [self initTeamResultsWithArray: arrayOfNames];
        }
    }
    return self;
}

-(void)initTeamResultsWithArray:(NSArray*)arrayOfNames
{
    NSMutableArray *results = [NSMutableArray array];
    for( NSString *teamName in arrayOfNames)
    {
        OneTeamResult *oneResult = [[OneTeamResult alloc] initWithTeamName: teamName ];
        [results addObject: oneResult ];
    }
    self.teamResults = nil;
    self.teamResults = [[NSArray alloc] initWithArray: results ];
}




@end
//---------------------
// OneGroupResult End
//---------------------
