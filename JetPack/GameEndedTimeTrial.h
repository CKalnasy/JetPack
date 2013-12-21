//
//  GameEndedTimeTrial.h
//  JetPack
//
//  Created by Colin Kalnasy on 12/19/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define GAME_ENDED_TIME_TRIAL_SCENE_TAG 2
#define GAME_ENDED_TIME_TRIAL_LAYER_TAG 22

@interface GameEndedTimeTrial : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
}

+(CCScene *) scene;

@end
