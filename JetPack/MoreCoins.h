//
//  MoreCoins.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/16/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define NUMBER_OF_COINS_PER_VIEW 75
#define MORE_COINS_LAYER_TAG 4
#define HEADER_SIZE 67

@interface MoreCoins : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
    
    CCMenu* moreCoins1Menu;
    CCMenu* moreCoins2Menu;
    CCMenu* moreCoins3Menu;
    
    CCSprite* exclamation;
    CGPoint excPos;
    
    BOOL didWatchAd;
}

@property (nonatomic, readwrite) BOOL didWatchAd;
@property (nonatomic, readwrite) BOOL adDidClose;

+(CCScene *) scene;
-(void) adClosed;
+(void) increaseCoins:(int) num;

@end
