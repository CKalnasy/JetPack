//
//  Store.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Store : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    CCRenderTexture* stroke;
    CCMenu* backMenu;
    CCMenuItem* back;
    CCLabelTTF* coins;
    
    CCSprite* exclamation;
    CGPoint excPos;
}

+(CCScene *) scene;

@end
