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
        CCSprite* bg = [CCSprite spriteWithFile:@"base background.png"];
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg z:-10];
        
        //header init
        CCSprite* header = [CCSprite spriteWithFile:@"store-header.png"];
        header.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - header.contentSize.height/2 - 20);
        [self addChild:header];
        
        //player init
        NSString* color = [GlobalDataManager playerColorWithDict];
        NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Jeff-", color, @".png"];
        
        
        Player* player = [Player player:name];
        player.position = ccp(winSizeActual.width/2, player.contentSize.height/2 + 2.5);
        [self addChild:player z:1];
        
        
        classic = [CCMenuItemImage itemWithNormalImage:@"Classic.png" selectedImage:@"Push-Classic.png" target:self selector:@selector(classic:)];
        
        leaderboards = [CCMenuItemImage itemWithNormalImage:@"Leaderboards.png" selectedImage:@"Push-Leaderboards.png" target:self selector:@selector(leaderboards:)];
        
        store = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Push-Store.png" target:self selector:@selector(store:)];
        
        stats = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Push-Stats.png" target:self selector:@selector(stats:)];
        
        timeTrial = [CCMenuItemImage itemWithNormalImage:@"Time-trial.png" selectedImage:@"Push-Time-trial.png" target:self selector:@selector(timeTrial:)];
        
        settings = [CCMenuItemImage itemWithNormalImage:@"Settings.png" selectedImage:@"Push-Settings.png" target:self selector:@selector(settings:)];
        
        
//        CCMenu *menu = [CCMenu menuWithItems:classic, timeTrial, leaderboards, store, stats, settings, nil];
//        [menu alignItemsVerticallyWithPadding:classic.contentSize.height/2];
//        menu.position = CGPointMake(winSizeActual.width/2, header.position.y - header.contentSize.height/2 - 3*(classic.contentSize.height/2 + classic.contentSize.height) - classic.contentSize.height/2);
//        [self addChild:menu];
        
        float padding;
        if (winSizeActual.height == 480) {
            padding = classic.contentSize.height*4/3;
        }
        else {
            padding = classic.contentSize.height*5/3;
        }
        
        CCMenu* menuLeft = [CCMenu menuWithItems:classic, store, leaderboards, nil];
        
        [menuLeft alignItemsVerticallyWithPadding:padding];
        menuLeft.position = CGPointMake(winSizeActual.width/4, header.position.y - header.contentSize.height/2 - 3*(classic.contentSize.height/2 + classic.contentSize.height) - classic.contentSize.height*(1.0/6.0));
        
        [self addChild:menuLeft];
        
        
        CCMenu* menuRight = [CCMenu menuWithItems:timeTrial, stats, settings, nil];
        
        [menuRight alignItemsVerticallyWithPadding:padding];
        menuRight.position = CGPointMake(winSizeActual.width*3/4, header.position.y - header.contentSize.height/2 - 3*(classic.contentSize.height/2 + classic.contentSize.height) - classic.contentSize.height*(1.0/6.0));
        [self addChild:menuRight];
        
        
        
//        CCMenu* menuStore = [CCMenu menuWithItems:store, nil];
//        menuStore.position = CGPointMake(winSize.width/3, winSize.width/3);
//        [self addChild:menuStore];
//        
//        
//        CCMenu* menuStats = [CCMenu menuWithItems:stats, nil];
//        menuStats.position = CGPointMake(winSize.width/3, winSize.width/3);
//        [self addChild:menuStats];
//        
//        
//        CCMenu* menuTimeTrial = [CCMenu menuWithItems:timeTrial, nil];
//        menuTimeTrial.position = CGPointMake(winSize.width/3, winSize.width/3);
//        [self addChild:menuTimeTrial];
//        
//        
//        CCMenu* menuSettings = [CCMenu menuWithItems:settings, nil];
//        menuSettings.position = CGPointMake(winSize.width/3, winSize.width/3);
//        [self addChild:menuSettings];
        
        
        [self schedule:@selector(updateExclamation:)];
    }
	return self;
}



-(void) onEnter {
    [super onEnter];
    
    
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
}



-(void) classic:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}
-(void) leaderboards:(id)sender{
    [[GameKitHelper sharedGameKitHelper] showGameCenterViewController];
}
-(void) store:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Store scene]];
    //[[CCDirector sharedDirector] replaceScene:[Store scene]];
}
-(void) stats:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Stats scene]];
}
-(void) timeTrial:(id)sender{
    
}
-(void) settings:(id)sender{
    
}


-(void) updateExclamation:(ccTime)delta {
    if (exclamationPoint.isRunning) {
        return;
    }
    
    if ([VGVunglePub adIsAvailable]) {
        exclamationPoint = [CCSprite spriteWithFile:@"!.png"];
        exclamationPoint.position = CGPointMake(store.position.x + store.contentSize.width/2, store.position.y + store.contentSize.height/2);
        [self addChild:exclamationPoint];
    }
    
}



- (void) dealloc
{
	//[super dealloc];
}


@end