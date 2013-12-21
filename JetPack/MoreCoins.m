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
#import <StoreKit/StoreKit.h>
#import "JetpackIAPHelper.h"



@interface MoreCoins () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@end


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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        [self reloads];
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        
        //more coins header
        CCSprite* moreCoinsHeader = [CCSprite spriteWithFile:@"More-coins-header.png"];
        moreCoinsHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - moreCoinsHeader.contentSize.height/2);
        [self addChild:moreCoinsHeader z:-10];
        
        //back button
        back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        backMenu = [CCMenu menuWithItems:back, nil];
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
//        moreCoins1 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins1:)];
//        moreCoins2 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins2:)];
//        moreCoins3 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins3:)];
        
//        moreCoins1Menu = [CCMenu menuWithItems:moreCoins1, nil];
//        moreCoins2Menu = [CCMenu menuWithItems:moreCoins2, nil];
//        moreCoins3Menu = [CCMenu menuWithItems:moreCoins3, nil];
        
        
        CCLabelTTF* moreCoins1Desc = [CCLabelTTF labelWithString:@"10,000 COINS" fontName:@"Orbitron-Medium" fontSize:22];
        CCRenderTexture* moreCoins1DescStroke = [self createStroke:moreCoins1Desc size:0.5 color:ccBLACK];
        
        moreCoins1Desc.position = CGPointMake(moreCoins1Desc.contentSize.width/2 + 10, (backMenu.position.y) * (4.0/5) - 3);
        moreCoins1DescStroke.position = moreCoins1Desc.position;
        
        [self addChild:moreCoins1Desc z:1];
        [self addChild:moreCoins1DescStroke];
        
        CCLabelTTF* moreCoins2Desc = [CCLabelTTF labelWithString:@"5000 COINS" fontName:@"Orbitron-Medium" fontSize:22];
        CCRenderTexture* moreCoins2DescStroke = [self createStroke:moreCoins2Desc size:0.5 color:ccBLACK];
        
        moreCoins2Desc.position = CGPointMake(moreCoins2Desc.contentSize.width/2 + 10, (backMenu.position.y) * (3.0/5) - 2.5);
        moreCoins2DescStroke.position = moreCoins2Desc.position;
        
        [self addChild:moreCoins2Desc z:1];
        [self addChild:moreCoins2DescStroke];
        
        CCLabelTTF* moreCoins3Desc = [CCLabelTTF labelWithString:@"1000 COINS" fontName:@"Orbitron-Medium" fontSize:22];
        CCRenderTexture* moreCoins3DescStroke = [self createStroke:moreCoins3Desc size:0.5 color:ccBLACK];
        
        moreCoins3Desc.position = CGPointMake(moreCoins3Desc.contentSize.width/2 + 10, (backMenu.position.y) * (2.0/5) - 2.5);
        moreCoins3DescStroke.position = moreCoins3Desc.position;
        
        [self addChild:moreCoins3Desc z:1];
        [self addChild:moreCoins3DescStroke];
        
        
        //free coins button
//        CCMenuItem* freeCoins = [CCMenuItemImage itemWithNormalImage:@"Store-button.png" selectedImage:@"Push-Store.png" target:self selector:@selector(freeCoins:)];
//        CCMenu* freeCoinsMenu = [CCMenu menuWithItems:freeCoins, nil];
//        freeCoinsMenu.position = CGPointMake(winSizeActual.width/2, (backMenu.position.y) * (1.0/5));
//        [self addChild:freeCoinsMenu];
        CCMenuItem* freeCoins = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(freeCoins:)];
        CCMenu* freeCoinsMenu = [CCMenu menuWithItems:freeCoins, nil];
        
        CCLabelTTF* freeCoinsLabel = [CCLabelTTF labelWithString:@"FREE" fontName:@"arial" fontSize:20];
        freeCoinsMenu.position = CGPointMake(winSizeActual.width - freeCoins.contentSize.width/2 - freeCoins.contentSize.width/5, (backMenu.position.y) * (1.0/5));
        freeCoinsLabel.position = freeCoinsMenu.position;
        CCRenderTexture* freeCoinsStroke = [self createStroke:freeCoinsLabel size:0.5 color:ccBLACK];
        freeCoinsStroke.position = freeCoinsLabel.position;
        [self addChild:freeCoinsStroke z:1];
        [self addChild:freeCoinsLabel z:2];
        [self addChild:freeCoinsMenu];
        
        
        NSString* text = [NSString stringWithFormat:@"%i COINS", NUMBER_OF_COINS_PER_VIEW];
        CCLabelTTF* freeCoinsDesc = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Medium" fontSize:22];
        CCRenderTexture* freeCoinsDescStroke = [self createStroke:freeCoinsDesc size:0.5 color:ccBLACK];
        
        freeCoinsDesc.position = CGPointMake(freeCoinsDesc.contentSize.width/2 + 10, (backMenu.position.y) * (1.0/5) - 2.5);
        freeCoinsDescStroke.position = freeCoinsDesc.position;
        
        [self addChild:freeCoinsDesc z:1];
        [self addChild:freeCoinsDescStroke];
        
        
        excPos = CGPointMake(freeCoinsMenu.position.x + freeCoins.contentSize.width/2, freeCoinsMenu.position.y + freeCoins.contentSize.height/2);
        [self schedule:@selector(updateExclamation:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    }
    return self;
}



-(void) updatePrices {
    SKProduct* product1 = (SKProduct*)_products[0];
    NSString* price1 = [_priceFormatter stringFromNumber:product1.price];
    
//    if ([[JetpackIAPHelper sharedInstance] productPurchased:product1.productIdentifier]) {
//        //todo: already bought
//    }
//    else {
//        CCLabelTTF* moreCoins1Label = [CCLabelTTF labelWithString:price1 fontName:@"arial" fontSize:18];
//        //moreCoins1 = [CCMenuItemLabel itemWithLabel:moreCoins1Label target:self selector:@selector(buyMoreCoins1:)];
//    }
    CCLabelTTF* moreCoins1Label = [CCLabelTTF labelWithString:price1 fontName:@"arial" fontSize:20];
    moreCoins1 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins1:)];
    
    
    
    SKProduct* product2 = (SKProduct*)_products[2];
    NSString* price2 = [_priceFormatter stringFromNumber:product2.price];

    CCLabelTTF* moreCoins2Label = [CCLabelTTF labelWithString:price2 fontName:@"arial" fontSize:20];
    moreCoins2 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins3:)];
    
    
    
    SKProduct* product3 = (SKProduct*)_products[1];
    NSString* price3 = [_priceFormatter stringFromNumber:product3.price];

    CCLabelTTF* moreCoins3Label = [CCLabelTTF labelWithString:price3 fontName:@"arial" fontSize:20];
    moreCoins3 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMoreCoins2:)];
    
    
    
    moreCoins1Menu = [CCMenu menuWithItems:moreCoins1, nil];
    moreCoins2Menu = [CCMenu menuWithItems:moreCoins2, nil];
    moreCoins3Menu = [CCMenu menuWithItems:moreCoins3, nil];
    
    moreCoins1Menu.position = CGPointMake(winSizeActual.width - moreCoins1.contentSize.width/2 - moreCoins1.contentSize.width/5, (backMenu.position.y) * (4.0/5));
    moreCoins2Menu.position = CGPointMake(winSizeActual.width - moreCoins2.contentSize.width/2 - moreCoins2.contentSize.width/5, (backMenu.position.y) * (3.0/5));
    moreCoins3Menu.position = CGPointMake(winSizeActual.width - moreCoins3.contentSize.width/2 - moreCoins3.contentSize.width/5, (backMenu.position.y) * (2.0/5));
    
    moreCoins1Label.position = moreCoins1Menu.position;
    moreCoins2Label.position = moreCoins2Menu.position;
    moreCoins3Label.position = moreCoins3Menu.position;
    
    CCRenderTexture* stroke1 = [self createStroke:moreCoins1Label size:0.5 color:ccBLACK];
    stroke1.position = moreCoins1Label.position;
    [self addChild:stroke1 z:1];
    
    CCRenderTexture* stroke2 = [self createStroke:moreCoins2Label size:0.5 color:ccBLACK];
    stroke2.position = moreCoins2Label.position;
    [self addChild:stroke2 z:1];
    
    CCRenderTexture* stroke3 = [self createStroke:moreCoins3Label size:0.5 color:ccBLACK];
    stroke3.position = moreCoins3Label.position;
    [self addChild:stroke3 z:1];
    
    [self addChild:moreCoins1Label z:2];
    [self addChild:moreCoins2Label z:2];
    [self addChild:moreCoins3Label z:2];
    
    [self addChild:moreCoins1Menu];
    [self addChild:moreCoins2Menu];
    [self addChild:moreCoins3Menu];
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


-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}



-(void) buyMoreCoins1:(id)sender {
    SKProduct *product = _products[0];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
}
-(void) buyMoreCoins2:(id)sender {
    SKProduct *product = _products[1];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
}
-(void) buyMoreCoins3:(id)sender {
    SKProduct *product = _products[2];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
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



-(void) adClosed {
    [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] + NUMBER_OF_COINS_PER_VIEW];
    [coins setString: [NSString stringWithFormat:@"%d",[GlobalDataManager totalCoinsWithDict]]];
    
    [self removeChild:stroke cleanup:YES];
    stroke = nil;
    stroke = [self createStroke:coins size:0.5 color:ccBLACK];
    stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
    [self addChild:stroke];
}


-(void) reloads {
    _products = nil;
    [[JetpackIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self updatePrices];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect to iTunes Store" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

-(void) updateCoins {
    NSString* text = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
    coins.string = text;
    
    [self removeChild:stroke];
    stroke = nil;
    
    stroke = [self createStroke:coins size:0.5 color:ccBLACK];
    stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
    [self addChild:stroke];
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {            
            
            *stop = YES;
        }
    }];
    
}











@end
