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
#import "GlobalDataManager.h"


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
        resume = [CCMenuItemImage itemWithNormalImage:@"Resume-button.png" selectedImage:@"Push-Resume.png" target:self selector:@selector(resumeGame:)];
        
        BOOL isSoundOn = [GlobalDataManager isSonudOnWithDict];
        if (isSoundOn) {
            on = @"Sound-on-button.png";
            onPushed = @"Push-Sound-on.png";
            off =@"Sound-off-button.png";
            offPushed = @"Push-Sound-off.png";
        }
        else {
            on = @"Sound-off-button.png";
            onPushed = @"Push-Sound-off.png";
            off = @"Sound-on-button.png";
            offPushed = @"Push-Sound-on.png";
        }
        soundSwapOn = [CCMenuItemImage itemWithNormalImage:on selectedImage:onPushed];
        soundSwapOff = [CCMenuItemImage itemWithNormalImage:off selectedImage:offPushed];
        soundSwapToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundSwap:) items:soundSwapOn, soundSwapOff, nil];
        
        quit = [CCMenuItemImage itemWithNormalImage:@"Quit-button.png" selectedImage:@"Push-Quit.png" target:self selector:@selector(quit:)];
        
        
        
        menu = [CCMenu menuWithItems:resume, soundSwapToggle, quit, nil];
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
    //todo: swap the sound
}
-(void) quit:(id)sender{
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Game* game = (Game*)[scene getChildByTag:GAME_LAYER_TAG];
    
    [game quitGame];
}

@end