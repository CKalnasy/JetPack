//
//  MoreCoins.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/16/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define NUMBER_OF_COINS_PER_VIEW 25
#define MORE_COINS_LAYER_TAG 4
#define HEADER_SIZE 67

@interface MoreCoins : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
    CCMenuItem* back;
    CCMenu* backMenu;
    
    CCMenu* moreCoins1Menu;
    CCMenu* moreCoins2Menu;
    CCMenu* moreCoins3Menu;
    
    CCMenuItem* moreCoins1;
    CCMenuItem* moreCoins2;
    CCMenuItem* moreCoins3;
    
    CCSprite* exclamation;
    CGPoint excPos;
    
    BOOL didWatchAd;
}

@property (nonatomic, readwrite) BOOL didWatchAd;
@property (nonatomic, readwrite) BOOL adDidClose;

+(CCScene *) scene;
-(void) adClosed;
-(void) updateCoins;

@end
