//
//  Game.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Obstacles.h"
#import "Player.h"
#import "PowerUp.h"
#import "SimpleAudioEngine.h"
#import <iAd/iAd.h>
#import "GADInterstitial.h"
#import "Chartboost.h"


#define GAME_LAYER_TAG 0
#define GAME_SCENE_TAG 1
#define BACKGROUND_LAYER_TAG 5
#define MAX_VELOCITY 6.8
#define FUEL_CONSTANT 4.65116
#define FUEL_CANS_BEFORE_MAX 13
#define FUEL_IDLING_CONSTANT 0.5
#define NUM_FUEL_CANS_DOUBLED_UP 5
#define MAX_OBS_PER_SCREEN 5
#define SCORE_MODIFIER 24
#define MONEY_BAG_VALUE 10
#define COINS_TO_CONTINUE 400
#define POS_TO_FLIP 3.5
#define COIN_PERCENTAGE_OF_SCORE 0.0225

#define MAX_HEIGHT ([[UIScreen mainScreen] bounds].size.height) - 375

@interface Game : CCLayer <ADInterstitialAdDelegate> {
    CGSize winSize;
    CGSize winSizeActual;
    
    Player* player;
    //Player* angledFeetPlayer;
    
    float previousAcc; //use these to flip the player
    int posBeforeFlip;
    BOOL didChangeLeftToRight;
        
    float numObsPerScreen;
    int numPathedObsAdded;
    int previousPathedObsLoc;
    
    CCLabelTTF* fuelLabel;
    
    Obstacles* lastObsAdded;
    int numObsAdded;
    int lastObsDeleted;
    
    int scoreActual;
    int scoreRaw;
    int numOfDoublePoints;
    
    Obstacles* firstObs;
    int highestPlayerPosition;
    int diffFirstObsAnd0;
    
    CGPoint horizontalVelocity;
    int diffCenterObsAndPlayer;
    BOOL isTouchingHorizObs;
    Obstacles* horizObsLandedOn;
    
    CCArray* coinLoc;
    int numCoins;
    int coinRand;
    int numFewCoinsAdded;
    
    CCSprite* outerPowerUpBar;
    CCSprite* innerPowerUpBar;
    CGRect innerPowerUpBarRect;
    int numSecondsPowerUp;
    BOOL didAlreadyMakePowerUpBarSmaller;
    
    PowerUp* boost;
    int numBoosts;
    int maxNumSecondsBoost;
    
    PowerUp* invy;
    int numInvys;
    int maxNumSecondsInvy;
    
    PowerUp* doublePoints;
    int numDoubles;
    int maxNumSecondsDouble;
    
    int numContinuesUsed;
    
    
    PowerUp* fuelCan;
    int previousFuelCanLoc;
    int numFuelCansAddedBeforeDoubled;
    int numFuelCansAddedAfterDoubled;
    CCSprite* innerFuelBar;
    CGRect innerFuelBarRect;
    BOOL didAlreadyMakeFuelBarSmaller;
    BOOL didRunOutOfFuel;
    
    CCSprite* pause;
    BOOL isMenuUp;
    CCLayerColor* opacityLayer;
    
    CCLabelTTF* continueTotalCoinsText;
    CCRenderTexture* continueTotalCoinsStroke;
    CCLabelTTF* continueTotalCoins2Text;
    CCRenderTexture* continueTotalCoins2Stroke;
    CCSprite* continueTotalCoinsCoin;
    
    CCLabelTTF* continueText1;
    CCLabelTTF* continueText2;
    CCRenderTexture* continueText1Stroke;
    CCRenderTexture* continueText2Stroke;
    CCSprite* textBox;
    CCSprite* textBox2;
    
    CCSprite* continueCoin;
    CCMenu* continueMenu;
    BOOL hasGameBegun;
    BOOL isGameOver;
    
    NSArray* powerUpLow;
    NSArray* powerUpHigh;
    int powerUpDifferenceLate;
    int numPowerUpsAdded;
    int lastPowerUpEndOrLoc;
    
    BOOL isGameRunning;
    BOOL doDetectCollisions;
    
    BOOL added;
    int numSecs;
    
    int ranOutOfFuelSec;
    ALuint effect;
    
    ADInterstitialAd* iAd;
    GADInterstitial* adMob;
    
    float deviceVersion;
}

@property (nonatomic, readwrite) BOOL isGameOver;

+(CCScene*) scene;

-(id) init;
-(void) registerWithTouchDispatcher;
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
-(void) constUpdate:(ccTime)delta;
-(void) speedUpdate:(ccTime)delta;
-(void) gravityUpdate:(ccTime)delta;
-(void) accelerometerUpdate:(ccTime)delta;
-(void) addObs:(ccTime)delta;
-(void) addFirstObs;
-(void) cleanUpObs:(ccTime)delta;
-(void) horizontalMovement:(Obstacles*)spr;
-(void) makeHorizontalObs:(Obstacles*) obs;
-(void) collisionDetection:(ccTime)delta;
-(void) gameEnded;
-(void) addFuelBar;
-(void) updateFuelBar:(ccTime)delta;
-(void) addPowerUpBar: (PowerUp*)powerUp;
-(void) updatePowerUpBar:(ccTime)delta;
-(void) addFuel;
-(void) isHighScore;
-(void) pause:(id)sender;
-(void) resumeGame;
-(void) quitGame;

@end