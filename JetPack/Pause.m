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
#import "SimpleAudioEngine.h"


@implementation Pause

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Pause *layer = [Pause node];
	[scene addChild: layer];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector]winSize];
        
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
        [menu alignItemsVerticallyWithPadding:resume.contentSize.height/2];
        [self addChild:menu];
        
        
        CCSprite* textBox1 = [CCSprite spriteWithFile:@"Text-box.png"];
        textBox1.position = CGPointMake(menu.position.x, menu.position.y + resume.contentSize.height);
        [self addChild:textBox1 z:-10];
        
        CCSprite* textBox2 = [CCSprite spriteWithFile:@"Text-box.png"];
        textBox2.position = CGPointMake(menu.position.x, menu.position.y - resume.contentSize.height);
        [self addChild:textBox2 z:-10];
        
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
    [GlobalDataManager setIsSoundOnWithDict:![GlobalDataManager isSonudOnWithDict]];
    
    [[SimpleAudioEngine sharedEngine] setMute:[GlobalDataManager isSonudOnWithDict]];
}
-(void) quit:(id)sender{
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Game* game = (Game*)[scene getChildByTag:GAME_LAYER_TAG];
    
    [game quitGame];
}

@end