//
//  Upgrades.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/21/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define POWER_UP_STAGE_ONE 5
#define POWER_UP_STAGE_TWO 7
#define POWER_UP_STAGE_THREE 9
#define POWER_UP_STAGE_FOUR 11

#define FUEL_STAGE_ONE 400
#define FUEL_STAGE_TWO 500
#define FUEL_STAGE_THREE 600
#define FUEL_STAGE_FOUR 700

#define POWER_UP_COST_ONE 750
#define POWER_UP_COST_TWO 1500
#define POWER_UP_COST_THREE 2500

#define FUEL_COST_ONE 1000
#define FUEL_COST_TWO 2000
#define FUEL_COST_THREE 4000


#define POS_ADJUSTMENT 1.5
#define FONT_SIZE 16
#define FONT_SIZE_SMALLER 15

#define HEADER_SIZE 67
#define POS_OFFSET 4

@interface Upgrades : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
    
    CCMenu* fuelMenu;
    CCMenu* boostMenu;
    CCMenu* doublePointsMenu;
    CCMenu* invyMenu;
    
    CCLabelTTF* fuelMenuLabel;
    CCLabelTTF* boostMenuLabel;
    CCLabelTTF* doublePointsMenuLabel;
    CCLabelTTF* invyMenuLabel;
    
    CCRenderTexture* fuelMenuLabelStroke;
    CCRenderTexture* boostMenuLabelStroke;
    CCRenderTexture* doublePointsMenuLabelStroke;
    CCRenderTexture* invyMenuLabelStroke;
    
    CCSprite* fuelMenuCoin;
    CCSprite* boostMenuCoin;
    CCSprite* doublePointsMenuCoin;
    CCSprite* invyMenuCoin;
    
    CCSprite* fuelMeter;
    CCSprite* boostMeter;
    CCSprite* doublePointsMeter;
    CCSprite* invyMeter;
    
    CCLabelTTF* buyMoreCoins1;
    CCLabelTTF* buyMoreCoins2;
    CCLabelTTF* buyMoreCoins3;
    CCRenderTexture* buyMoreCoins1Stroke;
    CCRenderTexture* buyMoreCoins2Stroke;
    CCRenderTexture* buyMoreCoins3Stroke;
    CCSprite* coin;
    CCSprite* textBox;
    CCMenu* buyMoreCoinsMenu;
    
    CCLabelTTF* label1;
    CCLabelTTF* label2;
    CCRenderTexture* label1Stroke;
    CCRenderTexture* label2Stroke;
    CCSprite* buyCoin;
    CCMenu* buyMenu;
}

+(CCScene *) scene;

@end
