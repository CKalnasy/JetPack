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
#import "MoreCoins.h"


@implementation Apparel

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Apparel *layer = [Apparel node];
	[scene addChild: layer];
    [layer setTag:APPAREL_SCENE_TAG];
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


-(void) updateNumCoins {
    NSString* text = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
    coins.string = text;
    
    [self removeChild:stroke];
    stroke = nil;
    stroke = [self createStroke:coins size:0.5 color:ccBLACK];
    stroke.position = coins.position;
    [self addChild:stroke];
}


-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}





//pop up menu stuff
-(void) notEnoughCoins {    
    if (isMenuUp) {
        return;
    }
    isMenuUp = YES;
    textBox = [CCSprite spriteWithFile:@"Text-box.png"];
    textBox.position = CGPointMake(winSizeActual.width/2, winSizeActual.height/2);
    [self addChild:textBox z:6];
    
    NSString* text = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
    buyMoreCoins1 = [CCLabelTTF labelWithString:@"YOU HAVE:  " fontName:@"Orbitron-Medium" fontSize:16];
    buyMoreCoins2 = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:25];
    buyMoreCoins3 = [CCLabelTTF labelWithString:@"BUY MORE COINS?" fontName:@"Orbitron-Medium" fontSize:22];
    coin = [CCSprite spriteWithFile:@"store-coin.png"];
    float pos = textBox.contentSize.height/4;
    
    buyMoreCoins1.position = CGPointMake(textBox.position.x - buyMoreCoins2.contentSize.width/2 - coin.contentSize.width/2, textBox.position.y + textBox.contentSize.height/2 - pos);
    [self addChild:buyMoreCoins1 z:8];
    
    buyMoreCoins1Stroke = [self createStroke:buyMoreCoins1 size:0.5 color:ccBLACK];
    buyMoreCoins1Stroke.position = buyMoreCoins1.position;
    [self addChild:buyMoreCoins1Stroke z:7];
    
    buyMoreCoins2.position = CGPointMake(buyMoreCoins1.position.x + buyMoreCoins1.contentSize.width/2 + buyMoreCoins2.contentSize.width/2, buyMoreCoins1.position.y);
    [self addChild:buyMoreCoins2 z:8];
    
    buyMoreCoins2Stroke = [self createStroke:buyMoreCoins2 size:0.5 color:ccBLACK];
    buyMoreCoins2Stroke.position = buyMoreCoins2.position;
    [self addChild:buyMoreCoins2Stroke z:7];
    
    coin.position = CGPointMake(buyMoreCoins2.position.x + buyMoreCoins2.contentSize.width/2, buyMoreCoins2.position.y + 1.5);
    [self addChild:coin z:8];
    
    buyMoreCoins3.position = CGPointMake(textBox.position.x, textBox.position.y + textBox.contentSize.height/2 - 2 * pos);
    [self addChild:buyMoreCoins3 z:8];
    
    buyMoreCoins3Stroke = [self createStroke:buyMoreCoins3 size:0.5 color:ccBLACK];
    buyMoreCoins3Stroke.position = buyMoreCoins3.position;
    [self addChild:buyMoreCoins3Stroke z:7];
    
    CCMenuItem* yes = [CCMenuItemImage itemWithNormalImage:@"Yes-button.png" selectedImage:@"Push-Yes.png" target:self selector:@selector(getMoreCoins:)];
    CCMenuItem* no = [CCMenuItemImage itemWithNormalImage:@"No-button.png" selectedImage:@"Push-No.png" target:self selector:@selector(dontGetMoreCoins:)];
    buyMoreCoinsMenu = [CCMenu menuWithItems:no, yes, nil];
    [buyMoreCoinsMenu alignItemsHorizontallyWithPadding:(textBox.contentSize.width - 2 * yes.contentSize.width)/2];
    buyMoreCoinsMenu.position = CGPointMake(textBox.position.x, textBox.position.y + textBox.contentSize.height/2 - 3 * pos);
    [self addChild:buyMoreCoinsMenu z:8];
}


-(void) getMoreCoins:(id)sender {
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] pushScene:[MoreCoins scene]];
}
-(void) dontGetMoreCoins:(id)sender {
    [self removeChild:textBox];
    [self removeChild:buyMoreCoins1];
    [self removeChild:buyMoreCoins2];
    [self removeChild:buyMoreCoins3];
    [self removeChild:buyMoreCoins1Stroke];
    [self removeChild:buyMoreCoins2Stroke];
    [self removeChild:buyMoreCoins3Stroke];
    [self removeChild:buyMoreCoinsMenu];
    [self removeChild:coin];
    
    isMenuUp = NO;
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
