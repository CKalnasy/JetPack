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
}

+(CCScene *) scene;

-(void) classic:(id)sender;
-(void) leaderboards:(id)sender;
-(void) settings:(id)sender;
-(void) stats:(id)sender;
-(void) store:(id)sender;
-(void) timeTrial:(id)sender;

@end
