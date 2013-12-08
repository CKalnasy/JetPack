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
#import "InAppPurchaseManager.h"



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
        CCSprite* moreCoinsHeader = [CCSprite spriteWithFile:@"upgrade-header.png"];
        moreCoinsHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - moreCoinsHeader.contentSize.height/2);
        [self addChild:moreCoinsHeader z:-10];
        
        //back button
        CCMenuItem* back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
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
        
//        moreCoins1Menu = [CCMenu menuWithItems:moreCoins1, nil];
//        moreCoins2Menu = [CCMenu menuWithItems:moreCoins2, nil];
//        moreCoins3Menu = [CCMenu menuWithItems:moreCoins3, nil];
        
        
        
//        moreCoins1Menu.enabled = NO;
//        moreCoins2Menu.enabled = NO;
//        moreCoins3Menu.enabled = NO;
        
        
        
//        SKProduct* product1 = (SKProduct*)_products[0];
//        NSString* price1 = [_priceFormatter stringFromNumber:product1.price];
//        
//        if ([[JetpackIAPHelper sharedInstance] productPurchased:product1.productIdentifier]) {
//            //todo: already bought
//        }
//        else {
//            CCLabelTTF* moreCoins1Label = [CCLabelTTF labelWithString:price1 fontName:@"arial" fontSize:18];
//            moreCoins1 = [CCMenuItemLabel itemWithLabel:moreCoins1Label target:self selector:@selector(buyMoreCoins1:)];
//        }
//        
//        SKProduct* product2 = (SKProduct*)_products[1];
//        NSString* price2 = [_priceFormatter stringFromNumber:product2.price];
//        
//        if ([[JetpackIAPHelper sharedInstance] productPurchased:product2.productIdentifier]) {
//            //todo: already bought
//        }
//        else {
//            CCLabelTTF* moreCoins2Label = [CCLabelTTF labelWithString:price2 fontName:@"arial" fontSize:18];
//            moreCoins2 = [CCMenuItemLabel itemWithLabel:moreCoins2Label target:self selector:@selector(buyMoreCoins2:)];
//        }
//        
//        SKProduct* product3 = (SKProduct*)_products[2];
//        NSString* price3 = [_priceFormatter stringFromNumber:product3.price];
//        
//        if ([[JetpackIAPHelper sharedInstance] productPurchased:product3.productIdentifier]) {
//            //todo: already bought
//        }
//        else {
//            CCLabelTTF* moreCoins3Label = [CCLabelTTF labelWithString:price3 fontName:@"arial" fontSize:18];
//            moreCoins3 = [CCMenuItemLabel itemWithLabel:moreCoins3Label target:self selector:@selector(buyMoreCoins3:)];
//        }
//        
//        
//        
//        
//        
//        moreCoins1Menu = [CCMenu menuWithItems:moreCoins1, nil];
//        moreCoins2Menu = [CCMenu menuWithItems:moreCoins2, nil];
//        moreCoins3Menu = [CCMenu menuWithItems:moreCoins3, nil];
//        
//        moreCoins1Menu.position = CGPointMake(winSizeActual.width - moreCoins1.contentSize.width/2 - moreCoins1.contentSize.width/5, (backMenu.position.y) * (4.0/5));
//        moreCoins2Menu.position = CGPointMake(winSizeActual.width - moreCoins2.contentSize.width/2 - moreCoins2.contentSize.width/5, (backMenu.position.y) * (3.0/5));
//        moreCoins3Menu.position = CGPointMake(winSizeActual.width - moreCoins3.contentSize.width/2 - moreCoins3.contentSize.width/5, (backMenu.position.y) * (2.0/5));
//        
//        [self addChild:moreCoins1Menu];
//        [self addChild:moreCoins2Menu];
//        [self addChild:moreCoins3Menu];
        
        
        //free coins button
        CCMenuItem* freeCoins = [CCMenuItemImage itemWithNormalImage:@"Store.png" selectedImage:@"Store.png" target:self selector:@selector(freeCoins:)];
        CCMenu* freeCoinsMenu = [CCMenu menuWithItems:freeCoins, nil];
        freeCoinsMenu.position = CGPointMake(winSizeActual.width/2, (backMenu.position.y) * (1.0/5));
        [self addChild:freeCoinsMenu];
        
        
        //in app purchase manager init
//        [[InAppPurchaseManager sharedInAppManager] loadStore];
        

        excPos = CGPointMake(freeCoinsMenu.position.x + freeCoins.contentSize.width/2, freeCoinsMenu.position.y + freeCoins.contentSize.height/2);
        [self schedule:@selector(updateExclamation:)];
    }
    return self;
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
    if (!moreCoins1Menu.enabled) {
        return;
    }
    
    SKProduct *product = _products[0];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
}
-(void) buyMoreCoins2:(id)sender {
    if (!moreCoins2Menu.enabled) {
        return;
    }
    
    [[InAppPurchaseManager sharedInAppManager] purchaseMoreCoinsTwo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreCoins2:) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    SKProduct *product = _products[1];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[JetpackIAPHelper sharedInstance] buyProduct:product];
    
    
}
-(void) buyMoreCoins3:(id)sender {
    if (!moreCoins3Menu.enabled) {
        return;
    }
    
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


-(void) purchase:(int)num forPrice:(NSDecimalNumber*) price {
    
    //todo: display buy button
}


+(void) increaseCoins:(int) num {
    
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
        }
    }];
}


- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}











@end
