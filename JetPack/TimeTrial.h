//
//  TimeTrial.h
//  JetPack
//
//  Created by Colin Kalnasy on 12/2/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Obstacles.h"
#import "Player.h"
#import "PowerUp.h"


#define TIME_TRIAL_LAYER_TAG 0
#define TIME_TRIAL_SCENE_TAG 1
#define BACKGROUND_LAYER_TAG 5
#define MAX_VELOCITY 6.8
//#define FUEL_CONSTANT 4.65116
#define FUEL_CONSTANT_TIME_TRIAL 4.65116
//#define FUEL_IDLING_CONSTANT 0.5
#define FUEL_IDLING_CONSTANT_TIME_TRIAL 0.25
#define MAX_OBS_PER_SCREEN_TIME_TRIAL 7
#define SCORE_MODIFIER_TIME_TRIAL 24
#define POS_TO_FLIP 3.5

#define MAX_HEIGHT ([[UIScreen mainScreen] bounds].size.height) - 375

@interface TimeTrial : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    Player* player;
    
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
    
//    int scoreActual;
    int scoreRaw;
//    int numOfDoublePoints;
    
    Obstacles* firstObs;
    int highestPlayerPosition;
    int diffFirstObsAnd0;
    
    CGPoint horizontalVelocity;
    int diffCenterObsAndPlayer;
    BOOL isTouchingHorizObs;
    Obstacles* horizObsLandedOn;
    
    int numFewHorizontalObsAdded;
    int horizontalObsRand;
//    CCArray* coinLoc;
//    int numCoins;
//    int coinRand;
//    int numFewCoinsAdded;
    
//    CCSprite* outerPowerUpBar;
//    CCSprite* innerPowerUpBar;
//    CGRect innerPowerUpBarRect;
//    int numSecondsPowerUp;
//    BOOL didAlreadyMakePowerUpBarSmaller;
    
//    PowerUp* boost;
//    int numBoosts;
//    int maxNumSecondsBoost;
//    
//    PowerUp* invy;
//    int numInvys;
//    int maxNumSecondsInvy;
//    
//    PowerUp* doublePoints;
//    int numDoubles;
//    int maxNumSecondsDouble;
//    
//    int numContinuesUsed;
    
//    PowerUp* fuelCan;
//    int previousFuelCanLoc;
//    int numFuelCansAddedBeforeDoubled;
//    int numFuelCansAddedAfterDoubled;
    CCSprite* innerFuelBar;
    CGRect innerFuelBarRect;
    BOOL didAlreadyMakeFuelBarSmaller;
    BOOL didRunOutOfFuel;
    
    CCSprite* pause;
    BOOL isMenuUp;
    CCLayerColor* opacityLayer;
    
//    CCMenu* continueMenu;
    BOOL hasGameBegun;
    BOOL isGameOver;
    
//    NSArray* powerUpLow;
//    NSArray* powerUpHigh;
//    int powerUpDifferenceLate;
//    int numPowerUpsAdded;
//    int lastPowerUpEndOrLoc;
    
    BOOL isGameRunning;
    BOOL doDetectCollisions;
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
-(void) isHighScore;
-(void) pause:(id)sender;
-(void) resumeGame;
-(void) quitGame;

@end