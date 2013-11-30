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

#define POWER_UP_COST_ONE 500
#define POWER_UP_COST_TWO 1000
#define POWER_UP_COST_THREE 2000


#define HEADER_SIZE 67
#define POS_OFFSET 4

@interface Upgrades : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
    
    CCSprite* fuelMeter;
    CCSprite* boostMeter;
    CCSprite* doublePointsMeter;
    CCSprite* invyMeter;
}

+(CCScene *) scene;

@end
