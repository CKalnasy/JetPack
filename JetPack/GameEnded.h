//
//  GameEnded.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Chartboost.h"

#define GAME_ENDED_SCENE_TAG 2
#define GAME_ENDED_LAYER_TAG 22

@interface GameEnded : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
}

+(CCScene *) scene;

@end
