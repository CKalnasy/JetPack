//
//  GlobalDataManager.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "GlobalDataManager.h"


 @implementation GlobalDataManager
@synthesize scoreRaw, scoreActual, fuel, numCoins, totalCoins, totalGames, highScore, cb, player, isPaused, maxFuel, playerColor, numSecondsBoost, numSecondsDoublePoints, numSecondsInvy, isSoundOn, isBlackBought, isBlueBought, isBrownBought, isGreenBought, isGreyBought, isMaroonBought, isPurpleBought, isPinkBought, isYellowBought, isTurquoiseBought, isTanBought, isRedBought, isOrangeBought, isNavyBought,  isMilitaryGreenBought, isPremiumContent, numberOfAllCoins, timeTrialHighScore;

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
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].totalCoins = [[statsDict valueForKey:@"coins collected"]integerValue];
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
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].totalGames = [[statsDict valueForKey:@"total games"]integerValue];
    
    return [GlobalDataManager sharedGlobalDataManager].totalGames;
}
+(void) setTotalGamesWithDict:(int)num {
    [GlobalDataManager sharedGlobalDataManager].totalGames = num;
    
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [statsDict setValue:[NSNumber numberWithInt:num] forKey:@"total games"];
    [statsDict writeToFile:plistPath atomically:YES];
}

+(int) highScoreWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].highScore = [[statsDict valueForKey:@"high score"]integerValue];
    return [GlobalDataManager sharedGlobalDataManager].highScore;
}
+(void) setHighScoreWithDict:(int)num {
    [GlobalDataManager sharedGlobalDataManager].highScore = num;
    
    //data.plist init
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [statsDict setValue:[NSNumber numberWithInt:num] forKey:@"high score"];
    [statsDict writeToFile:plistPath atomically:YES];
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


+(void) setIsBlackBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is black bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isBlackBought = bought;
}
+(BOOL) isBlackBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isBlackBought = [[dataDict valueForKey:@"is black bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isBlackBought;
}

+(void) setIsBlueBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is blue bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isBlueBought = bought;
}
+(BOOL) isBlueBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isBlueBought = [[dataDict valueForKey:@"is blue bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isBlueBought;
}

+(void) setIsBrownBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is brown bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isBrownBought = bought;
}
+(BOOL) isBrownBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isBrownBought = [[dataDict valueForKey:@"is brown bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isBrownBought;
}

+(void) setIsGreenBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is green bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isGreenBought = bought;
}
+(BOOL) isGreenBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isGreenBought = [[dataDict valueForKey:@"is green bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isGreenBought;
}

+(void) setIsGreyBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is grey bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isGreyBought = bought;
}
+(BOOL) isGreyBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isGreyBought = [[dataDict valueForKey:@"is grey bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isGreyBought;
}

+(void) setIsMaroonBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is maroon bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isMaroonBought = bought;
}
+(BOOL) isMaroonBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isMaroonBought = [[dataDict valueForKey:@"is maroon bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isMaroonBought;
}

+(void) setIsMilitaryGreenBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is military green bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isMilitaryGreenBought = bought;
}
+(BOOL) isMilitaryGreenBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isMilitaryGreenBought = [[dataDict valueForKey:@"is military green bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isMilitaryGreenBought;
}

+(void) setIsNavyBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is navy bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isNavyBought = bought;
}
+(BOOL) isNavyBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isNavyBought = [[dataDict valueForKey:@"is navy bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isNavyBought;
}

+(void) setIsOrangeBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is orange bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isOrangeBought = bought;
}
+(BOOL) isOrangeBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isOrangeBought = [[dataDict valueForKey:@"is orange bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isOrangeBought;
}

+(void) setIsPinkBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is pink bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isPinkBought = bought;
}
+(BOOL) isPinkBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isPinkBought = [[dataDict valueForKey:@"is pink bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isPinkBought;
}

+(void) setIsPurpleBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is purple bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isPurpleBought = bought;
}
+(BOOL) isPurpleBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isPurpleBought = [[dataDict valueForKey:@"is purple bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isPurpleBought;
}

+(void) setIsRedBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is red bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isRedBought = bought;
}
+(BOOL) isRedBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isRedBought = [[dataDict valueForKey:@"is red bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isRedBought;
}

+(void) setIsTanBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is tan bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isTanBought = bought;
}
+(BOOL) isTanBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isTanBought = [[dataDict valueForKey:@"is tan bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isTanBought;
}

+(void) setIsTurquoiseBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is turquoise bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isTurquoiseBought = bought;
}
+(BOOL) isTurquoiseBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isTurquoiseBought = [[dataDict valueForKey:@"is turquoise bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isTurquoiseBought;
}

+(void) setIsYellowBoughtWithDict:(BOOL)bought {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:bought] forKey:@"is yellow bought"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isYellowBought = bought;
}
+(BOOL) isYellowBoughtWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isYellowBought = [[dataDict valueForKey:@"is yellow bought"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isYellowBought;
}



+(void) setIsPremiumContentWithDict:(BOOL)premium {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:premium] forKey:@"is premium content"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].isPremiumContent = premium;
}
+(BOOL) isPremiumContentWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].isPremiumContent = [[dataDict valueForKey:@"is premium content"]boolValue];
    
    return [GlobalDataManager sharedGlobalDataManager].isPremiumContent;
}


+(void) setNumberOfAllCoinsWithDict:(int)num {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [dataDict setObject:[NSNumber numberWithInteger:num] forKey:@"all coins"];
    [dataDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].numberOfAllCoins = num;
}
+(int) numberOfAllCoinsWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSMutableDictionary* dataDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].numberOfAllCoins = [[dataDict valueForKey:@"all coins"]integerValue];
    
    return [GlobalDataManager sharedGlobalDataManager].numberOfAllCoins;
}


+(void) setTimeTrialHighScoreWithDict:(int)num {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [statsDict setObject:[NSNumber numberWithInteger:num] forKey:@"time trial high score"];
    [statsDict writeToFile:plistPath atomically:YES];
    
    [GlobalDataManager sharedGlobalDataManager].timeTrialHighScore = num;
}
+(int) timeTrialHighScoreWithDict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Stats.plist"];
    NSMutableDictionary* statsDict =[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [GlobalDataManager sharedGlobalDataManager].timeTrialHighScore = [[statsDict valueForKey:@"time trial high score"]integerValue];
    
    return [GlobalDataManager sharedGlobalDataManager].timeTrialHighScore;
}


- (void) dealloc
{
    /*[sharedGlobalDataManager release];
	[super dealloc];*/
}
@end