//
//  Stats.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Stats.h"
#import "GlobalDataManager.h"
#import "MainMenu.h"


@implementation Stats

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Stats *layer = [Stats node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite* bg = [CCSprite spriteWithFile:@"base background.png"];
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg z:-10];
        
        //high score label
        CCLabelTTF* highScore = [CCLabelTTF labelWithString:@"1234567890" fontName:@"Orbitron-Medium" fontSize:24];
        
        highScore.position = CGPointMake(highScore.contentSize.width / 2, winSize.height - highScore.contentSize.height / 2);
        [self addChild:highScore];
        
        //high score value label
        CCLabelTTF* highScoreNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager sharedGlobalDataManager].highScore].stringValue fontName:@"Orbitron-Medium" fontSize:24];
        highScoreNum.position = CGPointMake(winSize.width - highScoreNum.contentSize.width / 2, winSize.height - highScoreNum.contentSize.height / 2);
        [self addChild:highScoreNum];
        
        
        //total coind label
        CCLabelTTF* totalCoins = [CCLabelTTF labelWithString:@"Total Coins" fontName:@"arial" fontSize:24];
        totalCoins.position = CGPointMake(totalCoins.contentSize.width / 2, winSize.height - totalCoins.contentSize.height / 2 -(highScore.contentSize.height*2));
        [self addChild:totalCoins];
        
        //total coins value label
        CCLabelTTF* totalCoinsNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager sharedGlobalDataManager].totalCoins].stringValue fontName:@"arial" fontSize:24];
        totalCoinsNum.position = CGPointMake(winSize.width - totalCoinsNum.contentSize.width / 2, winSize.height - totalCoinsNum.contentSize.height / 2 -(highScore.contentSize.height*2));
        [self addChild:totalCoinsNum];
        
        
        //total games label
        CCLabelTTF* totalGames = [CCLabelTTF labelWithString:@"Total Games" fontName:@"arial" fontSize:24];
        totalGames.position = CGPointMake(totalGames.contentSize.width / 2, winSize.height - totalGames.contentSize.height / 2 -(highScore.contentSize.height*4));
        [self addChild:totalGames];
        
        //total games value label
        CCLabelTTF* totalGamesNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager sharedGlobalDataManager].totalGames].stringValue fontName:@"arial" fontSize:24];
        totalGamesNum.position = CGPointMake(winSize.width - totalGamesNum.contentSize.width / 2, winSize.height - totalGamesNum.contentSize.height / 2 -(highScore.contentSize.height*4));
        [self addChild:totalGamesNum];
        
        
        //back buton
        CCMenuItem* back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(back:)];
        
        CCMenu* backMenu = [CCMenu menuWithItems:back, nil];
        //backMenu.position = CGPointMake(back.contentSize.width/6, winSizeActual.height - statsHeader.contentSize.height - back.contentSize.width/6);
        [self addChild:backMenu];
    }
    return self;
}


-(void) back:(id)sender{
    [[CCDirector sharedDirector] popScene];
}


-(void) dealloc{
    //[super dealloc];
}

@end