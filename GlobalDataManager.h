//
//  GlobalDataManager.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chartboost.h"
#import "Player.h"


@interface GlobalDataManager : NSObject
{
    int scoreRaw;
    int scoreActual;
    int numCoins;
    int fuel;
    int maxFuel;
    //long term stored data
    int totalCoins;
    int totalGames;
    int highScore;
    CGPoint playerVelocity;
    Player* player;
    BOOL isPaused;
    NSString* playerColor;
    
    int numSecondsBoost;
    int numSecondsDoublePoints;
    int numSecondsInvy;
    
    BOOL isSoundOn;
    
    Chartboost* cb;
}

@property (nonatomic, readwrite) int scoreRaw;
@property (nonatomic, readwrite) int scoreActual;
@property (nonatomic, readwrite) int numCoins;
@property (nonatomic, readwrite) int fuel;
@property (nonatomic, readwrite) int totalCoins;
@property (nonatomic, readwrite) int totalGames;
@property (nonatomic, readwrite) int highScore;
@property (nonatomic, readwrite) Chartboost* cb;
@property (nonatomic, readwrite) Player* player;
@property (nonatomic, readwrite) BOOL isPaused;
@property (nonatomic, readwrite) int maxFuel;
@property (nonatomic, readwrite) NSString* playerColor;
@property (nonatomic, readwrite) int numSecondsBoost;
@property (nonatomic, readwrite) int numSecondsDoublePoints;
@property (nonatomic, readwrite) int numSecondsInvy;
@property (nonatomic, readwrite) BOOL isSoundOn;



+ (GlobalDataManager*)sharedGlobalDataManager;

+(int) scoreRaw;
+(void) setScoreRaw: (int)num;

+(int) scoreActual;
+(void) setScoreActual: (int)num;

+(int) numCoins;
+(void) setNumCoins: (int)num;

+(int) fuel;
+(void) setFuel: (int)num;

+(int) maxFuelWithDict;
+(void) setMaxFuelWithDict: (int)num;

+(int) totalCoinsWithDict;
+(void) setTotalCoinsWithDict: (int)num;

+(int) totalGamesWithDict;
+(void) setTotalGamesWithDict: (int)num;

+(int) highScoreWithDict;
+(void) setHighScoreWithDict: (int)num;

+(Chartboost*) cb;
+(void) setCB: (Chartboost*)cbv;

+(Player*) player;
+(void) setPlayer: (Player*)_player;

+(BOOL) isPaused;
+(void) setIsPaused:(BOOL)_isPaused;

+(NSString*) playerColorWithDict;
+(void) setPlayerColorWithDict:(NSString*)name;

+(int) numSecondsBoostWithDict;
+(void) setNumSecondsBoostWithDict:(int)num;

+(int) numSecondsDoublePointsWithDict;
+(void) setNumSecondsDoublePointsWithDict:(int)num;

+(int) numSecondsInvyWithDict;
+(void) setNumSecondsInvyWithDict:(int)num;

+(void) setIsSoundOnWithDict:(BOOL)on;
+(BOOL) isSonudOnWithDict;


@end