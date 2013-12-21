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

    
    BOOL isBlackBought;
    BOOL isBlueBought;
    BOOL isBrownBought;
    BOOL isGreenBought;
    BOOL isGreyBought;
    BOOL isMaroonBought;
    BOOL isMilitaryGreenBought;
    BOOL isNavyBought;
    BOOL isOrangeBought;
    BOOL isPinkBought;
    BOOL isPurpleBought;
    BOOL isRedBought;
    BOOL isTanBought;
    BOOL isTurquoiseBought;
    BOOL isYellowBought;
    
    BOOL isPremiumContent;
    int numberOfAllCoins;
    int timeTrialHighScore;
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

@property (nonatomic, readwrite) BOOL isBlackBought;
@property (nonatomic, readwrite) BOOL isBlueBought;
@property (nonatomic, readwrite) BOOL isBrownBought;
@property (nonatomic, readwrite) BOOL isGreenBought;
@property (nonatomic, readwrite) BOOL isGreyBought;
@property (nonatomic, readwrite) BOOL isMaroonBought;
@property (nonatomic, readwrite) BOOL isMilitaryGreenBought;
@property (nonatomic, readwrite) BOOL isNavyBought;
@property (nonatomic, readwrite) BOOL isOrangeBought;
@property (nonatomic, readwrite) BOOL isPinkBought;
@property (nonatomic, readwrite) BOOL isPurpleBought;
@property (nonatomic, readwrite) BOOL isRedBought;
@property (nonatomic, readwrite) BOOL isTanBought;
@property (nonatomic, readwrite) BOOL isTurquoiseBought;
@property (nonatomic, readwrite) BOOL isYellowBought;

@property (nonatomic, readwrite) BOOL isPremiumContent;
@property (nonatomic, readwrite) int numberOfAllCoins;
@property (nonatomic, readwrite) int timeTrialHighScore;


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



+(void) setIsBlackBoughtWithDict:(BOOL)bought;
+(BOOL) isBlackBoughtWithDict;

+(void) setIsBlueBoughtWithDict:(BOOL)bought;
+(BOOL) isBlueBoughtWithDict;

+(void) setIsBrownBoughtWithDict:(BOOL)bought;
+(BOOL) isBrownBoughtWithDict;

+(void) setIsGreenBoughtWithDict:(BOOL)bought;
+(BOOL) isGreenBoughtWithDict;

+(void) setIsGreyBoughtWithDict:(BOOL)bought;
+(BOOL) isGreyBoughtWithDict;

+(void) setIsMaroonBoughtWithDict:(BOOL)bought;
+(BOOL) isMaroonBoughtWithDict;

+(void) setIsMilitaryGreenBoughtWithDict:(BOOL)bought;
+(BOOL) isMilitaryGreenBoughtWithDict;

+(void) setIsNavyBoughtWithDict:(BOOL)bought;
+(BOOL) isNavyBoughtWithDict;

+(void) setIsOrangeBoughtWithDict:(BOOL)bought;
+(BOOL) isOrangeBoughtWithDict;

+(void) setIsPinkBoughtWithDict:(BOOL)bought;
+(BOOL) isPinkBoughtWithDict;

+(void) setIsPurpleBoughtWithDict:(BOOL)bought;
+(BOOL) isPurpleBoughtWithDict;

+(void) setIsRedBoughtWithDict:(BOOL)bought;
+(BOOL) isRedBoughtWithDict;

+(void) setIsTanBoughtWithDict:(BOOL)bought;
+(BOOL) isTanBoughtWithDict;

+(void) setIsTurquoiseBoughtWithDict:(BOOL)bought;
+(BOOL) isTurquoiseBoughtWithDict;

+(void) setIsYellowBoughtWithDict:(BOOL)bought;
+(BOOL) isYellowBoughtWithDict;

+(void) setIsPremiumContentWithDict:(BOOL)premium;
+(BOOL) isPremiumContentWithDict;

+(void) setNumberOfAllCoinsWithDict:(int)num;
+(int) numberOfAllCoinsWithDict;

+(void) setTimeTrialHighScoreWithDict:(int)num;
+(int) timeTrialHighScoreWithDict;


@end