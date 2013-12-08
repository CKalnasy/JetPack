//
//  MainMenu.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MAIN_MENU_SCENE_TAG 2

@interface MainMenu : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    CCSprite* exclamationPoint;
    CGPoint excPos;
    
    CCMenuItemImage *classic;
    CCMenuItemImage *leaderboards;
    CCMenuItemImage *store;
    CCMenuItemImage *stats;
    CCMenuItemImage *timeTrial;
    CCMenuItemImage *settings;
    
    CCMenu* menuClassic;
    CCMenu* menuTimeTrial;
    CCMenu* menuStore;
    CCMenu* menuLeaderboards;
    CCMenu* menuStats;
    CCMenu* menuSettings;
}

+(CCScene *) scene;

-(void) classic:(id)sender;
-(void) leaderboards:(id)sender;
-(void) settings:(id)sender;
-(void) stats:(id)sender;
-(void) store:(id)sender;
-(void) timeTrial:(id)sender;

@end
