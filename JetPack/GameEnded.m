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
#import "Store.h"



@implementation GameEnded

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    scene.tag = GAME_ENDED_SCENE_TAG;
	GameEnded *layer = [GameEnded init];
	[scene addChild: layer z:0 tag:GAME_ENDED_LAYER_TAG];
	return scene;
}

-(id) init {
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        
        //game ended header
        CCSprite* gameOverHeader = [CCSprite spriteWithFile:@"GAME-OVER.png"];
        gameOverHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - gameOverHeader.contentSize.height/2 - gameOverHeader.contentSize.height/6);
        [self addChild:gameOverHeader];
        
        
        //score
        CCLabelTTF* score = [CCLabelTTF labelWithString:@"Score" fontName:@"Orbitron-Medium" fontSize:20];
        score.anchorPoint = CGPointMake(0, 0.5);
		score.position = CGPointMake(winSizeActual.width/32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (6.0/7));
        [self addChild:score];
        
        int numScore = [[GlobalDataManager sharedGlobalDataManager] scoreActual];
        CCLabelTTF* scoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numScore]stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        scoreNum.anchorPoint = CGPointMake(1, 0.5);
        scoreNum.position = CGPointMake(winSizeActual.width * 31 / 32, score.position.y);
        [self addChild:scoreNum];
        
        //high score
        CCLabelTTF* highScore = [CCLabelTTF labelWithString:@"High Score" fontName:@"Orbitron-Medium" fontSize:20];
        highScore.anchorPoint = CGPointMake(0, 0.5);
        highScore.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (5.0/7));
        [self addChild:highScore];
        
        int numHighScore = [[GlobalDataManager sharedGlobalDataManager] highScore];
        CCLabelTTF* highScoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numHighScore] stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        highScoreNum.anchorPoint = CGPointMake(1, 0.5);
        highScoreNum.position = CGPointMake(winSizeActual.width * 31 / 32, highScore.position.y);
        [self addChild:highScoreNum];
        
        //coins collected
        CCLabelTTF* coins = [CCLabelTTF labelWithString:@"Coins" fontName:@"Orbitron-Medium" fontSize:20];
        coins.anchorPoint = CGPointMake(0, 0.5);
        coins.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (4.0/7));
        [self addChild:coins];
        
        int numCoins = [[GlobalDataManager sharedGlobalDataManager] numCoins];
        CCLabelTTF* coinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numCoins]stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        coinsNum.anchorPoint = CGPointMake(1, 0.5);
        coinsNum.position = CGPointMake(winSizeActual.width * 31 / 32, coins.position.y);
        [self addChild:coinsNum];
        
        //total coins
        CCLabelTTF* totalCoins = [CCLabelTTF labelWithString:@"Total Coins" fontName:@"Orbitron-Medium" fontSize:20];
        totalCoins.anchorPoint = CGPointMake(0, 0.5);
        totalCoins.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (3.0/7));
        [self addChild:totalCoins];
        
        int numTotalCoins = [[GlobalDataManager sharedGlobalDataManager] totalCoins];
        CCLabelTTF* totalCoinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numTotalCoins] stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        totalCoinsNum.anchorPoint = CGPointMake(1, 0.5);
        totalCoinsNum.position = CGPointMake(winSizeActual.width * 31 / 32, totalCoins.position.y);
        [self addChild:totalCoinsNum];
        
        
        //bottom buttons
        CCMenuItem* playAgain = [CCMenuItemImage itemWithNormalImage:@"Classic.png" selectedImage:@"Classic.png" target:self selector:@selector(playAgain:)];
        CCMenu* playAgainMenu = [CCMenu menuWithItems:playAgain, nil];
        playAgainMenu.position = CGPointMake(winSizeActual.width/2, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (2.0/7));
        [self addChild:playAgainMenu];
        
        CCMenuItem* mainMenu = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Push-Stats.png" target:self selector:@selector(mainMenu:)];
        CCMenu* mainMenuMenu = [CCMenu menuWithItems:mainMenu, nil];
        mainMenuMenu.position = CGPointMake(winSizeActual.width/4, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (1.0/7));
        [self addChild:mainMenuMenu];
        
        CCMenuItem* store = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Push-Store.png" target:self selector:@selector(store:)];
        CCMenu* storeMenu = [CCMenu menuWithItems:store, nil];
        storeMenu.position = CGPointMake(winSizeActual.width*3/4, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (1.0/7));
        [self addChild:storeMenu];
        
        
        
        
        //ad
        int rand = arc4random() % 2 + 1;
        
        if (rand == 1) {
            //chartboost
            if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
            }
            else {
                RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                    [fs showAd];
                    NSLog(@"Ad loaded");
                } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                    NSLog(@"Ad error: %@",error);
                    //attempt to fill with other ad network here
                } onClickHandler:^{
                    NSLog(@"Ad clicked");
                } onCloseHandler:^{
                    NSLog(@"Ad closed");
                }];
            }
 
        }
        else {
            //revmob
            RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
            [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                [fs showAd];
                NSLog(@"Ad loaded");
            } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                NSLog(@"Ad error: %@",error);
                //attempt to fill with other ad network here
                [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
            } onClickHandler:^{
                NSLog(@"Ad clicked");
            } onCloseHandler:^{
                NSLog(@"Ad closed");
            }];
        }
        
        
        
    }
    return self;
}

-(void) mainMenu:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}
-(void) store:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
    [[CCDirector sharedDirector] pushScene:[Store scene]];
}
-(void) playAgain:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
}

@end