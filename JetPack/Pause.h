//
//  Pause.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

@interface Pause : CCLayer {
    CGSize winSize;
    
    NSString* on;
    NSString* onPushed;
    NSString* off;
    NSString* offPushed;
    
    CCMenuItem* resume;
    CCMenuItem* soundSwapOn;
    CCMenuItem* soundSwapOff;
    CCMenuItemToggle* soundSwapToggle;
    CCMenuItem* quit;
    CCMenu* menu;
}

+(CCScene *) scene;

@end
