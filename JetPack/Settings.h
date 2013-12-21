//
//  Settings.h
//  JetPack
//
//  Created by Colin Kalnasy on 12/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define HEADER_SIZE 67


@interface Settings : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    NSString* on;
    NSString* onPushed;
    NSString* off;
    NSString* offPushed;
    
    CCMenuItem* soundSwapOn;
    CCMenuItem* soundSwapOff;
    CCMenuItemToggle* soundSwapToggle;
    CCMenu* soundOnOffMenu;
    
    CCMenuItem* back;
    CCMenu* backMenu;
}

+(CCScene *) scene;

@end