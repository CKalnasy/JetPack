//
//  Store.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Store.h"
#import "MainMenu.h"
#import "Apparel.h"
#import "MoreCoins.h"
#import "GlobalDataManager.h"
#import "Upgrades.h"
#import "Jetpacks.h"
#import "vunglepub.h"


@implementation Store

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Store *layer = [Store node];
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
        
        //store header
        CCSprite* storeHeader = [CCSprite spriteWithFile:@"store-header.png"];
        storeHeader.position = CGPointMake(storeHeader.contentSize.width/2, winSizeActual.height - storeHeader.contentSize.height/2);
        [self addChild:storeHeader];
        
        //back button
        back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(back:)];
        backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - storeHeader.contentSize.height) - back.contentSize.width/6 - back.contentSize.height/2);
        
        [self addChild:backMenu];
        
        
        //menu
        CCMenuItem* upgrades = [CCMenuItemImage itemWithNormalImage:@"upgrades-button.png" selectedImage:@"upgrades-button.png" target:self selector:@selector(upgrades:)];
        CCMenuItem* jetpacks = [CCMenuItemImage itemWithNormalImage:@"jetpacks-button.png" selectedImage:@"jetpacks-button.png" target:self selector:@selector(jetpacks:)];
        CCMenuItem* apparel = [CCMenuItemImage itemWithNormalImage:@"apparel-button.png" selectedImage:@"apparel-button.png" target:self selector:@selector(apparel:)];
        CCMenuItem* moreCoins = [CCMenuItemImage itemWithNormalImage:@"more-coins-button.png" selectedImage:@"more-coins-button.png" target:self selector:@selector(moreCoins:)];
        
        CCMenu* menu = [CCMenu menuWithItems:upgrades, jetpacks, apparel, moreCoins, nil];
        [menu alignItemsVerticallyWithPadding:upgrades.contentSize.height];
        menu.position = CGPointMake(winSizeActual.width/2, (winSizeActual.height - storeHeader.contentSize.height)/2);
        [self addChild:menu];
        
        excPos = CGPointMake(moreCoins.position.x + moreCoins.contentSize.width/2, moreCoins.position.y + moreCoins.contentSize.height/2);
        [self schedule:@selector(updateExclamation:)];
    }
    return self;
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


//updates the coins
-(void) onEnter {
    [super onEnter];
    
    //number of coins
    if (coins.isRunning) {
        [self removeChild:coins cleanup:YES];
        [self removeChild:stroke cleanup:YES];
        coins = nil;
        stroke = nil;
    }
    
    CCSprite* coinIcon = [CCSprite spriteWithFile:@"store-coin.png"];
    coinIcon.position = CGPointMake(winSizeActual.width - backMenu.position.x + back.contentSize.width/2 - coinIcon.contentSize.width/2, backMenu.position.y);
    [self addChild:coinIcon];
    
    NSNumber* numCoins = [NSNumber numberWithInt: [[GlobalDataManager sharedGlobalDataManager] totalCoins]];
    coins = [CCLabelTTF labelWithString:[numCoins stringValue] fontName:@"Orbitron-Light" fontSize:18];
    coins.anchorPoint = CGPointMake(1, 0.5);
    coins.position = CGPointMake(coinIcon.position.x - coinIcon.contentSize.width/2 - 1, coinIcon.position.y-1.5);
    
    coins.color = ccWHITE;
    
    stroke = [self createStroke:coins size:0.5 color:ccBLACK];
    stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
    [self addChild:stroke];
    [self addChild:coins z:1];
}


-(void) upgrades:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Upgrades scene]];
}

-(void) jetpacks:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Jetpacks scene]];
}

-(void) apparel:(id)sender{
    [[CCDirector sharedDirector] pushScene:[Apparel scene]];
}

-(void) moreCoins:(id)sender{
    [[CCDirector sharedDirector] pushScene:[MoreCoins scene]];
}

-(void) back:(id)sender{
    [[CCDirector sharedDirector] popScene];
}


-(void) updateExclamation:(ccTime)delta {
    if (exclamation.isRunning) {
        return;
    }
    if ([VGVunglePub adIsAvailable]) {
        exclamation = [CCSprite spriteWithFile:@"!.png"];
        exclamation.position = excPos;
        [self addChild:exclamation];
    }
}


-(void) dealloc{
}
@end
