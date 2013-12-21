//
//  BackgroundTimeTrial.h
//  JetPack
//
//  Created by Colin Kalnasy on 12/19/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

#define MIN_SCROLLING_SPEED_ATMOS 1.0
#define MIN_SCROLLING_SPEED_SPACE 0.5

@interface BackgroundTimeTrial : CCLayer {
    CGSize winSizeThreeInch;
    CGSize winSizeActual;
    CGSize winSizeFourInch;
    
    int scoreRaw;
    int scoreActual;
    
    Player* player;
    CCSprite* bg1;
    CCSprite* bg2;
    CCSprite* blueBG;
    
    CCLabelTTF* scoreLabel;
    CCLabelTTF* wordScore;
    CCLabelTTF* fuelLabel;
    CCRenderTexture* stroke;
    
    CCLabelTTF* m;
    CCRenderTexture* mStroke;
    
    CGPoint playerVelocity;
    CGPoint backgroundScrollSpeed;
    int highestScoreChanged;
    CCArray* scrollLocs;
    CCArray* backgroundOrder;
    
    CCSprite* bgTransition;
    BOOL didTransition;
    
    BOOL shakeLeft;
    BOOL hasShook;
}

@property (nonatomic, readwrite) CCLabelTTF* scoreLabel;

+(CCScene*) scene;
-(id) init;
-(void) update:(ccTime)delta;

@end
