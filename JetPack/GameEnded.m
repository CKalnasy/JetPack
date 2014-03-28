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
#import <iAd/iAd.h>



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
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        //game ended header
        CCSprite* gameOverHeader = [CCSprite spriteWithFile:@"GAME-OVER.png"];
        gameOverHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - gameOverHeader.contentSize.height/2 - gameOverHeader.contentSize.height/6);
        [self addChild:gameOverHeader];
        
        
        //score
        CCLabelTTF* score = [CCLabelTTF labelWithString:@"Score" fontName:@"Orbitron-Medium" fontSize:20];
        score.anchorPoint = CGPointMake(0, 0.5);
		score.position = CGPointMake(winSizeActual.width/32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (7.0/8));
        [self addChild:score];
        
        int numScore = [[GlobalDataManager sharedGlobalDataManager] scoreActual];
        CCLabelTTF* scoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numScore]stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        scoreNum.anchorPoint = CGPointMake(1, 0.5);
        scoreNum.position = CGPointMake(winSizeActual.width * 31 / 32, score.position.y);
        [self addChild:scoreNum];
        
        //high score
        CCLabelTTF* highScore = [CCLabelTTF labelWithString:@"High Score" fontName:@"Orbitron-Medium" fontSize:20];
        highScore.anchorPoint = CGPointMake(0, 0.5);
        highScore.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (6.0/8));
        [self addChild:highScore];
        
        int numHighScore = [[GlobalDataManager sharedGlobalDataManager] highScore];
        CCLabelTTF* highScoreNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numHighScore] stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        highScoreNum.anchorPoint = CGPointMake(1, 0.5);
        highScoreNum.position = CGPointMake(winSizeActual.width * 31 / 32, highScore.position.y);
        [self addChild:highScoreNum];
        
        //coins collected
        CCLabelTTF* coins = [CCLabelTTF labelWithString:@"Coins" fontName:@"Orbitron-Medium" fontSize:20];
        coins.anchorPoint = CGPointMake(0, 0.5);
        coins.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (5.0/8));
        [self addChild:coins];
        
        
        int numBonusCoins = [[GlobalDataManager sharedGlobalDataManager] scoreActual] * COIN_PERCENTAGE_OF_SCORE;
        int numCoins = [[GlobalDataManager sharedGlobalDataManager] numCoins] - numBonusCoins;
        
        
        CCLabelTTF* coinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numCoins]stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        coinsNum.anchorPoint = CGPointMake(1, 0.5);
        coinsNum.position = CGPointMake(winSizeActual.width * 31 / 32, coins.position.y);
        [self addChild:coinsNum];
        
        //reset numCoins
        [[GlobalDataManager sharedGlobalDataManager] setNumCoins:0];
        
        
        //bonus coins
        CCLabelTTF* bonusCoins = [CCLabelTTF labelWithString:@"Launch Bonus" fontName:@"Orbitron-Medium" fontSize:20];
        bonusCoins.anchorPoint = CGPointMake(0, 0.5);
        bonusCoins.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (4.0/8));
        [self addChild:bonusCoins];
        
        CCLabelTTF* bonusCoinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numBonusCoins]stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        bonusCoinsNum.anchorPoint = CGPointMake(1, 0.5);
        bonusCoinsNum.position = CGPointMake(winSizeActual.width * 31 / 32, bonusCoins.position.y);
        [self addChild:bonusCoinsNum];
        
        
        
        //total coins
        CCLabelTTF* totalCoins = [CCLabelTTF labelWithString:@"Total Coins" fontName:@"Orbitron-Medium" fontSize:20];
        totalCoins.anchorPoint = CGPointMake(0, 0.5);
        totalCoins.position = CGPointMake(winSizeActual.width / 32, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (3.0/8));
        [self addChild:totalCoins];
        
        int numTotalCoins = [[GlobalDataManager sharedGlobalDataManager] totalCoins];
        CCLabelTTF* totalCoinsNum = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:numTotalCoins] stringValue] fontName:@"Orbitron-Medium" fontSize:20];
        totalCoinsNum.anchorPoint = CGPointMake(1, 0.5);
        totalCoinsNum.position = CGPointMake(winSizeActual.width * 31 / 32, totalCoins.position.y);
        [self addChild:totalCoinsNum];
        
        
        //bottom buttons
        CCMenuItem* playAgain = [CCMenuItemImage itemWithNormalImage:@"Play-again-button.png" selectedImage:@"Push-Play-again.png" target:self selector:@selector(playAgain:)];
        CCMenu* playAgainMenu = [CCMenu menuWithItems:playAgain, nil];
        playAgainMenu.position = CGPointMake(winSizeActual.width/2, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (2.0/8));
        [self addChild:playAgainMenu];
        
        CCMenuItem* mainMenu = [CCMenuItemImage itemWithNormalImage:@"Menu-button.png" selectedImage:@"Push-Menu.png" target:self selector:@selector(mainMenu:)];
        CCMenu* mainMenuMenu = [CCMenu menuWithItems:mainMenu, nil];
        mainMenuMenu.position = CGPointMake(winSizeActual.width/4, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (1.0/8));
        [self addChild:mainMenuMenu];
        
        CCMenuItem* store = [CCMenuItemImage itemWithNormalImage:@"Store-small-button.png" selectedImage:@"Push-Store-small.png" target:self selector:@selector(store:)];
        CCMenu* storeMenu = [CCMenu menuWithItems:store, nil];
        storeMenu.position = CGPointMake(winSizeActual.width*3/4, (gameOverHeader.position.y - gameOverHeader.contentSize.height/2) * (1.0/8));
        [self addChild:storeMenu];
                
        
//        //ad
//        if (![GlobalDataManager isPremiumContentWithDict]) {
//            int rand = arc4random() % 6;
//            
//            
//            if (rand < 3) {
//                adMob = [[GADInterstitial alloc] init];
//                adMob.adUnitID = @"ca-app-pub-2990915069046891/7775020160";
//                [adMob loadRequest:[GADRequest request]];
//
//                [self schedule:@selector(displayAdMob:)];
//            }
//            else {
//                interstitial = [[ADInterstitialAd alloc] init];
//                interstitial.delegate = self;
//                
//                [self schedule:@selector(displayIAd:)];
//            }

            
            
//            if (rand == 1 || rand == 0) {
//                //chartboost
//                if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
//                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
//                }
//                else {
//                    [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
//                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//                        CCScene* s = [[CCDirector sharedDirector] runningScene];
//                        if (s.tag == GAME_SCENE_TAG) {
//                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
//                            
//                            if (g.isGameOver) {
//                                [fs showAd];
//                                NSLog(@"Ad loaded");
//                            }
//                            else {
//                                NSLog(@"Ad loaded but not at appropriate time");
//                            }
//                        }
//                        else {
//                            NSLog(@"Ad loaded but not at appropriate scene");
//                        }
//                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//                        NSLog(@"Ad error: %@",error);
//                        //attempt to fill with other ad network here
//                    } onClickHandler:^{
//                        NSLog(@"Ad clicked");
//                    } onCloseHandler:^{
//                        NSLog(@"Ad closed");
//                    }];
//                }
//
//            }
//            else if (rand == 2) {
//                //revmob
//                RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//                [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//                    CCScene* s = [[CCDirector sharedDirector] runningScene];
//                    if (s.tag == GAME_SCENE_TAG) {
//                        Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
//                        
//                        if (g.isGameOver) {
//                            [fs showAd];
//                            NSLog(@"Ad loaded");
//                        }
//                        else {
//                            NSLog(@"Ad loaded but not at appropriate time");
//                        }
//                    }
//                    else {
//                        NSLog(@"Ad loaded but not at appropriate scene");
//                    }
//
//                } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//                    NSLog(@"Ad error: %@",error);
//                    //attempt to fill with other ad network here
//                    if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
//                        [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
//                    }
//                } onClickHandler:^{
//                    NSLog(@"Ad clicked");
//                } onCloseHandler:^{
//                    NSLog(@"Ad closed");
//                }];
//            }
//            else if (rand == 3 || rand == 4) {
//                //Location Object
//                AppController *appDelegate = [AppController appDelegate];
//                
//                if ([MMInterstitial isAdAvailableForApid:@"147848"]) {
//                    [MMInterstitial displayForApid:@"147848"
//                                fromViewController:[[CCDirector sharedDirector] parentViewController]
//                                   withOrientation:0
//                                      onCompletion:nil];
//                    
//                }
//                else {
//                    //MMRequest Object
//                    MMRequest *request = [MMRequest requestWithLocation:appDelegate.locationManager.location];
//                    
//                    [MMInterstitial fetchWithRequest:request
//                                                apid:@"147848"
//                                        onCompletion:^(BOOL success, NSError *error) {
//                                            if (success) {
//                                                [MMInterstitial displayForApid:@"147848"
//                                                            fromViewController:[[CCDirector sharedDirector] parentViewController]
//                                                               withOrientation:0
//                                                                  onCompletion:nil];
//                                            }
//                                            else {
//                                                RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//                                                [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//                                                    CCScene* s = [[CCDirector sharedDirector] runningScene];
//                                                    if (s.tag == GAME_SCENE_TAG) {
//                                                        Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
//                                                        
//                                                        if (g.isGameOver) {
//                                                            [fs showAd];
//                                                            NSLog(@"Ad loaded");
//                                                        }
//                                                        else {
//                                                            NSLog(@"Ad loaded but not at appropriate time");
//                                                        }
//                                                    }
//                                                    else {
//                                                        NSLog(@"Ad loaded but not at appropriate scene");
//                                                    }
//                                                } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//                                                    NSLog(@"Ad error: %@",error);
//                                                    //attempt to fill with other ad network here
//                                                } onClickHandler:^{
//                                                    NSLog(@"Ad clicked");
//                                                } onCloseHandler:^{
//                                                    NSLog(@"Ad closed");
//                                                }];
//                                            }
//                                        }];
//                }
//            }
//            else if (rand == 5) {
//                adMob = [[GADInterstitial alloc] init];
//                adMob.adUnitID = @"ca-app-pub-2990915069046891/7775020160";
//                [adMob loadRequest:[GADRequest request]];
//                
//                [self schedule:@selector(displayAdMob:)];
//            }
//            else {
////                self.interstitial = [[GADInterstitial alloc] init];
////                self.interstitial.delegate = self;
////                AppController *appDelegate = [AppController appDelegate];
////                self.interstitial.adUnitID = @"ca-app-pub-2990915069046891/7775020160";
////                
////                [self.interstitial loadRequest: [appDelegate createRequest]];
//                
//                interstitial = [[ADInterstitialAd alloc] init];
//                interstitial.delegate = self;
//                
//                [self schedule:@selector(displayIAd:)];
//            }
//        }
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




//-(void) displayIAd:(ccTime)delta {
//    if (interstitial.loaded) {
//        [interstitial presentFromViewController:[[CCDirector sharedDirector] parentViewController]];
//        [self unschedule:@selector(displayIAd:)];
//    }
//    if (timeIAd >= IAD_TIMEOUT * 260) {
//        [self unschedule:@selector(displayIAd:)];        
//        //chartboost
//        if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
//            [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
//        }
//        else {
//            [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
//            RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//            [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//                CCScene* s = [[CCDirector sharedDirector] runningScene];
//                if (s.tag == GAME_SCENE_TAG) {
//                    Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
//                    
//                    if (g.isGameOver) {
//                        [fs showAd];
//                        NSLog(@"Ad loaded");
//                    }
//                    else {
//                        NSLog(@"Ad loaded but not at appropriate time");
//                    }
//                }
//                else {
//                    NSLog(@"Ad loaded but not at appropriate scene");
//                }
//            } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//                NSLog(@"Ad error: %@",error);
//                //attempt to fill with other ad network here
//            } onClickHandler:^{
//                NSLog(@"Ad clicked");
//            } onCloseHandler:^{
//                NSLog(@"Ad closed");
//            }];
//        }
//    }
//    timeIAd++;
//}
//
//
//-(void) displayAdMob:(ccTime)delta {
//    if (adMob.isReady) {
//        [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
//        [self unschedule:@selector(displayAdMob:)];
//    }
//    if (timeIAd >= IAD_TIMEOUT * 60) {
//        [self unschedule:@selector(displayAdMob:)];
//        //todo: fill with other ad network
//        //chartboost
//        if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
//            [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
//        }
//        else {
//            [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
//            RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
//            [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
//                CCScene* s = [[CCDirector sharedDirector] runningScene];
//                if (s.tag == GAME_SCENE_TAG) {
//                    Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
//                    
//                    if (g.isGameOver) {
//                        [fs showAd];
//                        NSLog(@"Ad loaded");
//                    }
//                    else {
//                        NSLog(@"Ad loaded but not at appropriate time");
//                    }
//                }
//                else {
//                    NSLog(@"Ad loaded but not at appropriate scene");
//                }
//            } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//                NSLog(@"Ad error: %@",error);
//                //attempt to fill with other ad network here
//            } onClickHandler:^{
//                NSLog(@"Ad clicked");
//            } onCloseHandler:^{
//                NSLog(@"Ad closed");
//            }];
//        }
//    }
//    timeIAd++;
//}



#pragma mark ADInterstitialViewDelegate methods

// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    interstitial = [[ADInterstitialAd alloc] init];
    interstitial.delegate = self;
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    interstitial = [[ADInterstitialAd alloc] init];
    interstitial.delegate = self;
}




@end