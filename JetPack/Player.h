//
//  Player.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite {
    BOOL isInvyEnabled;
    BOOL isDoublePointsEnabled;
    BOOL isBoostingEnabled;
    BOOL isFading;
    CGRect rect;
    float fuel;
    int maxFuel;
    BOOL isAPowerUpEnabled;
    
    CCSprite* jetpack;
    CCSprite* flameSmall;
    CCSprite* flameMedium;
    CCSprite* flameLarge;
    BOOL isFlameChanging;
    
    CGPoint velocity;
    CGPoint acceleration;
    CGSize winSize;
    CGSize winSizeActual;
    
    CGRect feetRect;
    
    BOOL isFacingRight;
}

@property (nonatomic, readwrite) BOOL isInvyEnabled;
@property (nonatomic, readwrite) BOOL isDoublePointsEnabled;
@property (nonatomic, readwrite) BOOL isBoostingEnabled;
@property (nonatomic, readwrite) BOOL isFading;
@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readwrite) float fuel;
@property (nonatomic, readwrite) int maxFuel;
@property (nonatomic, readonly) BOOL isAPowerUpEnabled;
@property (nonatomic, readonly) CGRect feetRect;
@property (nonatomic, readwrite) CGPoint velocity;
@property (nonatomic, readwrite) CGPoint acceleration;


+(id) player:(NSString*)name;
-(id) initWithPlayer:(NSString*)name;

-(void) setIsInvyEnabled:(BOOL)_isBoostingEnabled;
-(BOOL) isInvyEnabled;

-(void) setIsBoostingEnabled:(BOOL)_isBoostingEnabled;
-(BOOL) isBoostingEnabled;

-(void) setIsDoublePointsEnabled:(BOOL)_isDoublePointsEnabled;
-(BOOL) isDoublePointsEnabled;

-(void) setFuel:(float)_fuel;
-(float) getFuel;

-(void) setMaxFuel:(int)_maxFuel;
-(int) getMaxFuel;

-(BOOL) getIsAPowerUpEnabled;

-(CGRect) getRect;

-(CGRect) feetRect;

-(CGPoint) velocity;
-(void) setVelocity:(CGPoint)point;

-(CGPoint) acceleration;
-(void) setAcceleration:(CGPoint)point;

-(void) faceLeft;
-(void) faceRight;


-(void) updateFlame:(ccTime)delta;

@end
