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
    int numContinues;
    CGPoint playerVelocity;
    Player* player;
    BOOL isPaused;
    
    Chartboost* cb;
}

@property (nonatomic, readwrite) int scoreRaw;
@property (nonatomic, readwrite) int scoreActual;
@property (nonatomic, readwrite) int numCoins;
@property (nonatomic, readwrite) int fuel;
@property (nonatomic, readwrite) int totalCoins;
@property (nonatomic, readwrite) int totalGames;
@property (nonatomic, readwrite) int highScore;
@property (nonatomic, readwrite) int numContinues;
@property (nonatomic, readwrite) Chartboost* cb;
@property (nonatomic, readwrite) Player* player;
@property (nonatomic, readwrite) BOOL isPaused;
@property (nonatomic, readwrite) int maxFuel;



+ (GlobalDataManager*)sharedGlobalDataManager;

+(int) scoreRaw;
+(void) setScoreRaw: (int)num;

+(int) scoreActual;
+(void) setScoreActual: (int)num;

+(int) numCoins;
+(void) setNumCoins: (int)num;

+(int) fuel;
+(void) setFuel: (int)num;

+(int) maxFuel;
+(void) setMaxFuel: (int)num;

+(int) totalCoins;
+(void) setTotalCoins: (int)num;

+(int) totalGames;
+(void) setTotalGames: (int)num;

+(int) highScore;
+(void) setHighScore: (int)num;

+(int) numContinues;
+(void) setNumContinues: (int)num;

+(Chartboost*) cb;
+(void) setCB: (Chartboost*)cbv;

+(Player*) player;
+(void) setPlayer: (Player*)_player;

+(BOOL) isPaused;
+(void) setIsPaused:(BOOL)_isPaused;

@end