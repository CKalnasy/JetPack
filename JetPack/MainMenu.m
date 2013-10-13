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


@implementation MainMenu

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenu *layer = [MainMenu node];
	[scene addChild: layer z:0 tag:MAIN_MENU_SCENE_TAG];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        winSize = [[CCDirector sharedDirector]winSize];
        
        //background init
        CCSprite* bg = [CCSprite spriteWithFile:@"base background.png"];
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg z:-10];
        
        //player init
        Player* player = [Player player:@"Jeff.png"];
        player.position = ccp(winSize.width/2, player.contentSize.height/2);
        [self addChild:player z:1];
        
        
        CCMenuItemImage *classic = [CCMenuItemImage itemWithNormalImage:@"Classic.png" selectedImage:@"Push-Classic.png" target:self selector:@selector(classic:)];
        
        CCMenuItemImage *leaderboards = [CCMenuItemImage itemWithNormalImage:@"Leaderboards.png" selectedImage:@"Push-Leaderboards.png" target:self selector:@selector(leaderboards:)];
        
        CCMenuItemImage *store = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Push-Store.png" target:self selector:@selector(store:)];
        
        CCMenuItemImage *stats = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Push-Stats.png" target:self selector:@selector(stats:)];
        
        CCMenuItemImage *timeTrial = [CCMenuItemImage itemWithNormalImage:@"Time-trial.png" selectedImage:@"Push-Time-trial.png" target:self selector:@selector(timeTrial:)];
        
        CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"Settings.png" selectedImage:@"Push-Settings.png" target:self selector:@selector(settings:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems:classic, timeTrial, leaderboards, store, stats, settings, nil];
        [menu alignItemsVertically];
        
        [self addChild:menu];
    }
	return self;
}


-(void) classic:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}
-(void) leaderboards:(id)sender{
    
}
-(void) store:(id)sender{
    
}
-(void) stats:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[Stats scene]];
}
-(void) timeTrial:(id)sender{
    
}
-(void) settings:(id)sender{
    
}
-(void) freeCoins:(id)sender{
    
    
    //vungle
    if ([VGVunglePub adIsAvailable]) {
        [VGVunglePub playIncentivizedAd:[CCDirector sharedDirector].parentViewController animated:YES showClose:NO userTag:nil];
    }
}


- (void) dealloc
{
	//[super dealloc];
}



@end



/*CCLabelTTF* l = [CCLabelTTF labelWithString:@"THIS IS A TEST" fontName:@"arial" fontSize:10];
 l.position = CGPointMake(winSize.width / 2, winSize.width / 2);
 
 CCRenderTexture* rend = [CCLabelTTF createStroke:l size:1 color:ccBLACK];
 rend.position = l.position;
 
 [self addChild:rend];
 [self addChild:l];*/

