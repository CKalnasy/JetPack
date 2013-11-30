//
//  Pause.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Pause.h"
#import "MainMenu.h"
#import "Game.h"


@implementation Pause

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Pause *layer = [Pause node];
	[scene addChild: layer];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        //menu with resume, quit and sound on/off buttons
        CCMenuItem* resume = [CCMenuItemImage itemWithNormalImage:@"Classic.png" selectedImage:@"Classic.png" target:self selector:@selector(resumeGame:)];
        CCMenuItem* soundSwap = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Store.png" target:self selector:@selector(soundSwap:)];
        CCMenuItem* quit = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Stats.png" target:self selector:@selector(quit:)];
        
        CCMenu* menu = [CCMenu menuWithItems:resume, soundSwap, quit, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
        
    }
    return self;
}

-(void) resumeGame:(id)sender{
    [self removeFromParentAndCleanup:NO];
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Game* game = (Game*)[scene getChildByTag:GAME_LAYER_TAG];
    
    [game resumeGame];
}

-(void) soundSwap:(id)sender{
    //todo: swap sound
}
-(void) quit:(id)sender{
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Game* game = (Game*)[scene getChildByTag:GAME_LAYER_TAG];
    
    [game quitGame];
}

@end