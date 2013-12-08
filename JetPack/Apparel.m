//
//  Apparel.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Apparel.h"
#import "Player.h"
#import "Clothes.h"
#import "GlobalDataManager.h"


@implementation Apparel

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Apparel *layer = [Apparel node];
	[scene addChild: layer];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        winSizeActual = [[CCDirector sharedDirector] winSize];
        winSize = CGSizeMake(320, 480);
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
//        CCSprite* apparelHeader = [CCSprite spriteWithFile:@"apparel-header.png"];
//        apparelHeader.position = CGPointMake(apparelHeader.contentSize.width/2, winSizeActual.height - apparelHeader.contentSize.height/2);
//        [self addChild:apparelHeader z:9];
        
        CCSprite* apparelHeaderTop = [CCSprite spriteWithFile:@"apparel-top.png"];
        apparelHeaderTop.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - apparelHeaderTop.contentSize.height/2);
        [self addChild:apparelHeaderTop z:9];
        
        CCSprite* apparelHeaderBottom = [CCSprite spriteWithFile:@"apparel-bottom.png"];
        apparelHeaderBottom.anchorPoint = CGPointMake(0.5, 1);
        apparelHeaderBottom.position = CGPointMake(winSizeActual.width/2, apparelHeaderTop.position.y - apparelHeaderTop.contentSize.height/2);
        [self addChild:apparelHeaderBottom z:4];
        
        CCMenuItem* back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        CCMenu* backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        
        [self addChild:backMenu z:10];
        
        //number of coins
        CCSprite* coinIcon = [CCSprite spriteWithFile:@"store-coin.png"];
        coinIcon.position = CGPointMake(winSizeActual.width - backMenu.position.x + back.contentSize.width/2 - coinIcon.contentSize.width/2, backMenu.position.y);
        [self addChild:coinIcon z:10];
        
        NSNumber* numCoins = [NSNumber numberWithInt: [[GlobalDataManager sharedGlobalDataManager] totalCoins]];
        coins = [CCLabelTTF labelWithString:[numCoins stringValue] fontName:@"Orbitron-Light" fontSize:18];
        coins.anchorPoint = CGPointMake(1, 0.5);
        coins.position = CGPointMake(coinIcon.position.x - coinIcon.contentSize.width/2 - 1, coinIcon.position.y-1.5);
        coins.color = ccWHITE;
        [self addChild:coins z:10];
        
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:9];
        
        
        [self addChild:[Clothes scene] z:5];
        
        CCSprite* mask = [CCSprite spriteWithFile:@"flipped base background.png"];
        [mask setTextureRect:CGRectMake(0, winSizeActual.height - 138.42 + 75/3, winSizeActual.width, 138.42 - 75/3)];
        mask.scaleY = -1;
        mask.anchorPoint = CGPointMake(0, 1);
        mask.position = CGPointMake(0, winSizeActual.height - 138.42 + 75/3);
        [self addChild:mask z:6];
        
        self.touchEnabled = YES;
    }
    return self;
}



-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
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
    for (int i=0; i<360; i+=60) // you should optimize that for your needs
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

@end
