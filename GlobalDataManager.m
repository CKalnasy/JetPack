//
//  GlobalDataManager.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "GlobalDataManager.h"


 @implementation GlobalDataManager
@synthesize scoreRaw, scoreActual, fuel, numCoins, totalCoins, totalGames, highScore, cb, player, isPaused, maxFuel, playerColor, numSecondsBoost, numSecondsDoublePoints, numSecondsInvy, isSoundOn;

static GlobalDataManager *sharedGlobalDataManager = nil;


+(GlobalDataManager *)sharedGlobalDataManager {
    if(sharedGlobalDataManager == nil)
    {
        sharedGlobalDataManager = [[GlobalDataManager alloc] init];
    }
    return sharedGlobalDataManager;
}

+(int) scoreRaw{
    return [GlobalDataManager sharedGlobalDataManager].scoreRaw;
}
+(void) setScoreRaw: (int)num{
    [GlobalDataManager sharedGlobalDataManager].scoreRaw = num;
}

+(int) scoreActual{
    return [GlobalDataManager sharedGlobalDataManager].scoreActual;
}
+(void) setScoreActual:(int)num{
    [GlobalDataManager sharedGlobalDataManager].scoreActual = num;
}

+(int) numCoins{
    return [GlobalDataManager sharedGlobalDataManager].numCoins;
}
+(void) setNumCoins: (int)num{
    [GlobalDataManager sharedGlobalDataManager].numCoins = num;
}

+(int) fuel{
    return [GlobalDataManager sharedGlobalDataManager].fuel;
}
+(void) setFuel: (int)num{
    [GlobalDataManager sharedGlobalDataManager].fuel = num;
}

+(int) maxFuelWithDict{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].maxFuel = [[dataDict valueForKey:@"max fuel"]integerValue];
    return [GlobalDataManager sharedGlobalDataManager].maxFuel;
}
+(void) setMaxFuelWithDict:(int)num{
    [GlobalDataManager sharedGlobalDataManager].maxFuel = num;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

    [dataDict setObject:[NSNumber numberWithInteger:num] forKey:@"max fuel"];
    [dataDict writeToFile:plistPath atomically:YES];
}

+(int) totalCoinsWithDict{
    return [GlobalDataManager sharedGlobalDataManager].totalCoins;
}
+(void) setTotalCoinsWithDict:(int)num {
    [GlobalDataManager sharedGlobalDataManager].totalCoins = num;
    
    //stats.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [statsDict setValue:[NSNumber numberWithInt:num] forKey:@"coins collected"];
    [statsDict writeToFile:plistPath atomically:YES];
}

+(int) totalGamesWithDict{
    return [GlobalDataManager sharedGlobalDataManager].totalGames;
}
+(void) setTotalGamesWithDict:(int)num {
    [GlobalDataManager sharedGlobalDataManager].totalGames = num;
    
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setValue:[NSNumber numberWithInt:num] forKey:@"total games"];
    [dataDict writeToFile:plistPath atomically:YES];
}

+(int) highScoreWithDict {
    return [GlobalDataManager sharedGlobalDataManager].highScore;
}
+(void) setHighScoreWithDict:(int)num {
    [GlobalDataManager sharedGlobalDataManager].highScore = num;
    
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setValue:[NSNumber numberWithInt:num] forKey:@"high score"];
    [dataDict writeToFile:plistPath atomically:YES];
}


+(Chartboost*) cb{
    return [GlobalDataManager sharedGlobalDataManager].cb;
}
+(void) setCB:(Chartboost *)cbv{
    [GlobalDataManager sharedGlobalDataManager].cb = cbv;
}

+(Player*) player{
    return [GlobalDataManager sharedGlobalDataManager].player;
}
+(void) setPlayer:(Player *)_player{
    [GlobalDataManager sharedGlobalDataManager].player = _player;
}

+(BOOL) isPaused{
    return [GlobalDataManager sharedGlobalDataManager].isPaused;
}
+(void) setIsPaused:(BOOL)_isPaused{
    [GlobalDataManager sharedGlobalDataManager].isPaused = _isPaused;
}

+(NSString*) playerColorWithDict {
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSString* color = [dataDict objectForKey:@"clothes"];
    [GlobalDataManager sharedGlobalDataManager].playerColor = color;
    
    return color;
}
+(void) setPlayerColorWithDict:(NSString*)name {
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:name forKey:@"clothes"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].playerColor = name;
}


+(int) numSecondsBoostWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsBoost = [[dataDict valueForKey:@"max seconds boost"]integerValue];
    return [GlobalDataManager sharedGlobalDataManager].numSecondsBoost;
}
+(void) setNumSecondsBoostWithDict:(int)num {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:num] forKey:@"max seconds boost"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsBoost = num;
}


+(int) numSecondsDoublePointsWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsDoublePoints = [[dataDict valueForKey:@"max seconds double points"]integerValue];
    return [GlobalDataManager sharedGlobalDataManager].numSecondsDoublePoints;
}
+(void) setNumSecondsDoublePointsWithDict:(int)num {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:num] forKey:@"max seconds double points"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsDoublePoints = num;
}


+(int) numSecondsInvyWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsInvy = [[dataDict valueForKey:@"max seconds invy"]integerValue];
    return [GlobalDataManager sharedGlobalDataManager].numSecondsInvy;
}
+(void) setNumSecondsInvyWithDict:(int)num {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

    [dataDict setObject:[NSNumber numberWithInteger:num] forKey:@"max seconds invy"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].numSecondsInvy = num;
}


+(void) setIsSoundOnWithDict:(BOOL)on {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:on] forKey:@"is sound on"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isSoundOn = on;
}
+(BOOL) isSonudOnWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isSoundOn = [[dataDict valueForKey:@"is sound on"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isSoundOn;
}



- (void) dealloc
{
    /*[sharedGlobalDataManager release];
	[super dealloc];*/
}
@end