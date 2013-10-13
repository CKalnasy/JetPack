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

#define GAME_LAYER_TAG 0
#define GAME_SCENE_TAG 1
#define MAX_VELOCITY 6.8
#define FUEL_CONSTANT 4.65116
#define FUEL_CANS_BEFORE_MAX 13
#define FUEL_IDLING_CONSTANT 0.5
#define NUM_FUEL_CANS_DOUBLED_UP 5
#define MAX_OBS_PER_SCREEN 5
#define SCORE_MODIFIER 64


@interface Game : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    Player* player;
    
    float previousAcc; //use these to flip the player
    int posBeforeFlip;
    BOOL didChangeLeftToRight;
        
    float numObsPerScreen;
    
    CCLabelTTF* fuelLabel;
    
    Obstacles* lastObsAdded;
    int numObsAdded;
    int lastObsDeleted;
    
    int scoreActual;
    int scoreRaw;
    
    Obstacles* firstObs;
    int highestPlayerPosition;
    int diffFirstObsAnd0;
    
    CGPoint horizontalVelocity;
    
    int numCoins;
    //int numCoinsAdded;
    //int numCoinsDeleted;
    
    CCSprite* innerPowerUpBar;
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
    
    int numContinuesLeft;
    int numContinuesUsed;
    
    PowerUp* fuelCan;
    int previousFuelCanLoc;
    int numFuelCansAddedBeforeDoubled;
    int numFuelCansAddedAfterDoubled;
    CCSprite* innerFuelBar;
    BOOL didAlreadyMakeFuelBarSmaller;
    
    CCSprite* pause;
    BOOL isMenuUp;
    CCLayerColor* opacityLayer;
    
    CCMenu* continueMenu;
    BOOL hasGameBegun;
    
    NSArray* powerUpLow;
    NSArray* powerUpHigh;
    int powerUpDifferenceLate;
    int numPowerUpsAdded;
    
    BOOL isGameRunning;
    
    BOOL added;
}


+(CCScene*) scene;

-(id) init;
-(void) registerWithTouchDispatcher;
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
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
-(void) addCoins;
-(void) collisionDetection:(ccTime)delta;
-(void) gameEnded;
-(void) addFuelBar;
-(void) updateFuelBar:(ccTime)delta;
-(void) addPowerUpBar: (PowerUp*)powerUp;
-(void) updatePowerUpBar:(ccTime)delta;
-(void) addFuelCan;
-(void) collideWithFuelCan;
-(void) addFuel;
-(void) isHighScore;
-(void) pause:(id)sender;
-(void) resumeGame;
-(void) quitGame;

@end