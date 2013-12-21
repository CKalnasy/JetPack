//
//  Apparel.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define HEADER_SIZE 67
#define APPAREL_SCENE_TAG 22

@interface Apparel : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
    
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
-(void) updateNumCoins;
-(void) notEnoughCoins;

@end
