//
//  GlobalDataManager.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "GlobalDataManager.h"


 @implementation GlobalDataManager
@synthesize scoreRaw, scoreActual, fuel, numCoins, totalCoins, totalGames, highScore, numContinues, cb, player, isPaused, maxFuel;

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

+(int) maxFuel{
    return [GlobalDataManager sharedGlobalDataManager].maxFuel;
}
+(void) setMaxFuel:(int)num{
    [GlobalDataManager sharedGlobalDataManager].fuel = num;
}

+(int) totalCoins{
    return [GlobalDataManager sharedGlobalDataManager].totalCoins;
}
+(void) setTotalCoins: (int)num{
    [GlobalDataManager sharedGlobalDataManager].totalCoins += num;
    
    //stats.plist init
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* finalPath =[path stringByAppendingPathComponent:@"Stats.plist"];
    NSDictionary* statsDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    [statsDict setValue:[NSNumber numberWithInt:num] forKey:@"coins collected"];
}

+(int) totalGames{
    return [GlobalDataManager sharedGlobalDataManager].totalGames;
}
+(void) setTotalGames: (int)num{
    [GlobalDataManager sharedGlobalDataManager].totalGames = num;
    
    //data.plist init
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    [dataDict setValue:[NSNumber numberWithInt:num] forKey:@"total games"];
}

+(int) highScore{
    return [GlobalDataManager sharedGlobalDataManager].highScore;
}
+(void) setHighScore: (int)num{
    [GlobalDataManager sharedGlobalDataManager].highScore = num;
    
    //data.plist init
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    [dataDict setValue:[NSNumber numberWithInt:num] forKey:@"high score"];
}

+(int) numContinues{
    return [GlobalDataManager sharedGlobalDataManager].numContinues;
}
+(void) setNumContinues: (int)num{
    [GlobalDataManager sharedGlobalDataManager].numContinues = num;
    
    //data.plist init
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    [dataDict setValue:[NSNumber numberWithInt:num] forKey:@"continues"];
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



- (void) dealloc
{
    /*[sharedGlobalDataManager release];
	[super dealloc];*/
}
@end