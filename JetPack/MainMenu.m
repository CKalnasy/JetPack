//
//  MainMenu.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "Stats.h"
#import "Player.h"
#import "Store.h"
#import "Chartboost.h"
#import <RevMobAds/RevMobAds.h>
#import "GlobalDataManager.h"
#import "vunglepub.h"
#import "Settings.h"
#import "TimeTrial.h"



@implementation MainMenu

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    scene.tag = MAIN_MENU_SCENE_TAG;
	MainMenu *layer = [MainMenu node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        //background init
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        //header init
        CCSprite* header = [CCSprite spriteWithFile:@"GAME-OVER.png"];
        header.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - header.contentSize.height/2);
        //[self addChild:header];
       
        //player init
        NSString* color = [GlobalDataManager playerColorWithDict];
        NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Jeff-", color, @".png"];
        
        
        Player* player = [Player player:name];
        player.position = ccp(winSizeActual.width/2, player.contentSize.height/2 + 2.5);
        [self addChild:player z:1];
        
        
        classic = [CCMenuItemImage itemWithNormalImage:@"Classic-button.png" selectedImage:@"Push-Classic.png" target:self selector:@selector(classic:)];
        
        leaderboards = [CCMenuItemImage itemWithNormalImage:@"Leaderboards-button.png" selectedImage:@"Push-Leaderboards.png" target:self selector:@selector(leaderboards:)];
        
        store = [CCMenuItemImage itemWithNormalImage:@"Store-button.png" selectedImage:@"Push-Store.png" target:self selector:@selector(store:)];
        
        stats = [CCMenuItemImage itemWithNormalImage:@"Stats-button.png" selectedImage:@"Push-Stats.png" target:self selector:@selector(stats:)];
        
        timeTrial = [CCMenuItemImage itemWithNormalImage:@"Time-trial-button.png" selectedImage:@"Push-Time-trial.png" target:self selector:@selector(timeTrial:)];
        
        settings = [CCMenuItemImage itemWithNormalImage:@"Settings-button.png" selectedImage:@"Push-Settings.png" target:self selector:@selector(settings:)];
        
        
        //menu init
        float pos = (header.position.y - header.contentSize.height/2 - player.contentSize.height) / 7.0;
        
        menuClassic = [CCMenu menuWithItems:classic, nil];
        menuClassic.position = CGPointMake(winSizeActual.width/2, pos * 6 + player.contentSize.height);
        [self addChild:menuClassic];
        
        
        menuTimeTrial = [CCMenu menuWithItems:timeTrial, nil];
        menuTimeTrial.position = CGPointMake(winSizeActual.width/2, pos * 5 + player.contentSize.height);
        [self addChild:menuTimeTrial];
        
        
        menuStore = [CCMenu menuWithItems:store, nil];
        menuStore.position = CGPointMake(winSizeActual.width/2, pos * 4 + player.contentSize.height);
        [self addChild:menuStore];
        
        
        menuLeaderboards = [CCMenu menuWithItems:leaderboards, nil];
        menuLeaderboards.position = CGPointMake(winSizeActual.width/2, pos * 3 + player.contentSize.height);
        [self addChild:menuLeaderboards];
        
        
        menuStats = [CCMenu menuWithItems:stats, nil];
        menuStats.position = CGPointMake(winSizeActual.width/2, pos * 2 + player.contentSize.height);
        [self addChild:menuStats];
        
        
        menuSettings = [CCMenu menuWithItems:settings, nil];
        menuSettings.position = CGPointMake(winSizeActual.width/2, pos * 1 + player.contentSize.height);
        [self addChild:menuSettings];
        
        
        [self schedule:@selector(updateExclamation:)];
    }
	return self;
}




-(void) classic:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}
-(void) leaderboards:(id)sender{
    [[GameKitHelper sharedGameKitHelper] showGameCenterViewController];
}
-(void) store:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Store scene]];
}
-(void) stats:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Stats scene]];
}
-(void) timeTrial:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[TimeTrial scene]];
}
-(void) settings:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Settings scene]];
}


-(void) updateExclamation:(ccTime)delta {
    if (exclamationPoint.isRunning) {
        return;
    }
    
    if ([VGVunglePub adIsAvailable]) {
        exclamationPoint = [CCSprite spriteWithFile:@"!.png"];
        exclamationPoint.position = CGPointMake(menuStore.position.x + store.contentSize.width/2, menuStore.position.y + store.contentSize.height/2);
        [self addChild:exclamationPoint];
    }
    
}



- (void) dealloc
{
	//[super dealloc];
}


@end