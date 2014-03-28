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
#import "JetpackIAPHelper.h"


@interface Store () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@end

@implementation Store

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Store *layer = [Store node];
    layer.tag = STORE_LAYER_TAG;
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
        back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        
        [self addChild:backMenu];
        
        
        //menu
        CCMenuItem* upgrades = [CCMenuItemImage itemWithNormalImage:@"upgrades-button.png" selectedImage:@"Push-Upgrades.png" target:self selector:@selector(upgrades:)];
        CCMenuItem* jetpacks = [CCMenuItemImage itemWithNormalImage:@"jetpack-button.png" selectedImage:@"Push-Jetpack.png" target:self selector:@selector(jetpacks:)];
        CCMenuItem* apparel = [CCMenuItemImage itemWithNormalImage:@"apparel-button.png" selectedImage:@"Push-Apparel.png" target:self selector:@selector(apparel:)];
        CCMenuItem* moreCoins = [CCMenuItemImage itemWithNormalImage:@"more-coins-button.png" selectedImage:@"Push-More-coins.png" target:self selector:@selector(moreCoins:)];
        
        float pos;
        CCMenu* menuUpgrades;
        CCMenu* menuJetpacks;
        CCMenu* menuApparel;
        CCMenu* menuMoreCoins;
        
        if (![GlobalDataManager isPremiumContentWithDict]) {
            pos = (backMenu.position.y - back.contentSize.height/2) / 6.0;
            
            menuUpgrades = [CCMenu menuWithItems:upgrades, nil];
            menuUpgrades.position = CGPointMake(winSizeActual.width/2, pos * 5);
            [self addChild:menuUpgrades];
            
            menuJetpacks = [CCMenu menuWithItems:jetpacks, nil];
            menuJetpacks.position = CGPointMake(winSizeActual.width/2, pos * 4);
            [self addChild:menuJetpacks];
            
            menuApparel = [CCMenu menuWithItems:apparel, nil];
            menuApparel.position = CGPointMake(winSizeActual.width/2, pos * 3);
            [self addChild:menuApparel];
            
            menuMoreCoins = [CCMenu menuWithItems:moreCoins, nil];
            menuMoreCoins.position = CGPointMake(winSizeActual.width/2, pos * 2);
            [self addChild:menuMoreCoins];
            
            adFree = [CCMenuItemImage itemWithNormalImage:@"Ad-free-button.png" selectedImage:@"Push-Ad-free.png" disabledImage:@"Push-Ad-free.png" target:self selector:@selector(adFree:)];
            
            menuAdFree = [CCMenu menuWithItems:adFree, nil];
            menuAdFree.position = CGPointMake(winSizeActual.width/2, pos * 1);
            [self addChild:menuAdFree];
            
            adFree.isEnabled = NO;
        }
        else {
            pos = (backMenu.position.y - back.contentSize.height/2) / 5.0;
            
            menuUpgrades = [CCMenu menuWithItems:upgrades, nil];
            menuUpgrades.position = CGPointMake(winSizeActual.width/2, pos * 4);
            [self addChild:menuUpgrades];
            
            menuJetpacks = [CCMenu menuWithItems:jetpacks, nil];
            menuJetpacks.position = CGPointMake(winSizeActual.width/2, pos * 3);
            [self addChild:menuJetpacks];
            
            menuApparel = [CCMenu menuWithItems:apparel, nil];
            menuApparel.position = CGPointMake(winSizeActual.width/2, pos * 2);
            [self addChild:menuApparel];
            
            menuMoreCoins = [CCMenu menuWithItems:moreCoins, nil];
            menuMoreCoins.position = CGPointMake(winSizeActual.width/2, pos * 1);
            [self addChild:menuMoreCoins];
        }
        
        
        excPos = CGPointMake(menuMoreCoins.position.x + moreCoins.contentSize.width/2, menuMoreCoins.position.y + moreCoins.contentSize.height/2);
        [self schedule:@selector(updateExclamation:)];
        
        [self reloads];
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

-(void) adFree:(id)sender{
    CCMenuItem* send = (CCMenuItem*)sender;
    if (!send.isEnabled) {
        return;
    }
    
    SKProduct *product = _products[3];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
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


-(void) reloads {
    _products = nil;
    [[JetpackIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            //[self updatePrices];
            adFree.isEnabled = YES;
        }
//        else {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect to App Store" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//        }
    }];
}

-(void) setAdFreeButtonEnabled:(BOOL) enabled {
    adFree.isEnabled = enabled;
}















-(void) dealloc{
}
@end
