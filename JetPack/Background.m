//
//  Background.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Background.h"
#import "GlobalDataManager.h"
#import "Game.h"


@implementation Background

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Background *layer = [Background node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        self.touchEnabled = YES;
        winSizeActual = [[CCDirector sharedDirector]winSize];
        winSizeThreeInch = CGSizeMake(320, 480);
        winSizeFourInch = CGSizeMake(320, 568);
        
        
        //background scrolling order
        backgroundOrder = [CCArray arrayWithCapacity:6];
        for (int i = 0; i < [backgroundOrder capacity]; i++) {
            int rand = arc4random() % 6 + 1;
            while ([backgroundOrder containsObject:[NSNumber numberWithInt:rand]]) {
                rand = arc4random() % 6 + 1;
            }
            [backgroundOrder addObject:[NSNumber numberWithInt:rand]];
        }
        
        //add the background sprites
        bg1 = [CCSprite spriteWithFile:@"base background.png"];
        bg1.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg1 z:-10];
        
        NSString* name =[NSString stringWithFormat:@"%d.png",[[backgroundOrder objectAtIndex:0] intValue]];
        [backgroundOrder removeObjectAtIndex:0];
        
        bg2 = [CCSprite spriteWithFile:name];
        bg2.anchorPoint = CGPointMake(0, 0);
        bg2.position = CGPointMake(0, bg1.position.y + bg1.contentSize.height);
        [self addChild:bg2 z:-10];
        
        //scrolling velocities
        backgroundScrollSpeed = CGPointMake(0, 5);
        
        //shows the word "score"
        wordScore = [CCLabelTTF labelWithString:@"SCORE" fontName:@"arial" fontSize:20];
        //positions the word 10 pixels away from the corner
        wordScore.position = CGPointMake(0 + winSizeActual.width/32, winSizeActual.height);
        wordScore.anchorPoint = CGPointMake(0,1);
        [self addChild:wordScore];
                
        //shows the score
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"arial" fontSize:24];
		scoreLabel.position = CGPointMake(0 + winSizeActual.width/32, winSizeActual.height - scoreLabel.contentSize.height);
		// Adjust the label's anchorPoint's y position to make it align with the top.
		scoreLabel.anchorPoint = CGPointMake(0,1);
        [self addChild:scoreLabel];
        
        //shows the coins
        coinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"arial" fontSize:24];
		coinsLabel.position = CGPointMake(winSizeActual.width - winSizeActual.width/32, winSizeActual.height);
		// Adjust the label's anchorPoint's y position to make it align with the top.
		coinsLabel.anchorPoint = CGPointMake(1,1);
        [self addChild:coinsLabel];
        
        //shows the fuel left
        NSString* fuelText = [NSString stringWithFormat:@"%i", [[GlobalDataManager sharedGlobalDataManager]maxFuel]];
        fuelLabel = [CCLabelTTF labelWithString:fuelText fontName:@"arial" fontSize:24];
        fuelLabel.position = CGPointMake(winSizeActual.width - winSizeActual.width/32, winSizeActual.height - 50);
        fuelLabel.anchorPoint = CGPointMake(1, 1);
        [self addChild:fuelLabel];
        
        //[fuelLabel setFontFillColor:ccWHITE updateImage:YES];
        //[fuelLabel enableStrokeWithColor:ccBLACK size:1 updateImage:YES];
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(backgroundScrolling:)];
        [self schedule:@selector(updateScrollingSpeed:)];
    }
	return self;
}

//updates score, coins, and fuel
-(void) update:(ccTime)delta{
    //score
    if (scoreActual != [[GlobalDataManager sharedGlobalDataManager] scoreActual]) {
        scoreActual = [[GlobalDataManager sharedGlobalDataManager] scoreActual];
        [scoreLabel setString: [NSString stringWithFormat:@"%i",scoreActual]];
        
        scoreRaw = [[GlobalDataManager sharedGlobalDataManager] scoreRaw];
    }
    
    //coins
    if (numCoins != [GlobalDataManager numCoins]) {
        numCoins = [GlobalDataManager numCoins];
        [coinsLabel setString: [NSString  stringWithFormat:@"%i",numCoins]];
    }
    
    //fuel
    if (fuel != [GlobalDataManager fuel]) {
        fuel = [GlobalDataManager fuel];
        [fuelLabel setString: [NSString  stringWithFormat:@"%i",fuel]];
    }
}

//background scrolling
-(void) backgroundScrolling:(ccTime)delta{
    playerVelocity = [[GlobalDataManager sharedGlobalDataManager] player].velocity;
    player = [[GlobalDataManager sharedGlobalDataManager] player];
    BOOL isPaused = [[GlobalDataManager sharedGlobalDataManager] isPaused];
    
    //if its still in the atmosphere (clouds)
    if ([backgroundOrder count] > 0) {
        //if the background top is at the bottom of the screen
        if (bg1.position.y <= -bg1.contentSize.height) {
            NSString* name = [NSString stringWithFormat:@"%d.png", [[backgroundOrder objectAtIndex:0] intValue]];
            [backgroundOrder removeObjectAtIndex:0];
        
            [bg1 setTexture:[[CCSprite spriteWithFile:name]texture]];
            bg1.position = CGPointMake(0, bg2.position.y + bg2.contentSize.height);
        }
        else if (bg2.position.y <= -bg2.contentSize.height) {
            NSString* name =[NSString stringWithFormat:@"%d.png",[[backgroundOrder objectAtIndex:0] intValue]];
            [backgroundOrder removeObjectAtIndex:0];
        
            [bg2 setTexture:[[CCSprite spriteWithFile:name]texture]];
            bg2.position = CGPointMake(0, bg1.position.y + bg1.contentSize.height);
        }
    }
    //adds transition background
    if ([backgroundOrder count] <= 0 && !didTransition && bg2.position.y <= -bg2.contentSize.height) {
        bgTransition = [CCSprite spriteWithFile:@"transition.png"];
        bgTransition.anchorPoint = CGPointMake(0, 0);
        bgTransition.position = CGPointMake(10, bg1.position.y + bg1.contentSize.height);
        [self addChild:bgTransition z:-10];
        
        [bg2 setTexture:[[CCSprite spriteWithFile:@"stars.png"]texture]];
        bg2.position = CGPointMake(0, bgTransition.position.y + bgTransition.contentSize.height);
            
        didTransition = YES;
    }
    
    //space!!!
    if (didTransition) {
        if (bgTransition.isRunning && bgTransition.position.y <= -bgTransition.contentSize.height) {
            [self removeChild:bgTransition];
        }
        
        //loops through stars backgrounds
        if (!bgTransition.isRunning && bg1.position.y <= -bg1.contentSize.height) {
            [bg1 setTexture:[[CCSprite spriteWithFile:@"stars.png"]texture]];
            bg1.position = CGPointMake(0, bg2.position.y + bg2.contentSize.height);
        }
        else if (!bgTransition.isRunning && bg2.position.y <= -bg2.contentSize.height) {
            [bg2 setTexture:[[CCSprite spriteWithFile:@"stars2.png"]texture]];
            bg2.position = CGPointMake(0, bg1.position.y + bg1.contentSize.height);
        }
    }
    
    
    //update the cloud backgrounds
    if (bg1.isRunning && playerVelocity.y > 0 && player.position.y >= winSizeActual.height / 3 && !isPaused) {
        bg1.position = CGPointMake(0, bg1.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
    if (bg2.isRunning && playerVelocity.y > 0 && player.position.y >= winSizeActual.height / 3 && !isPaused) {
        bg2.position = CGPointMake(0, bg2.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
    if (bgTransition.isRunning && playerVelocity.y > 0 && player.position.y >= winSizeActual.height / 3 && !isPaused) {
        bgTransition.position = CGPointMake(0, bgTransition.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
}


-(void) shake:(ccTime)delta{
    if (bgTransition.position.x < 0) {
        bgTransition.position = CGPointMake(bgTransition.position.x + 20, bgTransition.position.y);
    }
    else {
        bgTransition.position = CGPointMake(bgTransition.position.x - 20, bgTransition.position.y);
    }
}


-(void) updateScrollingSpeed:(ccTime)delta{
    if (!didTransition) {
        if (backgroundScrollSpeed.y > MIN_SCROLLING_SPEED_ATMOS && highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y -= 0.04;
            highestScoreChanged = scoreRaw;
        }
        else if(highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y = MIN_SCROLLING_SPEED_ATMOS;
        }
    }
    else {
        if (backgroundScrollSpeed.y > MIN_SCROLLING_SPEED_SPACE && highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y -= 0.003;
            highestScoreChanged = scoreRaw;
        }
        else if (highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y = MIN_SCROLLING_SPEED_SPACE;
        }
    }
}




- (void) dealloc
{
	//[super dealloc];
}
@end