//
//  Clothes.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Apparel.h"

#define PRICE 200
#define CLOTHES_TAG 21
#define FONT_SIZE 19
#define SMALLER_FONT_SIZE 10.5
#define POS_ADJUSTMENT 1.5

@interface Clothes : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;

    Player* top;
    Player* bottom;
    
    CCMenu* menuP0;
    CCMenu* menuP1;
    CCMenu* menuP2;
    CCMenu* menuP3;
    CCMenu* menuP4;
    CCMenu* menuP5;
    CCMenu* menuP6;
    CCMenu* menuP7;
    CCMenu* menuP8;
    CCMenu* menuP9;
    CCMenu* menuP10;
    CCMenu* menuP11;
    CCMenu* menuP12;
    CCMenu* menuP13;
    CCMenu* menuP14;
    
    CCLabelTTF* label0;
    CCLabelTTF* label1;
    CCLabelTTF* label2;
    CCLabelTTF* label3;
    CCLabelTTF* label4;
    CCLabelTTF* label5;
    CCLabelTTF* label6;
    CCLabelTTF* label7;
    CCLabelTTF* label8;
    CCLabelTTF* label9;
    CCLabelTTF* label10;
    CCLabelTTF* label11;
    CCLabelTTF* label12;
    CCLabelTTF* label13;
    CCLabelTTF* label14;
    
    CCRenderTexture* stroke0;
    CCRenderTexture* stroke1;
    CCRenderTexture* stroke2;
    CCRenderTexture* stroke3;
    CCRenderTexture* stroke4;
    CCRenderTexture* stroke5;
    CCRenderTexture* stroke6;
    CCRenderTexture* stroke7;
    CCRenderTexture* stroke8;
    CCRenderTexture* stroke9;
    CCRenderTexture* stroke10;
    CCRenderTexture* stroke11;
    CCRenderTexture* stroke12;
    CCRenderTexture* stroke13;
    CCRenderTexture* stroke14;
    
    CCSprite* coin0;
    CCSprite* coin1;
    CCSprite* coin2;
    CCSprite* coin3;
    CCSprite* coin4;
    CCSprite* coin5;
    CCSprite* coin6;
    CCSprite* coin7;
    CCSprite* coin8;
    CCSprite* coin9;
    CCSprite* coin10;
    CCSprite* coin11;
    CCSprite* coin12;
    CCSprite* coin13;
    CCSprite* coin14;
    
    CCSprite* textBox;
    CCLabelTTF* buyMoreCoins1;
    CCLabelTTF* buyMoreCoins2;
    CCLabelTTF* buyMoreCoins3;
    CCRenderTexture* buyMoreCoins1Stroke;
    CCRenderTexture* buyMoreCoins2Stroke;
    CCRenderTexture* buyMoreCoins3Stroke;
    CCSprite* coin;
    CCMenu* buyMoreCoinsMenu;

    NSString* selected;
    BOOL isMenuUp;
}

+(CCScene *) scene;

@end
