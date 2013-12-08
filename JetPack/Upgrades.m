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
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        //more coins header
        CCSprite* upgradesHeader = [CCSprite spriteWithFile:@"upgrade-header.png"];
        upgradesHeader.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - upgradesHeader.contentSize.height/2);
        [self addChild:upgradesHeader z:-10];
        
        //back button
        CCMenuItem* back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        CCMenu* backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        [self addChild:backMenu];
        
        //number of coins
        CCSprite* coinIcon = [CCSprite spriteWithFile:@"store-coin.png"];
        coinIcon.position = CGPointMake(winSizeActual.width - backMenu.position.x + back.contentSize.width/2 - coinIcon.contentSize.width/2, backMenu.position.y);
        [self addChild:coinIcon];
        NSNumber* numCoins = [NSNumber numberWithInt: [GlobalDataManager totalCoinsWithDict]];
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
        
        CCMenuItem* fuelUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-Back.png" disabledImage:@"back-button.png" target:self selector:@selector(fuelUpgrade:)];
        CCMenu* fuelMenu = [CCMenu menuWithItems:fuelUpgrade, nil];
        fuelMenu.position = CGPointMake(winSizeActual.width - fuelIcon.position.x, fuelIcon.position.y);
        [self addChild:fuelMenu];
        
        int maxFuel = [GlobalDataManager maxFuelWithDict];
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
        
        CCLabelTTF* descFuel = [CCLabelTTF labelWithString:@"Increase fuel tank capacity" fontName:@"Orbitron-Light" fontSize:14];
        descFuel.anchorPoint = CGPointMake(0, 0.5);
        descFuel.position = CGPointMake(fuelMeter.position.x - descFuel.contentSize.width/2, fuelMeter.position.y - fuelMeter.contentSize.height*7/10 - descFuel.contentSize.height/2);
        descFuel.color = ccWHITE;
        [self addChild:descFuel z:1];
        
        CCRenderTexture* descFuelStroke = [self createStroke:descFuel size:0.5 color:ccBLACK];
        descFuelStroke.position = CGPointMake(descFuel.position.x + descFuelStroke.contentSize.width/2, descFuel.position.y);
        [self addChild:descFuelStroke z:0];
        
        
        //boost upgrade
        CCSprite* boostIcon = [CCSprite spriteWithFile:@"Boost.png"];
        boostIcon.position = CGPointMake(fuelIcon.position.x, 3*pos);
        [self addChild:boostIcon];
        
        CCMenuItem* boostUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-Back.png" disabledImage:@"back-button.png" target:self selector:@selector(boostUpgrade:)];
        CCMenu* boostMenu = [CCMenu menuWithItems:boostUpgrade, nil];
        boostMenu.position = CGPointMake(winSizeActual.width - boostIcon.position.x, boostIcon.position.y);
        [self addChild:boostMenu];
        
        int numSecondsBoost = [GlobalDataManager numSecondsBoostWithDict];
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
        
        CCLabelTTF* descBoost = [CCLabelTTF labelWithString:@"Increase duration of Boost" fontName:@"Orbitron-Light" fontSize:14];
        descBoost.anchorPoint = CGPointMake(0, 0.5);
        descBoost.position = CGPointMake(boostMeter.position.x - descBoost.contentSize.width/2, boostMeter.position.y - boostMeter.contentSize.height*7/10 - descBoost.contentSize.height/2);
        descBoost.color = ccWHITE;
        [self addChild:descBoost z:1];
        
        CCRenderTexture* descBoostStroke = [self createStroke:descBoost size:0.5 color:ccBLACK];
        descBoostStroke.position = CGPointMake(descBoost.position.x + descBoostStroke.contentSize.width/2, descBoost.position.y);
        [self addChild:descBoostStroke z:0];
        
        
        //double points upgrade
        CCSprite* doublePointsIcon = [CCSprite spriteWithFile:@"DoublePoints.png"];
        doublePointsIcon.position = CGPointMake(fuelIcon.position.x, 2*pos);
        [self addChild:doublePointsIcon];
        
        CCMenuItem* doublePointsUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" disabledImage:@"back-button.png" target:self selector:@selector(doublePointsUpgrade:)];
        CCMenu* doublePointsMenu = [CCMenu menuWithItems:doublePointsUpgrade, nil];
        doublePointsMenu.position = CGPointMake(winSizeActual.width - doublePointsIcon.position.x, doublePointsIcon.position.y);
        [self addChild:doublePointsMenu];
        
        int numSecondsDoublePoints = [GlobalDataManager numSecondsDoublePointsWithDict];
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
        
        CCLabelTTF* descDoublePoints = [CCLabelTTF labelWithString:@"Increase duration of Double Points" fontName:@"Orbitron-Light" fontSize:14];
        descDoublePoints.anchorPoint = CGPointMake(0, 0.5);
        descDoublePoints.position = CGPointMake(doublePointsMeter.position.x - descDoublePoints.contentSize.width/2, doublePointsMeter.position.y - doublePointsMeter.contentSize.height*7/10 - descDoublePoints.contentSize.height/2);
        descDoublePoints.color = ccWHITE;
        [self addChild:descDoublePoints z:1];
        
        CCRenderTexture* descDoublePointsStroke = [self createStroke:descDoublePoints size:0.5 color:ccBLACK];
        descDoublePointsStroke.position = CGPointMake(descDoublePoints.position.x + descDoublePointsStroke.contentSize.width/2, descDoublePoints.position.y);
        [self addChild:descDoublePointsStroke z:0];

        
        //invy upgrade
        CCSprite* invyIcon = [CCSprite spriteWithFile:@"Invincibility.png"];
        invyIcon.position = CGPointMake(fuelIcon.position.x, pos);
        [self addChild:invyIcon];
        
        CCMenuItem* invyUpgrade = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-Back.png" disabledImage:@"back-button.png" target:self selector:@selector(invyUpgrade:)];
        CCMenu* invyMenu = [CCMenu menuWithItems:invyUpgrade, nil];
        invyMenu.position = CGPointMake(winSizeActual.width - invyIcon.position.x, invyIcon.position.y);
        [self addChild:invyMenu];
        
        int numSecondsInvy = [GlobalDataManager numSecondsInvyWithDict];
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
        
        CCLabelTTF* descInvy = [CCLabelTTF labelWithString:@"Increase duration of Invincibility" fontName:@"Orbitron-Light" fontSize:14];
        descInvy.anchorPoint = CGPointMake(0, 0.5);
        descInvy.position = CGPointMake(invyMeter.position.x - descInvy.contentSize.width/2, invyMeter.position.y - invyMeter.contentSize.height*7/10 - descInvy.contentSize.height/2);
        descInvy.color = ccWHITE;
        [self addChild:descInvy z:1];
        
        CCRenderTexture* descInvyStroke = [self createStroke:descInvy size:0.5 color:ccBLACK];
        descInvyStroke.position = CGPointMake(descInvy.position.x + descInvyStroke.contentSize.width/2, descInvy.position.y);
        [self addChild:descInvyStroke z:0];
        
        

    }
    return self;
}



-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}
-(void) fuelUpgrade:(id)sender {
    int current = [GlobalDataManager maxFuelWithDict];
    
    if (current == FUEL_STAGE_ONE) {
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_TWO];
    }
    else if (current == FUEL_STAGE_TWO) {
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_THREE];
    }
    else if (current == FUEL_STAGE_THREE) {
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_FOUR];
    }
    else {
        return;
    }
    
}
-(void) boostUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsBoostWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_TWO];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_THREE];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_FOUR];
    }
    else {
        return;
    }
}
-(void) doublePointsUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsDoublePointsWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_TWO];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_THREE];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_FOUR];
    }
    else {
        return;
    }
}
-(void) invyUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsInvyWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_TWO];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_THREE];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_THREE) {
            //todo: ask user if they'd like to buy more coins
        }
        
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_FOUR];
    }
    else {
        return;
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


@end
