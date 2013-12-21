//
//  Upgrades.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/21/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Upgrades.h"
#import "GlobalDataManager.h"
#import "MoreCoins.h"


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
        
        //upgrades header
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
        
        CCMenuItem* fuelUpgrade = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Empty-button.png" target:self selector:@selector(fuelUpgrade:)];
        fuelMenu = [CCMenu menuWithItems:fuelUpgrade, nil];
        //fuelMenu.position = CGPointMake(winSizeActual.width - fuelIcon.position.x, fuelIcon.position.y);
        fuelMenu.position = CGPointMake(winSizeActual.width - fuelUpgrade.contentSize.width * .56, fuelIcon.position.y);
        [self addChild:fuelMenu];
        
        int maxFuel = [GlobalDataManager maxFuelWithDict];
        if (maxFuel == FUEL_STAGE_ONE) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",FUEL_COST_ONE];
            fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            fuelMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
            
            fuelMenuLabel.position = CGPointMake(fuelMenu.position.x - 6, fuelMenu.position.y - POS_ADJUSTMENT);
            fuelMenuCoin.position = CGPointMake(fuelMenuLabel.position.x + fuelMenuLabel.contentSize.width/2, fuelMenuLabel.position.y + 2);
            fuelMenuLabelStroke.position = fuelMenuLabel.position;
            
            [self addChild:fuelMenuLabel z:2];
            [self addChild:fuelMenuCoin z:2];
            [self addChild:fuelMenuLabelStroke z:1];
        }
        else if (maxFuel == FUEL_STAGE_TWO) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",FUEL_COST_TWO];
            fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            fuelMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
            
            fuelMenuLabel.position = CGPointMake(fuelMenu.position.x - 6, fuelMenu.position.y - POS_ADJUSTMENT);
            fuelMenuCoin.position = CGPointMake(fuelMenuLabel.position.x + fuelMenuLabel.contentSize.width/2, fuelMenuLabel.position.y + 2);
            fuelMenuLabelStroke.position = fuelMenuLabel.position;
            
            [self addChild:fuelMenuLabel z:2];
            [self addChild:fuelMenuCoin z:2];
            [self addChild:fuelMenuLabelStroke z:1];
        }
        else if (maxFuel == FUEL_STAGE_THREE) {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",FUEL_COST_THREE];
            fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            fuelMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
            
            fuelMenuLabel.position = CGPointMake(fuelMenu.position.x - 6, fuelMenu.position.y - POS_ADJUSTMENT);
            fuelMenuCoin.position = CGPointMake(fuelMenuLabel.position.x + fuelMenuLabel.contentSize.width/2, fuelMenuLabel.position.y + 2);
            fuelMenuLabelStroke.position = fuelMenuLabel.position;
            
            [self addChild:fuelMenuLabel z:2];
            [self addChild:fuelMenuCoin z:2];
            [self addChild:fuelMenuLabelStroke z:1];
        }
        else {
            fuelMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
            
            NSString* text = [NSString stringWithFormat:@"MAXED"];
            fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
            fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
            
            fuelMenuLabel.position = CGPointMake(fuelMenu.position.x, fuelMenu.position.y - POS_ADJUSTMENT);
            fuelMenuLabelStroke.position = fuelMenuLabel.position;
            
            [self addChild:fuelMenuLabel z:2];
            [self addChild:fuelMenuLabelStroke z:1];
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
        
        CCMenuItem* boostUpgrade = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Empty-button.png" target:self selector:@selector(boostUpgrade:)];
        boostMenu = [CCMenu menuWithItems:boostUpgrade, nil];
        boostMenu.position = CGPointMake(winSizeActual.width - boostUpgrade.contentSize.width * .56, boostIcon.position.y);
        [self addChild:boostMenu];
        
        int numSecondsBoost = [GlobalDataManager numSecondsBoostWithDict];
        if (numSecondsBoost == POWER_UP_STAGE_ONE) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_ONE];
            boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            boostMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
            
            boostMenuLabel.position = CGPointMake(boostMenu.position.x - 6, boostMenu.position.y - POS_ADJUSTMENT);
            boostMenuCoin.position = CGPointMake(boostMenuLabel.position.x + boostMenuLabel.contentSize.width/2, boostMenuLabel.position.y + 2);
            boostMenuLabelStroke.position = boostMenuLabel.position;
            
            [self addChild:boostMenuLabel z:2];
            [self addChild:boostMenuCoin z:2];
            [self addChild:boostMenuLabelStroke z:1];
        }
        else if (numSecondsBoost == POWER_UP_STAGE_TWO) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
            boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            boostMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
            
            boostMenuLabel.position = CGPointMake(boostMenu.position.x - 6, boostMenu.position.y - POS_ADJUSTMENT);
            boostMenuCoin.position = CGPointMake(boostMenuLabel.position.x + boostMenuLabel.contentSize.width/2, boostMenuLabel.position.y + 2);
            boostMenuLabelStroke.position = boostMenuLabel.position;
            
            [self addChild:boostMenuLabel z:2];
            [self addChild:boostMenuCoin z:2];
            [self addChild:boostMenuLabelStroke z:1];
        }
        else if (numSecondsBoost == POWER_UP_STAGE_THREE) {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
            boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            boostMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
            
            boostMenuLabel.position = CGPointMake(boostMenu.position.x - 6, boostMenu.position.y - POS_ADJUSTMENT);
            boostMenuCoin.position = CGPointMake(boostMenuLabel.position.x + boostMenuLabel.contentSize.width/2, boostMenuLabel.position.y + 2);
            boostMenuLabelStroke.position = boostMenuLabel.position;
            
            [self addChild:boostMenuLabel z:2];
            [self addChild:boostMenuCoin z:2];
            [self addChild:boostMenuLabelStroke z:1];
        }
        else {
            boostMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
            
            NSString* text = [NSString stringWithFormat:@"MAXED"];
            boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
            boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
            
            boostMenuLabel.position = CGPointMake(boostMenu.position.x, boostMenu.position.y - POS_ADJUSTMENT);
            boostMenuLabelStroke.position = boostMenuLabel.position;
            
            [self addChild:boostMenuLabel z:2];
            [self addChild:boostMenuLabelStroke z:1];
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
        
        CCMenuItem* doublePointsUpgrade = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Empty-button.png" target:self selector:@selector(doublePointsUpgrade:)];
        doublePointsMenu = [CCMenu menuWithItems:doublePointsUpgrade, nil];
        doublePointsMenu.position = CGPointMake(winSizeActual.width - doublePointsUpgrade.contentSize.width * .56, doublePointsIcon.position.y);
        [self addChild:doublePointsMenu];
        
        int numSecondsDoublePoints = [GlobalDataManager numSecondsDoublePointsWithDict];
        if (numSecondsDoublePoints == POWER_UP_STAGE_ONE) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_ONE];
            doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            doublePointsMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
            
            doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x - 6, doublePointsMenu.position.y - POS_ADJUSTMENT);
            doublePointsMenuCoin.position = CGPointMake(doublePointsMenuLabel.position.x + doublePointsMenuLabel.contentSize.width/2, doublePointsMenuLabel.position.y + 2);
            doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
            
            [self addChild:doublePointsMenuLabel z:2];
            [self addChild:doublePointsMenuCoin z:2];
            [self addChild:doublePointsMenuLabelStroke z:1];
        }
        else if (numSecondsDoublePoints == POWER_UP_STAGE_TWO) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
            doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            doublePointsMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
            
            doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x - 6, doublePointsMenu.position.y - POS_ADJUSTMENT);
            doublePointsMenuCoin.position = CGPointMake(doublePointsMenuLabel.position.x + doublePointsMenuLabel.contentSize.width/2, doublePointsMenuLabel.position.y + 2);
            doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
            
            [self addChild:doublePointsMenuLabel z:2];
            [self addChild:doublePointsMenuCoin z:2];
            [self addChild:doublePointsMenuLabelStroke z:1];
        }
        else if (numSecondsDoublePoints == POWER_UP_STAGE_THREE) {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
            doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            doublePointsMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
            
            doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x - 6, doublePointsMenu.position.y - POS_ADJUSTMENT);
            doublePointsMenuCoin.position = CGPointMake(doublePointsMenuLabel.position.x + doublePointsMenuLabel.contentSize.width/2, doublePointsMenuLabel.position.y + 2);
            doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
            
            [self addChild:doublePointsMenuLabel z:2];
            [self addChild:doublePointsMenuCoin z:2];
            [self addChild:doublePointsMenuLabelStroke z:1];
        }
        else {
            doublePointsMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
            
            NSString* text = [NSString stringWithFormat:@"MAXED"];
            doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
            doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
            
            doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x, doublePointsMenu.position.y - POS_ADJUSTMENT);
            doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
            
            [self addChild:doublePointsMenuLabel z:2];
            [self addChild:doublePointsMenuLabelStroke z:1];
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
        
        CCMenuItem* invyUpgrade = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Empty-button.png" target:self selector:@selector(invyUpgrade:)];
        invyMenu = [CCMenu menuWithItems:invyUpgrade, nil];
        invyMenu.position = CGPointMake(winSizeActual.width - invyUpgrade.contentSize.width * .55, invyIcon.position.y);
        [self addChild:invyMenu];
        
        int numSecondsInvy = [GlobalDataManager numSecondsInvyWithDict];
        if (numSecondsInvy == POWER_UP_STAGE_ONE) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-1.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_ONE];
            invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            invyMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
            
            invyMenuLabel.position = CGPointMake(invyMenu.position.x - 6, invyMenu.position.y - POS_ADJUSTMENT);
            invyMenuCoin.position = CGPointMake(invyMenuLabel.position.x + invyMenuLabel.contentSize.width/2, invyMenuLabel.position.y + 2);
            invyMenuLabelStroke.position = invyMenuLabel.position;
            
            [self addChild:invyMenuLabel z:2];
            [self addChild:invyMenuCoin z:2];
            [self addChild:invyMenuLabelStroke z:1];
        }
        else if (numSecondsInvy == POWER_UP_STAGE_TWO) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-2.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
            invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            invyMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
            
            invyMenuLabel.position = CGPointMake(invyMenu.position.x - 6, invyMenu.position.y - POS_ADJUSTMENT);
            invyMenuCoin.position = CGPointMake(invyMenuLabel.position.x + invyMenuLabel.contentSize.width/2, invyMenuLabel.position.y + 2);
            invyMenuLabelStroke.position = invyMenuLabel.position;
            
            [self addChild:invyMenuLabel z:2];
            [self addChild:invyMenuCoin z:2];
            [self addChild:invyMenuLabelStroke z:1];
        }
        else if (numSecondsInvy == POWER_UP_STAGE_THREE) {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-3.png"];
            
            NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
            invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            invyMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
            invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
            
            invyMenuLabel.position = CGPointMake(invyMenu.position.x - 6, invyMenu.position.y - POS_ADJUSTMENT);
            invyMenuCoin.position = CGPointMake(invyMenuLabel.position.x + invyMenuLabel.contentSize.width/2, invyMenuLabel.position.y + 2);
            invyMenuLabelStroke.position = invyMenuLabel.position;
            
            [self addChild:invyMenuLabel z:2];
            [self addChild:invyMenuCoin z:2];
            [self addChild:invyMenuLabelStroke z:1];
        }
        else {
            invyMeter = [CCSprite spriteWithFile:@"Progress-Bar-4.png"];
            
            NSString* text = [NSString stringWithFormat:@"MAXED"];
            invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
            invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
            
            invyMenuLabel.position = CGPointMake(invyMenu.position.x, invyMenu.position.y - POS_ADJUSTMENT);
            invyMenuLabelStroke.position = invyMenuLabel.position;
            
            [self addChild:invyMenuLabel z:2];
            [self addChild:invyMenuLabelStroke z:1];
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
        if ([GlobalDataManager totalCoinsWithDict] < FUEL_COST_ONE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - FUEL_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_TWO];
        
        
        [self removeChild:fuelMenuLabel];
        [self removeChild:fuelMenuLabelStroke];
        [self removeChild:fuelMenuCoin];
        fuelMenuLabel = nil;
        fuelMenuLabelStroke = nil;
        fuelMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",FUEL_COST_TWO];
        fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        fuelMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
        
        fuelMenuLabel.position = CGPointMake(fuelMenu.position.x - fuelMenuCoin.contentSize.width/2, fuelMenu.position.y - POS_ADJUSTMENT);
        fuelMenuCoin.position = CGPointMake(fuelMenuLabel.position.x + fuelMenuLabel.contentSize.width/2, fuelMenuLabel.position.y + 2);
        fuelMenuLabelStroke.position = fuelMenuLabel.position;
        
        [self addChild:fuelMenuLabel z:2];
        [self addChild:fuelMenuCoin z:2];
        [self addChild:fuelMenuLabelStroke z:1];
    }
    else if (current == FUEL_STAGE_TWO) {
        if ([GlobalDataManager totalCoinsWithDict] < FUEL_COST_TWO) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - FUEL_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_THREE];
       
        
        [self removeChild:fuelMenuLabel];
        [self removeChild:fuelMenuLabelStroke];
        [self removeChild:fuelMenuCoin];
        fuelMenuLabel = nil;
        fuelMenuLabelStroke = nil;
        fuelMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",FUEL_COST_THREE];
        fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        fuelMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
        
        fuelMenuLabel.position = CGPointMake(fuelMenu.position.x - fuelMenuCoin.contentSize.width/2, fuelMenu.position.y - POS_ADJUSTMENT);
        fuelMenuCoin.position = CGPointMake(fuelMenuLabel.position.x + fuelMenuLabel.contentSize.width/2, fuelMenuLabel.position.y + 2);
        fuelMenuLabelStroke.position = fuelMenuLabel.position;
        
        [self addChild:fuelMenuLabel z:2];
        [self addChild:fuelMenuCoin z:2];
        [self addChild:fuelMenuLabelStroke z:1];
    }
    else if (current == FUEL_STAGE_THREE) {
        if ([GlobalDataManager totalCoinsWithDict] < FUEL_COST_THREE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        fuelMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - FUEL_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setMaxFuelWithDict:FUEL_STAGE_FOUR];

        [self removeChild:fuelMenuLabel];
        [self removeChild:fuelMenuCoin];
        [self removeChild:fuelMenuLabelStroke];
        
        fuelMenuLabel = nil;
        fuelMenuLabelStroke = nil;
        
        
        NSString* text = [NSString stringWithFormat:@"MAXED"];
        fuelMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
        fuelMenuLabelStroke = [self createStroke:fuelMenuLabel size:0.5 color:ccBLACK];
        
        fuelMenuLabel.position = CGPointMake(fuelMenu.position.x, fuelMenu.position.y - POS_ADJUSTMENT);
        fuelMenuLabelStroke.position = fuelMenuLabel.position;
        
        [self addChild:fuelMenuLabel z:2];
        [self addChild:fuelMenuLabelStroke z:1];
    }
}
-(void) boostUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsBoostWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_ONE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_TWO];
        
        
        [self removeChild:boostMenuLabel];
        [self removeChild:boostMenuLabelStroke];
        [self removeChild:boostMenuCoin];
        boostMenuLabel = nil;
        boostMenuLabelStroke = nil;
        boostMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
        boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        boostMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
        
        boostMenuLabel.position = CGPointMake(boostMenu.position.x - boostMenuCoin.contentSize.width/2, boostMenu.position.y - POS_ADJUSTMENT);
        boostMenuCoin.position = CGPointMake(boostMenuLabel.position.x + boostMenuLabel.contentSize.width/2, boostMenuLabel.position.y + 2);
        boostMenuLabelStroke.position = boostMenuLabel.position;
        
        [self addChild:boostMenuLabel z:2];
        [self addChild:boostMenuCoin z:2];
        [self addChild:boostMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_TWO) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_THREE];
        
        
        [self removeChild:boostMenuLabel];
        [self removeChild:boostMenuLabelStroke];
        [self removeChild:boostMenuCoin];
        boostMenuLabel = nil;
        boostMenuLabelStroke = nil;
        boostMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
        boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        boostMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
        
        boostMenuLabel.position = CGPointMake(boostMenu.position.x - boostMenuCoin.contentSize.width/2, boostMenu.position.y - POS_ADJUSTMENT);
        boostMenuCoin.position = CGPointMake(boostMenuLabel.position.x + boostMenuLabel.contentSize.width/2, boostMenuLabel.position.y + 2);
        boostMenuLabelStroke.position = boostMenuLabel.position;
        
        [self addChild:boostMenuLabel z:2];
        [self addChild:boostMenuCoin z:2];
        [self addChild:boostMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_THREE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        boostMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsBoostWithDict:POWER_UP_STAGE_FOUR];

        [self removeChild:boostMenuLabel];
        [self removeChild:boostMenuCoin];
        [self removeChild:boostMenuLabelStroke];
        
        
        boostMenuLabel = nil;
        boostMenuLabelStroke = nil;

        NSString* text = [NSString stringWithFormat:@"MAXED"];
        boostMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
        boostMenuLabelStroke = [self createStroke:boostMenuLabel size:0.5 color:ccBLACK];
        
        boostMenuLabel.position = CGPointMake(boostMenu.position.x, boostMenu.position.y - POS_ADJUSTMENT);
        boostMenuLabelStroke.position = boostMenuLabel.position;
        
        [self addChild:boostMenuLabel z:2];
        [self addChild:boostMenuLabelStroke z:1];
    }
    else {
        return;
    }
}
-(void) doublePointsUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsDoublePointsWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_ONE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_TWO];
        
        
        [self removeChild:doublePointsMenuLabel];
        [self removeChild:doublePointsMenuLabelStroke];
        [self removeChild:doublePointsMenuCoin];
        doublePointsMenuLabel = nil;
        doublePointsMenuLabelStroke = nil;
        doublePointsMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
        doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        doublePointsMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
        
        doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x - doublePointsMenuCoin.contentSize.width/2, doublePointsMenu.position.y - POS_ADJUSTMENT);
        doublePointsMenuCoin.position = CGPointMake(doublePointsMenuLabel.position.x + doublePointsMenuLabel.contentSize.width/2, doublePointsMenuLabel.position.y + 2);
        doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
        
        [self addChild:doublePointsMenuLabel z:2];
        [self addChild:doublePointsMenuCoin z:2];
        [self addChild:doublePointsMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_TWO) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i   ", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_THREE];
        
        
        [self removeChild:doublePointsMenuLabel];
        [self removeChild:doublePointsMenuLabelStroke];
        [self removeChild:doublePointsMenuCoin];
        doublePointsMenuLabel = nil;
        doublePointsMenuLabelStroke = nil;
        doublePointsMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
        doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        doublePointsMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
        
        doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x - doublePointsMenuCoin.contentSize.width/2, doublePointsMenu.position.y - POS_ADJUSTMENT);
        doublePointsMenuCoin.position = CGPointMake(doublePointsMenuLabel.position.x + doublePointsMenuLabel.contentSize.width/2, doublePointsMenuLabel.position.y + 2);
        doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
        
        [self addChild:doublePointsMenuLabel z:2];
        [self addChild:doublePointsMenuCoin z:2];
        [self addChild:doublePointsMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_THREE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        doublePointsMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsDoublePointsWithDict:POWER_UP_STAGE_FOUR];
        
        [self removeChild:doublePointsMenuLabel];
        [self removeChild:doublePointsMenuLabelStroke];
        [self removeChild:doublePointsMenuCoin];
        
        
        doublePointsMenuLabel = nil;
        doublePointsMenuLabelStroke = nil;
        
        NSString* text = [NSString stringWithFormat:@"MAXED"];
        doublePointsMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
        doublePointsMenuLabelStroke = [self createStroke:doublePointsMenuLabel size:0.5 color:ccBLACK];
        
        doublePointsMenuLabel.position = CGPointMake(doublePointsMenu.position.x, doublePointsMenu.position.y - POS_ADJUSTMENT);
        doublePointsMenuLabelStroke.position = doublePointsMenuLabel.position;
        
        [self addChild:doublePointsMenuLabel z:2];
        [self addChild:doublePointsMenuLabelStroke z:1];
    }
    else {
        return;
    }
}
-(void) invyUpgrade:(id)sender {
    int current = [GlobalDataManager numSecondsInvyWithDict];
    
    if (current == POWER_UP_STAGE_ONE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_ONE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-2.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_ONE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_TWO];
        
        
        [self removeChild:invyMenuLabel];
        [self removeChild:invyMenuLabelStroke];
        [self removeChild:invyMenuCoin];
        invyMenuLabel = nil;
        invyMenuLabelStroke = nil;
        invyMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_TWO];
        invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        invyMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
        
        invyMenuLabel.position = CGPointMake(invyMenu.position.x - invyMenuCoin.contentSize.width/2, invyMenu.position.y - POS_ADJUSTMENT);
        invyMenuCoin.position = CGPointMake(invyMenuLabel.position.x + invyMenuLabel.contentSize.width/2, invyMenuLabel.position.y + 2);
        invyMenuLabelStroke.position = invyMenuLabel.position;
        
        [self addChild:invyMenuLabel z:2];
        [self addChild:invyMenuCoin z:2];
        [self addChild:invyMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_TWO) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_TWO) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-3.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_TWO];
        
        NSString* c = [NSString stringWithFormat:@"%i   ", [GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_THREE];
        
        
        [self removeChild:invyMenuLabel];
        [self removeChild:invyMenuLabelStroke];
        [self removeChild:invyMenuCoin];
        invyMenuLabel = nil;
        invyMenuLabelStroke = nil;
        invyMenuCoin = nil;
        
        NSString* text = [NSString stringWithFormat:@"%i   ",POWER_UP_COST_THREE];
        invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
        invyMenuCoin = [CCSprite spriteWithFile:@"store-coin.png"];
        invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
        
        invyMenuLabel.position = CGPointMake(invyMenu.position.x - invyMenuCoin.contentSize.width/2, invyMenu.position.y - POS_ADJUSTMENT);
        invyMenuCoin.position = CGPointMake(invyMenuLabel.position.x + invyMenuLabel.contentSize.width/2, invyMenuLabel.position.y + 2);
        invyMenuLabelStroke.position = invyMenuLabel.position;
        
        [self addChild:invyMenuLabel z:2];
        [self addChild:invyMenuCoin z:2];
        [self addChild:invyMenuLabelStroke z:1];
    }
    else if (current == POWER_UP_STAGE_THREE) {
        if ([GlobalDataManager totalCoinsWithDict] < POWER_UP_COST_THREE) {
            [self buyMoreCoinsPopUp];
            return;
        }
        
        invyMeter.texture = [[CCSprite spriteWithFile:@"Progress-Bar-4.png"] texture];
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - POWER_UP_COST_THREE];
        
        NSString* c = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
        coins.string = c;
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:coins size:0.5 color:ccBLACK];
        stroke.position = CGPointMake(coins.position.x - stroke.contentSize.width/2, coins.position.y);
        [self addChild:stroke z:0];
        
        [GlobalDataManager setNumSecondsInvyWithDict:POWER_UP_STAGE_FOUR];
        
        [self removeChild:invyMenuLabel];
        [self removeChild:invyMenuLabelStroke];
        [self removeChild:invyMenuCoin];
        
        invyMenuLabel = nil;
        invyMenuLabelStroke = nil;
        
        NSString* text = [NSString stringWithFormat:@"MAXED"];
        invyMenuLabel = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:FONT_SIZE_SMALLER];
        invyMenuLabelStroke = [self createStroke:invyMenuLabel size:0.5 color:ccBLACK];
        
        invyMenuLabel.position = CGPointMake(invyMenu.position.x, invyMenu.position.y - POS_ADJUSTMENT);
        invyMenuLabelStroke.position = invyMenuLabel.position;
        
        [self addChild:invyMenuLabel z:2];
        [self addChild:invyMenuLabelStroke z:1];
    }
    else {
        return;
    }
}

-(void) buyMoreCoinsPopUp {
    textBox = [CCSprite spriteWithFile:@"Text-box.png"];
    textBox.position = CGPointMake(winSizeActual.width/2, winSizeActual.height/2);
    [self addChild:textBox z:5];
    
    NSString* text = [NSString stringWithFormat:@"%i   ",[GlobalDataManager totalCoinsWithDict]];
    buyMoreCoins1 = [CCLabelTTF labelWithString:@"YOU HAVE:  " fontName:@"Orbitron-Medium" fontSize:16];
    buyMoreCoins2 = [CCLabelTTF labelWithString:text fontName:@"Orbitron-Light" fontSize:25];
    buyMoreCoins3 = [CCLabelTTF labelWithString:@"BUY MORE COINS?" fontName:@"Orbitron-Medium" fontSize:20];
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


@end
