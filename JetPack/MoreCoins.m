//
//  MoreCoins.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/16/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "MoreCoins.h"
#import "GlobalDataManager.h"
#import "vunglepub.h"


@implementation MoreCoins

@synthesize didWatchAd, adDidClose;

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	MoreCoins *layer = [MoreCoins node];
	[scene addChild: layer z:0 tag:MORE_COINS_LAYER_TAG];
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
        
        
        //more coins header
        CCSprite* moreCoinsHeader = [CCSprite spriteWithFile:@"upgrade-header.png"];
        moreCoinsHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - moreCoinsHeader.contentSize.height/2);
        [self addChild:moreCoinsHeader z:-10];
        
        //back button
        CCMenuItem* back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(back:)];
        CCMenu* backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        [self addChild:backMenu];
        
        
        //number of coins
        CCSprite* coinIcon = [CCSprite spriteWithFile:@"store-coin.png"];
        coinIcon.position = CGPointMake(winSizeActual.width - backMenu.position.x + back.contentSize.width/2 - coinIcon.contentSize.width/2, backMenu.position.y);
        [self addChild:coinIcon];
        NSNumber* numCoins = [NSNumber numberWithInt: [[GlobalDataManager sharedGlobalDataManager] totalCoins]];
        coins = [CCLabelTTF labelWithString:[numCoins stringValue] fontName:@"Orbitron-Light" fontSize:18];
        coins.anchorPoint = CGPointMake(1, 0.5);
        coins.position = CGPointMake(coinIcon.position.x - coinIcon.contentSize.width/2 - 1, coinIcon.position.y-1.5);
        
        coins.color = ccWHITE;
        [self addChild:coins z:1];
        
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke];
        
        
        //buy more coins
        CCMenuItem* moreCoins1 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(buyMoreCoins1:)];
        CCMenuItem* moreCoins2 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(buyMoreCoins2:)];
        CCMenuItem* moreCoins3 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(buyMoreCoins3:)];
        
        CCMenu* moreCoins1Menu = [CCMenu menuWithItems:moreCoins1, nil];
        CCMenu* moreCoins2Menu = [CCMenu menuWithItems:moreCoins2, nil];
        CCMenu* moreCoins3Menu = [CCMenu menuWithItems:moreCoins3, nil];
        
        
        moreCoins1Menu.position = CGPointMake(winSizeActual.width - moreCoins1.contentSize.width/2 - moreCoins1.contentSize.width/5, (backMenu.position.y) * (4.0/5));
        moreCoins2Menu.position = CGPointMake(winSizeActual.width - moreCoins2.contentSize.width/2 - moreCoins2.contentSize.width/5, (backMenu.position.y) * (3.0/5));
        moreCoins3Menu.position = CGPointMake(winSizeActual.width - moreCoins3.contentSize.width/2 - moreCoins3.contentSize.width/5, (backMenu.position.y) * (2.0/5));
        
        [self addChild:moreCoins1Menu];
        [self addChild:moreCoins2Menu];
        [self addChild:moreCoins3Menu];
        
        
        //free coins button
        CCMenuItem* freeCoins = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Store.png" target:self selector:@selector(freeCoins:)];
        CCMenu* freeCoinsMenu = [CCMenu menuWithItems:freeCoins, nil];
        freeCoinsMenu.position = CGPointMake(winSizeActual.width/2, (backMenu.position.y) * (1.0/5));
        [self addChild:freeCoinsMenu];
        
        
        //todo: if ad is available, put exclamation mark in upper left corner
    }
    return self;
}



-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}

-(void) buyMoreCoins1:(id)sender {
    
}
-(void) buyMoreCoins2:(id)sender {
    
}
-(void) buyMoreCoins3:(id)sender {
    
}
-(void) freeCoins:(id)sender {
    //vungle
    if ([VGVunglePub adIsAvailable]) {
        [VGVunglePub playIncentivizedAd:[CCDirector sharedDirector].parentViewController animated:YES showClose:NO userTag:nil];
    }
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



-(void) adClosed {
    [[GlobalDataManager sharedGlobalDataManager] setTotalCoins:[[GlobalDataManager sharedGlobalDataManager]totalCoins] + NUMBER_OF_COINS_PER_VIEW];
    [coins setString: [NSString stringWithFormat:@"%d",[[GlobalDataManager sharedGlobalDataManager] totalCoins]]];
    
}


@end
