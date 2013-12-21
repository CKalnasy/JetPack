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
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        CCSprite* statsHeader = [CCSprite spriteWithFile:@"stats-header.png"];
        statsHeader.position = CGPointMake(statsHeader.contentSize.width/2, winSizeActual.height - statsHeader.contentSize.height/2);
        [self addChild:statsHeader];
        
        
        
        //back button
        back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        
        [self addChild:backMenu];
        
        float pos = (backMenu.position.y - back.contentSize.height/2) / 5.0;
        
        
        
        
        
        //high score label
        CCLabelTTF* highScore = [CCLabelTTF labelWithString:@"HIGH SCORE" fontName:@"Orbitron-Medium" fontSize:24];
        
        highScore.position = CGPointMake(highScore.contentSize.width / 2 + POS_OFFSET, pos * 4);
        [self addChild:highScore z:2];
        
        CCRenderTexture* highScoreStroke = [self createStroke:highScore size:0.5 color:ccBLACK];
        highScoreStroke.position = highScore.position;
        [self addChild:highScoreStroke z:1];
        
        
        //high score value label
        CCLabelTTF* highScoreNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager highScoreWithDict]].stringValue fontName:@"Orbitron-Medium" fontSize:24];
        highScoreNum.position = CGPointMake(winSize.width - highScoreNum.contentSize.width / 2 - POS_OFFSET, highScore.position.y);
        [self addChild:highScoreNum z:2];
        
        CCRenderTexture* highScoreNumStroke = [self createStroke:highScoreNum size:0.5 color:ccBLACK];
        highScoreNumStroke.position = highScoreNum.position;
        [self addChild:highScoreNumStroke z:1];
        
        
        //total coins label
        CCLabelTTF* totalCoins = [CCLabelTTF labelWithString:@"TOTAL COINS" fontName:@"Orbitron-Medium" fontSize:24];
        totalCoins.position = CGPointMake(totalCoins.contentSize.width / 2 + POS_OFFSET, pos * 3);
        [self addChild:totalCoins z:2];
        
        CCRenderTexture* totalCoinsStroke = [self createStroke:totalCoins size:0.5 color:ccBLACK];
        totalCoinsStroke.position = totalCoins.position;
        [self addChild:totalCoinsStroke z:1];
        
        
        //total coins value label
        CCLabelTTF* totalCoinsNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager sharedGlobalDataManager].totalCoins].stringValue fontName:@"Orbitron-Medium" fontSize:24];
        totalCoinsNum.position = CGPointMake(winSize.width - totalCoinsNum.contentSize.width / 2 - POS_OFFSET, totalCoins.position.y);
        [self addChild:totalCoinsNum z:2];
        
        CCRenderTexture* totalCoinsNumStroke = [self createStroke:totalCoinsNum size:0.5 color:ccBLACK];
        totalCoinsNumStroke.position = totalCoinsNum.position;
        [self addChild:totalCoinsNumStroke z:1];
        
        
        //total games label
        CCLabelTTF* totalGames = [CCLabelTTF labelWithString:@"TOTAL GAMES" fontName:@"Orbitron-Medium" fontSize:24];
        totalGames.position = CGPointMake(totalGames.contentSize.width / 2 + POS_OFFSET, pos * 2);
        [self addChild:totalGames z:2];
        
        CCRenderTexture* totalGamesStroke = [self createStroke:totalGames size:0.5 color:ccBLACK];
        totalGamesStroke.position = totalGames.position;
        [self addChild:totalGamesStroke z:1];
        
        
        //total games value label
        CCLabelTTF* totalGamesNum = [CCLabelTTF labelWithString: [NSNumber numberWithInt:[GlobalDataManager sharedGlobalDataManager].totalGames].stringValue fontName:@"Orbitron-Medium" fontSize:24];
        totalGamesNum.position = CGPointMake(winSize.width - totalGamesNum.contentSize.width / 2 - POS_OFFSET, totalGames.position.y);
        [self addChild:totalGamesNum z:2];
        
        CCRenderTexture* totalGamesNumStroke = [self createStroke:totalGamesNum size:0.5 color:ccBLACK];
        totalGamesNumStroke.position = totalGamesNum.position;
        [self addChild:totalGamesNumStroke z:1];
        
        
        CCMenuItem* leaderboards = [CCMenuItemImage itemWithNormalImage:@"Leaderboards-button.png" selectedImage:@"Push-Leaderboards.png" target:self selector:@selector(leaderboard:)];
        
        CCMenu* leaderboardsMenu = [CCMenu menuWithItems:leaderboards, nil];
        leaderboardsMenu.position = CGPointMake(winSizeActual.width/2, pos * 1);
        [self addChild:leaderboardsMenu];
        
        
        //todo gamecenter total coins 
    }
    return self;
}


-(void) back:(id)sender{
    [[CCDirector sharedDirector] popScene];
}

-(void) leaderboard:(id)sender {
    [[GameKitHelper sharedGameKitHelper] showGameCenterViewController];
}




-(CCRenderTexture*) createStroke: (CCLabelTTF*) label   size:(float)size   color:(ccColor3B)cor
{
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:label.texture.contentSize.width+size*2  height:label.texture.contentSize.height+size*2];
    CGPoint originalPos = [label position];
    ccColor3B originalColor = [label color];
    BOOL originalVisibility = [label visible];
    [label setColor:cor];
    [label setVisible:YES];
    ccBlendFunc originalBlend = [label blendFunc];
    [label setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    CGPoint bottomLeft = ccp(label.texture.contentSize.width * label.anchorPoint.x + size, label.texture.contentSize.height * label.anchorPoint.y + size);
    //CGPoint positionOffset = ccp(label.texture.contentSize.width * label.anchorPoint.x - label.texture.contentSize.width/2,label.texture.contentSize.height * label.anchorPoint.y - label.texture.contentSize.height/2);
    //use this for adding stoke to its self...
    CGPoint positionOffset= ccp(-label.contentSize.width/2,-label.contentSize.height/2);
    
    CGPoint position = ccpSub(originalPos, positionOffset);
    
    [rt begin];
    for (int i=0; i<360; i+=30) // you should optimize that for your needs
    {
        [label setPosition:ccp(bottomLeft.x + sin(CC_DEGREES_TO_RADIANS(i))*size, bottomLeft.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
        [label visit];
    }
    [rt end];
    [[[rt sprite] texture] setAntiAliasTexParameters];//THIS
    [label setPosition:originalPos];
    [label setColor:originalColor];
    [label setBlendFunc:originalBlend];
    [label setVisible:originalVisibility];
    [rt setPosition:position];
    return rt;
}



-(void) dealloc{
    //[super dealloc];
}

@end