//
//  GameEnded.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "GameEnded.h"
#import "Game.h"
#import "GlobalDataManager.h"
#import "MainMenu.h"
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"


@implementation GameEnded

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	GameEnded *layer = [GameEnded node];
	[scene addChild: layer z:0 tag:GAME_ENDED_SCENE_TAG];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        //revmob;
        /*RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
            [fs showAd];
            NSLog(@"Ad loaded");
        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
            NSLog(@"Ad error: %@",error);
            //todo: attempt to fill with other ad network
        } onClickHandler:^{
            NSLog(@"Ad clicked");
        } onCloseHandler:^{
            NSLog(@"Ad closed");
        }];*/
        
        //chartboost
        /*Chartboost *cb = [Chartboost sharedChartboost];
        cb.appId = @"522e7eb717ba477e16000009";
        cb.appSignature = @"3ffe2184c225347db82fd1e9339e2bc30a299cc2";
        
        [cb startSession];*/
        
        [[GlobalDataManager sharedGlobalDataManager].cb showInterstitial:@"After Game Ended"];
        
        
        //score
        CCLabelTTF* score = [CCLabelTTF labelWithString:@"Score" fontName:@"arial" fontSize:20];
		score.position = CGPointMake(winSize.width/32, winSize.height / 2);
        score.anchorPoint = CGPointMake(0, 0);
        [self addChild:score];
        
        int numScore = [[GlobalDataManager sharedGlobalDataManager] scoreActual];
        CCLabelTTF* scoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numScore]stringValue] fontName:@"arial" fontSize:20];
        scoreNum.position = CGPointMake(winSize.width * 31 / 32, score.position.y);
        [self addChild:scoreNum];
        
        //high score
        CCLabelTTF* highScore = [CCLabelTTF labelWithString:@"High Score" fontName:@"arial" fontSize:20];
        highScore.position = CGPointMake(winSize.width / 32, score.position.y - score.contentSize.height * 2);
        highScore.anchorPoint = CGPointMake(0, 0);
        [self addChild:highScore];
        
        int numHighScore = [[GlobalDataManager sharedGlobalDataManager] highScore];
        CCLabelTTF* highScoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numHighScore] stringValue] fontName:@"arial" fontSize:20];
        highScoreNum.position = CGPointMake(winSize.width * 31 / 32, highScore.position.y);
        [self addChild:highScoreNum];
        
        //coins collected
        CCLabelTTF* coins = [CCLabelTTF labelWithString:@"Coins" fontName:@"arial" fontSize:20];
        coins.position = CGPointMake(winSize.width / 32, highScore.position.y - highScore.contentSize.height * 2);
        coins.anchorPoint = CGPointMake(0, 0);
        [self addChild:coins];
        
        int numCoins = [[GlobalDataManager sharedGlobalDataManager] numCoins];
        CCLabelTTF* coinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numCoins]stringValue] fontName:@"arial" fontSize:20];
        coinsNum.position = CGPointMake(winSize.width * 31 / 32, coins.position.y);
        [self addChild:coinsNum];
        
        
        //main menu button
        CCMenuItem* mainMenuButton = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Stats.png" target:self selector:@selector(mainMenu:)];
        CCMenu* menu = [CCMenu menuWithItems:mainMenuButton, nil];
        menu.position = CGPointMake(winSize.width / 2, winSize.height / 10);
        
        [self addChild:menu];
        
    }
    return self;
}

-(void) mainMenu:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}

@end