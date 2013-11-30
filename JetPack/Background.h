//
//  Background.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

#define MIN_SCROLLING_SPEED_ATMOS 1.0
#define MIN_SCROLLING_SPEED_SPACE 0.5

@interface Background : CCLayer {
    CGSize winSizeThreeInch;
    CGSize winSizeActual;
    CGSize winSizeFourInch;
    
    int scoreRaw;
    int scoreActual;
    int numCoins;
    int fuel;
    
    Player* player;
    CCSprite* bg1;
    CCSprite* bg2;
    
    CCLabelTTF* scoreLabel;
    CCLabelTTF* wordScore;
    CCLabelTTF* coinsLabel;
    CCLabelTTF* fuelLabel;
    CCRenderTexture* stroke;
    CCRenderTexture* coinStroke;
    
    CGPoint playerVelocity;
    CGPoint backgroundScrollSpeed;
    int highestScoreChanged;
    CCArray* scrollLocs;
    CCArray* backgroundOrder;
    
    CCSprite* bgTransition;
    BOOL didTransition;
}

@property (nonatomic, readwrite) CCLabelTTF* scoreLabel;
@property (nonatomic, readwrite) CCLabelTTF* coinsLabel;

+(CCScene*) scene;
-(id) init;
-(void) update:(ccTime)delta;

@end
