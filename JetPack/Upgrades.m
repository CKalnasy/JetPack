//
//  Upgrades.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/21/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Upgrades.h"
#import "GlobalDataManager.h"


@implementation Upgrades


+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Upgrades *layer = [Upgrades node];
	[scene addChild: layer];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        winSizeActual = [[CCDirector sharedDirector] winSize];
        winSize = CGSizeMake(320, 480);
        
        //data.plist init
        NSString* path = [[NSBundle mainBundle] bundlePath];
        NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
        NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        //more coins header
        CCSprite* upgradesHeader = [CCSprite spriteWithFile:@"upgrade-header.png"];
        upgradesHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - upgradesHeader.contentSize.height/2);
        [self addChild:upgradesHeader z:-10];
        
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
        
        
        int pos = (backMenu.position.y - back.contentSize.height/2) / 5;
        
        //fuel upgrade
        CCSprite* fuelIcon = [CCSprite spriteWithFile:@"Fuel-tank.png"];
        fuelIcon.position = CGPointMake(fuelIcon.contentSize.width/3 + fuelIcon.contentSize.width/2, 4*pos);
        [self addChild:fuelIcon];
        
        CCMenuItem* fuelUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(fuelUpgrade:)];
        CCMenu* fuelMenu = [CCMenu menuWithItems:fuelUpgrade, nil];
        fuelMenu.position = CGPointMake(winSizeActual.width - fuelIcon.position.x, fuelIcon.position.y);
        [self addChild:fuelMenu];
        
        int maxFuel = [[dataDict valueForKey:@"max fuel"]integerValue];
        if (maxFuel == FUEL_STAGE_ONE) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
        }
        else if (maxFuel == FUEL_STAGE_TWO) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
        }
        else if (maxFuel == FUEL_STAGE_THREE) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
        }
        else {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
        }
        fuelMeter.anchorPoint = CGPointMake(0.5, 1);
        fuelMeter.position = CGPointMake(winSizeActual.width/2 - 13, 4*pos - POS_OFFSET);
        [self addChild:fuelMeter];
        
        CCSprite* fuelLabel = [CCSprite spriteWithFile:@"Fuel Label.png"];
        fuelLabel.anchorPoint = CGPointMake(0.5, 0);
        fuelLabel.position = CGPointMake(fuelMeter.position.x, 4*pos + POS_OFFSET);
        [self addChild:fuelLabel];
        
        
        //boost upgrade
        CCSprite* boostIcon = [CCSprite spriteWithFile:@"Boost.png"];
        boostIcon.position = CGPointMake(fuelIcon.position.x, 3*pos);
        [self addChild:boostIcon];
        
        CCMenuItem* boostUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(boostUpgrade:)];
        CCMenu* boostMenu = [CCMenu menuWithItems:boostUpgrade, nil];
        boostMenu.position = CGPointMake(winSizeActual.width - boostIcon.position.x, boostIcon.position.y);
        [self addChild:boostMenu];
        
        int numSecondsBoost = [[dataDict valueForKey:@"max seconds boost"]integerValue];
        if (numSecondsBoost == POWER_UP_STAGE_ONE) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
        }
        else if (numSecondsBoost == POWER_UP_STAGE_TWO) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
        }
        else if (numSecondsBoost == POWER_UP_STAGE_THREE) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
        }
        else {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
        }
        boostMeter.anchorPoint = CGPointMake(0.5, 1);
        boostMeter.position = CGPointMake(winSizeActual.width/2 - 13, 3*pos - POS_OFFSET);
        [self addChild:boostMeter];
        
        CCSprite* boostLabel = [CCSprite spriteWithFile:@"Boost-Label.png"];
        boostLabel.anchorPoint = CGPointMake(0.5, 0);
        boostLabel.position = CGPointMake(boostMeter.position.x, 3*pos + POS_OFFSET);
        [self addChild:boostLabel];
        
        
        //double points upgrade
        CCSprite* doublePointsIcon = [CCSprite spriteWithFile:@"DoublePoints.png"];
        doublePointsIcon.position = CGPointMake(fuelIcon.position.x, 2*pos);
        [self addChild:doublePointsIcon];
        
        CCMenuItem* doublePointsUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(doublePointsUpgrade:)];
        CCMenu* doublePointsMenu = [CCMenu menuWithItems:doublePointsUpgrade, nil];
        doublePointsMenu.position = CGPointMake(winSizeActual.width - doublePointsIcon.position.x, doublePointsIcon.position.y);
        [self addChild:doublePointsMenu];
        
        int numSecondsDoublePoints = [[dataDict valueForKey:@"max seconds double points"]integerValue];
        if (numSecondsDoublePoints == POWER_UP_STAGE_ONE) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
        }
        else if (numSecondsDoublePoints == POWER_UP_STAGE_TWO) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
        }
        else if (numSecondsDoublePoints == POWER_UP_STAGE_THREE) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
        }
        else {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
        }
        doublePointsMeter.anchorPoint = CGPointMake(0.5, 1);
        doublePointsMeter.position = CGPointMake(winSizeActual.width/2 - 13, 2*pos - POS_OFFSET);
        [self addChild:doublePointsMeter];
        
        CCSprite* doublePointsLabel = [CCSprite spriteWithFile:@"Double-Points-Label.png"];
        doublePointsLabel.anchorPoint = CGPointMake(0.5, 0);
        doublePointsLabel.position = CGPointMake(doublePointsMeter.position.x, 2*pos + POS_OFFSET);
        [self addChild:doublePointsLabel];

        
        //invy upgrade
        CCSprite* invyIcon = [CCSprite spriteWithFile:@"Invincibility.png"];
        invyIcon.position = CGPointMake(fuelIcon.position.x, pos);
        [self addChild:invyIcon];
        
        CCMenuItem* invyUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(invyUpgrade:)];
        CCMenu* invyMenu = [CCMenu menuWithItems:invyUpgrade, nil];
        invyMenu.position = CGPointMake(winSizeActual.width - invyIcon.position.x, invyIcon.position.y);
        [self addChild:invyMenu];
        
        int numSecondsInvy = [[dataDict valueForKey:@"max seconds invy"]integerValue];
        if (numSecondsInvy == POWER_UP_STAGE_ONE) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
        }
        else if (numSecondsInvy == POWER_UP_STAGE_TWO) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
        }
        else if (numSecondsInvy == POWER_UP_STAGE_THREE) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
        }
        else {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
        }
        invyMeter.anchorPoint = CGPointMake(0.5, 1);
        invyMeter.position = CGPointMake(winSizeActual.width/2 - 13, pos - POS_OFFSET);
        [self addChild:invyMeter];
        
        CCSprite* invyLabel = [CCSprite spriteWithFile:@"Invincibility-Label.png"];
        invyLabel.anchorPoint = CGPointMake(0.5, 0);
        invyLabel.position = CGPointMake(invyMeter.position.x, pos + POS_OFFSET);
        [self addChild:invyLabel];

    }
    return self;
}



-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}
-(void) fuelUpgrade:(id)sender {
    
}
-(void) boostUpgrade:(id)sender {
    
}
-(void) doublePointsUpgrade:(id)sender {
    
}
-(void) invyUpgrade:(id)sender {
    
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
