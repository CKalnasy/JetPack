//
//  Clothes.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Clothes.h"
#import "GlobalDataManager.h"
#import "MoreCoins.h"
#import "Apparel.h"


@implementation Clothes

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Clothes *layer = [Clothes node];
	[scene addChild: layer z:CLOTHES_TAG];
	return scene;
}

-(id) init{
    if( (self=[super init])) {
        winSizeActual = [[CCDirector sharedDirector] winSize];
        winSize = CGSizeMake(320, 480);
                
        top = [Player player:@"Jeff-Black.png"];
        top.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height);
        [self addChild:top];
        
        CCMenuItem* buttonP0 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyBlack:)];
        menuP0 = [CCMenu menuWithItems:buttonP0, nil];
        menuP0.position = CGPointMake(winSizeActual.width - buttonP0.contentSize.width/2 - 5, top.position.y);
        [self addChild:menuP0];
        
        if (![GlobalDataManager isBlackBoughtWithDict]) {
            coin0 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label0 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label0.position = CGPointMake(menuP0.position.x - coin0.contentSize.width/2, menuP0.position.y - POS_ADJUSTMENT);
            [self addChild:label0 z:2];
            
            stroke0 = [self createStroke:label0 size:0.5 color:ccBLACK];
            stroke0.position = label0.position;
            [self addChild:stroke0 z:1];
            
            
            coin0.position = CGPointMake(label0.position.x + label0.contentSize.width/2, label0.position.y + 2);
            [self addChild:coin0 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Black"]) {
                label0 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label0 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label0.position = CGPointMake(menuP0.position.x, menuP0.position.y - POS_ADJUSTMENT);
            [self addChild:label0 z:2];
            
            stroke0 = [self createStroke:label0 size:0.5 color:ccBLACK];
            stroke0.position = label0.position;
            [self addChild:stroke0 z:1];
        }
    
        
        Player* p1 = [Player player:@"Jeff-Blue.png"];
        p1.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - top.contentSize.height*1.25);
        [self addChild:p1];
        
        CCMenuItem* buttonP1 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyBlue:)];
        menuP1 = [CCMenu menuWithItems:buttonP1, nil];
        menuP1.position = CGPointMake(winSizeActual.width - buttonP1.contentSize.width/2 - 5, p1.position.y);
        [self addChild:menuP1];
        
        if (![GlobalDataManager isBlueBoughtWithDict]) {
            coin1 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label1 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label1.position = CGPointMake(menuP1.position.x - coin1.contentSize.width/2, menuP1.position.y - POS_ADJUSTMENT);
            [self addChild:label1 z:2];
            
            stroke1 = [self createStroke:label1 size:0.5 color:ccBLACK];
            stroke1.position = label1.position;
            [self addChild:stroke1 z:1];
            
            
            coin1.position = CGPointMake(label1.position.x + label1.contentSize.width/2, label1.position.y + 2);
            [self addChild:coin1 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Blue"]) {
                label1 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label1 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label1.position = CGPointMake(menuP1.position.x, menuP1.position.y - POS_ADJUSTMENT);
            [self addChild:label1 z:2];
            
            stroke1 = [self createStroke:label1 size:0.5 color:ccBLACK];
            stroke1.position = label1.position;
            [self addChild:stroke1 z:1];
        }
        
        
        
        Player* p2 = [Player player:@"Jeff-Brown.png"];
        p2.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 2 * top.contentSize.height*1.25);
        [self addChild:p2];
        
        CCMenuItem* buttonP2 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyBrown:)];
        menuP2 = [CCMenu menuWithItems:buttonP2, nil];
        menuP2.position = CGPointMake(winSizeActual.width - buttonP2.contentSize.width/2 - 5, p2.position.y);
        [self addChild:menuP2];

        if (![GlobalDataManager isBrownBoughtWithDict]) {
            coin2 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label2 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label2.position = CGPointMake(menuP2.position.x - coin2.contentSize.width/2, menuP2.position.y - POS_ADJUSTMENT);
            [self addChild:label2 z:2];
            
            stroke2 = [self createStroke:label2 size:0.5 color:ccBLACK];
            stroke2.position = label2.position;
            [self addChild:stroke2 z:1];
            
            
            coin2.position = CGPointMake(label2.position.x + label2.contentSize.width/2, label2.position.y + 2);
            [self addChild:coin2 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Brown"]) {
                label2 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label2 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label2.position = CGPointMake(menuP2.position.x, menuP2.position.y - POS_ADJUSTMENT);
            [self addChild:label2 z:2];
            
            stroke2 = [self createStroke:label2 size:0.5 color:ccBLACK];
            stroke2.position = label2.position;
            [self addChild:stroke2 z:1];
        }
        
        
        
        Player* p3 = [Player player:@"Jeff-Green.png"];
        p3.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 3 * top.contentSize.height*1.25);
        [self addChild:p3];
    
        CCMenuItem* buttonP3 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyGreen:)];
        menuP3 = [CCMenu menuWithItems:buttonP3, nil];
        menuP3.position = CGPointMake(winSizeActual.width - buttonP3.contentSize.width/2 - 5, p3.position.y);
        [self addChild:menuP3];
        
        if (![GlobalDataManager isGreenBoughtWithDict]) {
            coin3 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label3 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label3.position = CGPointMake(menuP3.position.x - coin3.contentSize.width/2, menuP3.position.y - POS_ADJUSTMENT);
            [self addChild:label3 z:2];
            
            stroke3 = [self createStroke:label3 size:0.5 color:ccBLACK];
            stroke3.position = label3.position;
            [self addChild:stroke3 z:1];
            
            
            coin3.position = CGPointMake(label3.position.x + label3.contentSize.width/2, label3.position.y + 2);
            [self addChild:coin3 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Green"]) {
                label3 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label3 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label3.position = CGPointMake(menuP3.position.x, menuP3.position.y - POS_ADJUSTMENT);
            [self addChild:label3 z:2];
            
            stroke3 = [self createStroke:label3 size:0.5 color:ccBLACK];
            stroke3.position = label3.position;
            [self addChild:stroke3 z:1];
        }
        
        
        
        Player* p4 = [Player player:@"Jeff-Grey.png"];
        p4.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 4 * top.contentSize.height*1.25);
        [self addChild:p4];
        
        CCMenuItem* buttonP4 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyGrey:)];
        menuP4 = [CCMenu menuWithItems:buttonP4, nil];
        menuP4.position = CGPointMake(winSizeActual.width - buttonP4.contentSize.width/2 - 5, p4.position.y);
        [self addChild:menuP4];
        
        if (![GlobalDataManager isGreyBoughtWithDict]) {
            coin4 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label4 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label4.position = CGPointMake(menuP4.position.x - coin4.contentSize.width/2, menuP4.position.y - POS_ADJUSTMENT);
            [self addChild:label4 z:2];
            
            stroke4 = [self createStroke:label4 size:0.5 color:ccBLACK];
            stroke4.position = label4.position;
            [self addChild:stroke4 z:1];
            
            
            coin4.position = CGPointMake(label4.position.x + label4.contentSize.width/2, label4.position.y + 2);
            [self addChild:coin4 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Grey"]) {
                label4 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label4 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label4.position = CGPointMake(menuP4.position.x, menuP4.position.y - POS_ADJUSTMENT);
            [self addChild:label4 z:2];
            
            stroke4 = [self createStroke:label4 size:0.5 color:ccBLACK];
            stroke4.position = label4.position;
            [self addChild:stroke4 z:1];
        }
        
        
        Player* p5 = [Player player:@"Jeff-Maroon.png"];
        p5.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 5 * top.contentSize.height*1.25);
        [self addChild:p5];
        
        CCMenuItem* buttonP5 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMaroon:)];
        menuP5 = [CCMenu menuWithItems:buttonP5, nil];
        menuP5.position = CGPointMake(winSizeActual.width - buttonP5.contentSize.width/2 - 5, p5.position.y);
        [self addChild:menuP5];
        
        if (![GlobalDataManager isMaroonBoughtWithDict]) {
            coin5 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label5 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label5.position = CGPointMake(menuP5.position.x - coin5.contentSize.width/2, menuP5.position.y - POS_ADJUSTMENT);
            [self addChild:label5 z:2];
            
            stroke5 = [self createStroke:label5 size:0.5 color:ccBLACK];
            stroke5.position = label5.position;
            [self addChild:stroke5 z:1];
            
            
            coin5.position = CGPointMake(label5.position.x + label5.contentSize.width/2, label5.position.y + 2);
            [self addChild:coin5 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Maroon"]) {
                label5 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label5 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label5.position = CGPointMake(menuP5.position.x, menuP5.position.y - POS_ADJUSTMENT);
            [self addChild:label5 z:2];
            
            stroke5 = [self createStroke:label5 size:0.5 color:ccBLACK];
            stroke5.position = label5.position;
            [self addChild:stroke5 z:1];
        }
        
        
        Player* p6 = [Player player:@"Jeff-Military-Green.png"];
        p6.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 6 * top.contentSize.height*1.25);
        [self addChild:p6];
        
        CCMenuItem* buttonP6 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyMilitaryGreen:)];
        menuP6 = [CCMenu menuWithItems:buttonP6, nil];
        menuP6.position = CGPointMake(winSizeActual.width - buttonP6.contentSize.width/2 - 5, p6.position.y);
        [self addChild:menuP6];
        
        if (![GlobalDataManager isMilitaryGreenBoughtWithDict]) {
            coin6 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label6 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label6.position = CGPointMake(menuP6.position.x - coin6.contentSize.width/2, menuP6.position.y - POS_ADJUSTMENT);
            [self addChild:label6 z:2];
            
            stroke6 = [self createStroke:label6 size:0.5 color:ccBLACK];
            stroke6.position = label6.position;
            [self addChild:stroke6 z:1];
            
            
            coin6.position = CGPointMake(label6.position.x + label6.contentSize.width/2, label6.position.y + 2);
            [self addChild:coin6 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Military-Green"]) {
                label6 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label6 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label6.position = CGPointMake(menuP6.position.x, menuP6.position.y - POS_ADJUSTMENT);
            [self addChild:label6 z:2];
            
            stroke6 = [self createStroke:label6 size:0.5 color:ccBLACK];
            stroke6.position = label6.position;
            [self addChild:stroke6 z:1];
        }
        
        
        Player* p7 = [Player player:@"Jeff-Navy.png"];
        p7.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 7 * top.contentSize.height*1.25);
        [self addChild:p7];
        
        CCMenuItem* buttonP7 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyNavy:)];
        menuP7 = [CCMenu menuWithItems:buttonP7, nil];
        menuP7.position = CGPointMake(winSizeActual.width - buttonP7.contentSize.width/2 - 5, p7.position.y);
        [self addChild:menuP7];

        if (![GlobalDataManager isNavyBoughtWithDict]) {
            coin7 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label7 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label7.position = CGPointMake(menuP7.position.x - coin7.contentSize.width/2, menuP7.position.y - POS_ADJUSTMENT);
            [self addChild:label7 z:2];
            
            stroke7 = [self createStroke:label7 size:0.5 color:ccBLACK];
            stroke7.position = label7.position;
            [self addChild:stroke7 z:1];
            
            
            coin7.position = CGPointMake(label7.position.x + label7.contentSize.width/2, label7.position.y + 2);
            [self addChild:coin7 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Navy"]) {
                label7 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label7 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label7.position = CGPointMake(menuP7.position.x, menuP7.position.y - POS_ADJUSTMENT);
            [self addChild:label7 z:2];
            
            stroke7 = [self createStroke:label7 size:0.5 color:ccBLACK];
            stroke7.position = label7.position;
            [self addChild:stroke7 z:1];
        }
        
        
        
        Player* p8 = [Player player:@"Jeff-Orange.png"];
        p8.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 8 * top.contentSize.height*1.25);
        [self addChild:p8];
        
        CCMenuItem* buttonP8 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyOrange:)];
        menuP8 = [CCMenu menuWithItems:buttonP8, nil];
        menuP8.position = CGPointMake(winSizeActual.width - buttonP8.contentSize.width/2 - 5, p8.position.y);
        [self addChild:menuP8];
        
        if (![GlobalDataManager isOrangeBoughtWithDict]) {
            coin8 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label8 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label8.position = CGPointMake(menuP8.position.x - coin8.contentSize.width/2, menuP8.position.y - POS_ADJUSTMENT);
            [self addChild:label8 z:2];
            
            stroke8 = [self createStroke:label8 size:0.5 color:ccBLACK];
            stroke8.position = label8.position;
            [self addChild:stroke8 z:1];
            
            
            coin8.position = CGPointMake(label8.position.x + label8.contentSize.width/2, label8.position.y + 2);
            [self addChild:coin8 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Orange"]) {
                label8 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label8 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label8.position = CGPointMake(menuP8.position.x, menuP8.position.y - POS_ADJUSTMENT);
            [self addChild:label8 z:2];
            
            stroke8 = [self createStroke:label8 size:0.5 color:ccBLACK];
            stroke8.position = label8.position;
            [self addChild:stroke8 z:1];
        }
        
        
        Player* p9 = [Player player:@"Jeff-Pink.png"];
        p9.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 9 * top.contentSize.height*1.25);
        [self addChild:p9];
        
        CCMenuItem* buttonP9 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyPink:)];
        menuP9 = [CCMenu menuWithItems:buttonP9, nil];
        menuP9.position = CGPointMake(winSizeActual.width - buttonP9.contentSize.width/2 - 5, p9.position.y);
        [self addChild:menuP9];
        
        if (![GlobalDataManager isPinkBoughtWithDict]) {
            coin9 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label9 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label9.position = CGPointMake(menuP9.position.x - coin9.contentSize.width/2, menuP9.position.y - POS_ADJUSTMENT);
            [self addChild:label9 z:2];
            
            stroke9 = [self createStroke:label9 size:0.5 color:ccBLACK];
            stroke9.position = label9.position;
            [self addChild:stroke9 z:1];
            
            
            coin9.position = CGPointMake(label9.position.x + label9.contentSize.width/2, label9.position.y + 2);
            [self addChild:coin9 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Pink"]) {
                label9 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label9 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label9.position = CGPointMake(menuP9.position.x, menuP9.position.y - POS_ADJUSTMENT);
            [self addChild:label9 z:2];
            
            stroke9 = [self createStroke:label9 size:0.5 color:ccBLACK];
            stroke9.position = label9.position;
            [self addChild:stroke9 z:1];
        }
        
        
        Player* p10 = [Player player:@"Jeff-Purple.png"];
        p10.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 10 * top.contentSize.height*1.25);
        [self addChild:p10];
        
        CCMenuItem* buttonP10 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyPurple:)];
        menuP10 = [CCMenu menuWithItems:buttonP10, nil];
        menuP10.position = CGPointMake(winSizeActual.width - buttonP10.contentSize.width/2 - 5, p10.position.y);
        [self addChild:menuP10];
        
        if (![GlobalDataManager isPurpleBoughtWithDict]) {
            coin10 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label10 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label10.position = CGPointMake(menuP10.position.x - coin10.contentSize.width/2, menuP10.position.y - POS_ADJUSTMENT);
            [self addChild:label10 z:2];
            
            stroke10 = [self createStroke:label10 size:0.5 color:ccBLACK];
            stroke10.position = label10.position;
            [self addChild:stroke10 z:1];
            
            
            coin10.position = CGPointMake(label10.position.x + label10.contentSize.width/2, label10.position.y + 2);
            [self addChild:coin10 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Purple"]) {
                label10 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label10 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label10.position = CGPointMake(menuP10.position.x, menuP10.position.y - POS_ADJUSTMENT);
            [self addChild:label10 z:2];
            
            stroke10 = [self createStroke:label10 size:0.5 color:ccBLACK];
            stroke10.position = label10.position;
            [self addChild:stroke10 z:1];
        }
        
        
        Player* p11 = [Player player:@"Jeff-Red.png"];
        p11.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 11 * top.contentSize.height*1.25);
        [self addChild:p11];
        
        CCMenuItem* buttonP11 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyRed:)];
        menuP11 = [CCMenu menuWithItems:buttonP11, nil];
        menuP11.position = CGPointMake(winSizeActual.width - buttonP11.contentSize.width/2 - 5, p11.position.y);
        [self addChild:menuP11];
        
        if (![GlobalDataManager isRedBoughtWithDict]) {
            coin11 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label11 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label11.position = CGPointMake(menuP11.position.x - coin11.contentSize.width/2, menuP11.position.y - POS_ADJUSTMENT);
            [self addChild:label11 z:2];
            
            stroke11 = [self createStroke:label11 size:0.5 color:ccBLACK];
            stroke11.position = label11.position;
            [self addChild:stroke11 z:1];
            
            
            coin11.position = CGPointMake(label11.position.x + label11.contentSize.width/2, label11.position.y + 2);
            [self addChild:coin11 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Red"]) {
                label11 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label11 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label11.position = CGPointMake(menuP11.position.x, menuP11.position.y - POS_ADJUSTMENT);
            [self addChild:label11 z:2];
            
            stroke11 = [self createStroke:label11 size:0.5 color:ccBLACK];
            stroke11.position = label11.position;
            [self addChild:stroke11 z:1];
        }
        
        
        Player* p12 = [Player player:@"Jeff-Tan.png"];
        p12.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 12 * top.contentSize.height*1.25);
        [self addChild:p12];
        
        CCMenuItem* buttonP12 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyTan:)];
        menuP12 = [CCMenu menuWithItems:buttonP12, nil];
        menuP12.position = CGPointMake(winSizeActual.width - buttonP12.contentSize.width/2 - 5, p12.position.y);
        [self addChild:menuP12];
        
        if (![GlobalDataManager isTanBoughtWithDict]) {
            coin12 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label12 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label12.position = CGPointMake(menuP12.position.x - coin12.contentSize.width/2, menuP12.position.y - POS_ADJUSTMENT);
            [self addChild:label12 z:2];
            
            stroke12 = [self createStroke:label12 size:0.5 color:ccBLACK];
            stroke12.position = label12.position;
            [self addChild:stroke12 z:1];
            
            
            coin12.position = CGPointMake(label12.position.x + label12.contentSize.width/2, label12.position.y + 2);
            [self addChild:coin12 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Tan"]) {
                label12 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label12 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label12.position = CGPointMake(menuP12.position.x, menuP12.position.y - POS_ADJUSTMENT);
            [self addChild:label12 z:2];
            
            stroke12 = [self createStroke:label12 size:0.5 color:ccBLACK];
            stroke12.position = label12.position;
            [self addChild:stroke12 z:1];
        }
        
        
        Player* p13 = [Player player:@"Jeff-Turquoise.png"];
        p13.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 13 * top.contentSize.height*1.25);
        [self addChild:p13];
        
        CCMenuItem* buttonP13 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyTurquoise:)];
        menuP13 = [CCMenu menuWithItems:buttonP13, nil];
        menuP13.position = CGPointMake(winSizeActual.width - buttonP13.contentSize.width/2 - 5, p13.position.y);
        [self addChild:menuP13];
        
        if (![GlobalDataManager isTurquoiseBoughtWithDict]) {
            coin13 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label13 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label13.position = CGPointMake(menuP13.position.x - coin13.contentSize.width/2, menuP13.position.y - POS_ADJUSTMENT);
            [self addChild:label13 z:2];
            
            stroke13 = [self createStroke:label13 size:0.5 color:ccBLACK];
            stroke13.position = label13.position;
            [self addChild:stroke13 z:1];
            
            
            coin13.position = CGPointMake(label13.position.x + label13.contentSize.width/2, label13.position.y + 2);
            [self addChild:coin13 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Turquoise"]) {
                label13 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label13 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label13.position = CGPointMake(menuP13.position.x, menuP13.position.y - POS_ADJUSTMENT);
            [self addChild:label13 z:2];
            
            stroke13 = [self createStroke:label13 size:0.5 color:ccBLACK];
            stroke13.position = label13.position;
            [self addChild:stroke13 z:1];
        }
        
        
        bottom = [Player player:@"Jeff-Yellow.png"];
        bottom.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 14 * top.contentSize.height*1.25);
        [self addChild:bottom];
        
        CCMenuItem* buttonP14 = [CCMenuItemImage itemWithNormalImage:@"Empty-button.png" selectedImage:@"Push-Empty.png" target:self selector:@selector(buyYellow:)];
        menuP14 = [CCMenu menuWithItems:buttonP14, nil];
        menuP14.position = CGPointMake(winSizeActual.width - buttonP14.contentSize.width/2 - 5, bottom.position.y);
        [self addChild:menuP14];
        
        if (![GlobalDataManager isYellowBoughtWithDict]) {
            coin14 = [CCSprite spriteWithFile:@"store-coin.png"];
            
            label14 = [CCLabelTTF labelWithString:@"400   " fontName:@"Orbitron-Light" fontSize:FONT_SIZE];
            label14.position = CGPointMake(menuP14.position.x - coin14.contentSize.width/2, menuP14.position.y - POS_ADJUSTMENT);
            [self addChild:label14 z:2];
            
            stroke14 = [self createStroke:label14 size:0.5 color:ccBLACK];
            stroke14.position = label14.position;
            [self addChild:stroke14 z:1];
            
            
            coin14.position = CGPointMake(label14.position.x + label14.contentSize.width/2, label14.position.y + 2);
            [self addChild:coin14 z:2];
        }
        else {
            if ([[GlobalDataManager playerColorWithDict] isEqualToString:@"Yellow"]) {
                label14 = [CCLabelTTF labelWithString:@"SELECTED" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
                
            }
            else {
                label14 = [CCLabelTTF labelWithString:@"SELECT" fontName:@"Orbitron-Light" fontSize:SMALLER_FONT_SIZE];
            }
            
            label14.position = CGPointMake(menuP14.position.x, menuP14.position.y - POS_ADJUSTMENT);
            [self addChild:label14 z:2];
            
            stroke14 = [self createStroke:label14 size:0.5 color:ccBLACK];
            stroke14.position = label14.position;
            [self addChild:stroke14 z:1];
        }
        
        self.position = CGPointMake(self.position.x, -138.42);
        self.touchEnabled = YES;
    }
    return self;
}




-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    float diffY = touchLocation.y - prevLocation.y;
    
    CGPoint diff = CGPointMake(self.position.x, diffY);
    
    [self setPosition: ccpAdd(self.position, diff)];
    
    
    if (self.position.y <= -138.42) {
        self.position = CGPointMake(self.position.x, -138.42);
    }
    if (self.position.y >= 70.58 + 568 - winSizeActual.height) {
        self.position = CGPointMake(self.position.x, 70.58 + 568 - winSizeActual.height);
    }
}


-(void) buyBlack:(id)sender{
    if ([GlobalDataManager isBlackBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Black"];
        label0.string = @"SELECTED";
        label0.position = CGPointMake(menuP0.position.x, menuP0.position.y - POS_ADJUSTMENT);
        label0.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke0];
        stroke0 = nil;
        stroke0 = [self createStroke:label0 size:0.5 color:ccBLACK];
        stroke0.position = label0.position;
        [self addChild:stroke0];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Black"];
        [GlobalDataManager setIsBlackBoughtWithDict:YES];
        
        [self fixSelected];
        label0.string = @"SELECTED";
        label0.position = CGPointMake(menuP0.position.x, menuP0.position.y - POS_ADJUSTMENT);
        label0.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke0];
        stroke0 = nil;
        stroke0 = [self createStroke:label0 size:0.5 color:ccBLACK];
        stroke0.position = label0.position;
        [self addChild:stroke0];
        
        [self removeChild:coin0];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyBlue:(id)sender{
    if ([GlobalDataManager isBlueBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Blue"];
        label1.string = @"SELECTED";
        label1.position = CGPointMake(menuP1.position.x, menuP1.position.y - POS_ADJUSTMENT);
        label1.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke1];
        stroke1 = nil;
        stroke1 = [self createStroke:label1 size:0.5 color:ccBLACK];
        stroke1.position = label1.position;
        [self addChild:stroke1];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Blue"];
        [GlobalDataManager setIsBlueBoughtWithDict:YES];
        
        [self fixSelected];
        label1.string = @"SELECTED";
        label1.position = CGPointMake(menuP1.position.x, menuP1.position.y - POS_ADJUSTMENT);
        label1.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke1];
        stroke1 = nil;
        stroke1 = [self createStroke:label1 size:0.5 color:ccBLACK];
        stroke1.position = label1.position;
        [self addChild:stroke1];
        
        [self removeChild:coin1];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];}
-(void) buyBrown:(id)sender{
    if ([GlobalDataManager isBrownBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Brown"];
        label2.string = @"SELECTED";
        label2.position = CGPointMake(menuP2.position.x, menuP2.position.y - POS_ADJUSTMENT);
        label2.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke2];
        stroke2 = nil;
        stroke2 = [self createStroke:label2 size:0.5 color:ccBLACK];
        stroke2.position = label2.position;
        [self addChild:stroke2];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Brown"];
        [GlobalDataManager setIsBrownBoughtWithDict:YES];
        
        [self fixSelected];
        label2.string = @"SELECTED";
        label2.position = CGPointMake(menuP2.position.x, menuP2.position.y - POS_ADJUSTMENT);
        label2.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke2];
        stroke2 = nil;
        stroke2 = [self createStroke:label2 size:0.5 color:ccBLACK];
        stroke2.position = label2.position;
        [self addChild:stroke2];
        
        [self removeChild:coin2];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyGreen:(id)sender{
    if ([GlobalDataManager isGreenBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Green"];
        label3.string = @"SELECTED";
        label3.position = CGPointMake(menuP3.position.x, menuP3.position.y - POS_ADJUSTMENT);
        label3.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke3];
        stroke3 = nil;
        stroke3 = [self createStroke:label3 size:0.5 color:ccBLACK];
        stroke3.position = label3.position;
        [self addChild:stroke3];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Green"];
        [GlobalDataManager setIsGreenBoughtWithDict:YES];
        
        [self fixSelected];
        label3.string = @"SELECTED";
        label3.position = CGPointMake(menuP3.position.x, menuP3.position.y - POS_ADJUSTMENT);
        label3.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke3];
        stroke3 = nil;
        stroke3 = [self createStroke:label3 size:0.5 color:ccBLACK];
        stroke3.position = label3.position;
        [self addChild:stroke3];
        
        [self removeChild:coin3];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyGrey:(id)sender{
    if ([GlobalDataManager isGreyBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Grey"];
        label4.string = @"SELECTED";
        label4.position = CGPointMake(menuP4.position.x, menuP4.position.y - POS_ADJUSTMENT);
        label4.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke4];
        stroke4 = nil;
        stroke4 = [self createStroke:label4 size:0.5 color:ccBLACK];
        stroke4.position = label4.position;
        [self addChild:stroke4];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Grey"];
        [GlobalDataManager setIsGreyBoughtWithDict:YES];
        
        [self fixSelected];
        label4.string = @"SELECTED";
        label4.position = CGPointMake(menuP4.position.x, menuP4.position.y - POS_ADJUSTMENT);
        label4.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke4];
        stroke4 = nil;
        stroke4 = [self createStroke:label4 size:0.5 color:ccBLACK];
        stroke4.position = label4.position;
        [self addChild:stroke4];
        
        [self removeChild:coin4];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyMaroon:(id)sender{
    if ([GlobalDataManager isMaroonBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Maroon"];
        label5.string = @"SELECTED";
        label5.position = CGPointMake(menuP5.position.x, menuP5.position.y - POS_ADJUSTMENT);
        label5.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke5];
        stroke5 = nil;
        stroke5 = [self createStroke:label5 size:0.5 color:ccBLACK];
        stroke5.position = label5.position;
        [self addChild:stroke5];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Maroon"];
        [GlobalDataManager setIsMaroonBoughtWithDict:YES];
        
        [self fixSelected];
        label5.string = @"SELECTED";
        label5.position = CGPointMake(menuP5.position.x, menuP5.position.y - POS_ADJUSTMENT);
        label5.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke5];
        stroke5 = nil;
        stroke5 = [self createStroke:label5 size:0.5 color:ccBLACK];
        stroke5.position = label5.position;
        [self addChild:stroke5];
        
        [self removeChild:coin5];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyMilitaryGreen:(id)sender{
    if ([GlobalDataManager isMilitaryGreenBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Military-Green"];
        label6.string = @"SELECTED";
        label6.position = CGPointMake(menuP6.position.x, menuP6.position.y - POS_ADJUSTMENT);
        label6.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke6];
        stroke6 = nil;
        stroke6 = [self createStroke:label6 size:0.5 color:ccBLACK];
        stroke6.position = label6.position;
        [self addChild:stroke6];
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Military-Green"];
        [GlobalDataManager setIsMilitaryGreenBoughtWithDict:YES];
        
        [self fixSelected];
        label6.string = @"SELECTED";
        label6.position = CGPointMake(menuP6.position.x, menuP6.position.y - POS_ADJUSTMENT);
        label6.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke6];
        stroke6 = nil;
        stroke6 = [self createStroke:label6 size:0.5 color:ccBLACK];
        stroke6.position = label6.position;
        [self addChild:stroke6];
        
        [self removeChild:coin6];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyNavy:(id)sender{
    if ([GlobalDataManager isNavyBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Navy"];
        label7.string = @"SELECTED";
        label7.position = CGPointMake(menuP7.position.x, menuP7.position.y - POS_ADJUSTMENT);
        label7.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke7];
        stroke7 = nil;
        stroke7 = [self createStroke:label7 size:0.5 color:ccBLACK];
        stroke7.position = label7.position;
        [self addChild:stroke7];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Navy"];
        [GlobalDataManager setIsNavyBoughtWithDict:YES];
        
        [self fixSelected];
        label7.string = @"SELECTED";
        label7.position = CGPointMake(menuP7.position.x, menuP7.position.y - POS_ADJUSTMENT);
        label7.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke7];
        stroke7 = nil;
        stroke7 = [self createStroke:label7 size:0.5 color:ccBLACK];
        stroke7.position = label7.position;
        [self addChild:stroke7];
        
        [self removeChild:coin7];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyOrange:(id)sender{
    if ([GlobalDataManager isOrangeBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Orange"];
        label8.string = @"SELECTED";
        label8.position = CGPointMake(menuP8.position.x, menuP8.position.y - POS_ADJUSTMENT);
        label8.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke8];
        stroke8 = nil;
        stroke8 = [self createStroke:label8 size:0.5 color:ccBLACK];
        stroke8.position = label8.position;
        [self addChild:stroke8];
        
        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Orange"];
        [GlobalDataManager setIsOrangeBoughtWithDict:YES];
        
        [self fixSelected];
        label8.string = @"SELECTED";
        label8.position = CGPointMake(menuP8.position.x, menuP8.position.y - POS_ADJUSTMENT);
        label8.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke8];
        stroke8 = nil;
        stroke8 = [self createStroke:label8 size:0.5 color:ccBLACK];
        stroke8.position = label8.position;
        [self addChild:stroke8];
        
        [self removeChild:coin8];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyPink:(id)sender{
    if ([GlobalDataManager isPinkBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Pink"];
        label9.string = @"SELECTED";
        label9.position = CGPointMake(menuP9.position.x, menuP9.position.y - POS_ADJUSTMENT);
        label9.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke9];
        stroke9 = nil;
        stroke9 = [self createStroke:label9 size:0.5 color:ccBLACK];
        stroke9.position = label9.position;
        [self addChild:stroke9];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Pink"];
        [GlobalDataManager setIsPinkBoughtWithDict:YES];
        
        [self fixSelected];
        label9.string = @"SELECTED";
        label9.position = CGPointMake(menuP9.position.x, menuP9.position.y - POS_ADJUSTMENT);
        label9.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke9];
        stroke9 = nil;
        stroke9 = [self createStroke:label9 size:0.5 color:ccBLACK];
        stroke9.position = label9.position;
        [self addChild:stroke9];
        
        [self removeChild:coin9];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyPurple:(id)sender{
    if ([GlobalDataManager isPurpleBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Purple"];
        label10.string = @"SELECTED";
        label10.position = CGPointMake(menuP10.position.x, menuP10.position.y - POS_ADJUSTMENT);
        label10.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke10];
        stroke10 = nil;
        stroke10 = [self createStroke:label10 size:0.5 color:ccBLACK];
        stroke10.position = label10.position;
        [self addChild:stroke10];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Purple"];
        [GlobalDataManager setIsPurpleBoughtWithDict:YES];
        
        [self fixSelected];
        label10.string = @"SELECTED";
        label10.position = CGPointMake(menuP10.position.x, menuP10.position.y - POS_ADJUSTMENT);
        label10.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke10];
        stroke10 = nil;
        stroke10 = [self createStroke:label10 size:0.5 color:ccBLACK];
        stroke10.position = label10.position;
        [self addChild:stroke10];
        
        [self removeChild:coin10];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyRed:(id)sender{
    if ([GlobalDataManager isRedBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Red"];
        label11.string = @"SELECTED";
        label11.position = CGPointMake(menuP11.position.x, menuP11.position.y - POS_ADJUSTMENT);
        label11.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke11];
        stroke11 = nil;
        stroke11 = [self createStroke:label11 size:0.5 color:ccBLACK];
        stroke11.position = label11.position;
        [self addChild:stroke11];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Red"];
        [GlobalDataManager setIsRedBoughtWithDict:YES];
        
        [self fixSelected];
        label11.string = @"SELECTED";
        label11.position = CGPointMake(menuP11.position.x, menuP11.position.y - POS_ADJUSTMENT);
        label11.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke11];
        stroke11 = nil;
        stroke11 = [self createStroke:label11 size:0.5 color:ccBLACK];
        stroke11.position = label11.position;
        [self addChild:stroke11];
        
        [self removeChild:coin11];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyTan:(id)sender{
    if ([GlobalDataManager isTanBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Tan"];
        label12.string = @"SELECTED";
        label12.position = CGPointMake(menuP12.position.x, menuP12.position.y - POS_ADJUSTMENT);
        label12.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke12];
        stroke12 = nil;
        stroke12 = [self createStroke:label12 size:0.5 color:ccBLACK];
        stroke12.position = label12.position;
        [self addChild:stroke12];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Tan"];
        [GlobalDataManager setIsTanBoughtWithDict:YES];
        
        [self fixSelected];
        label12.string = @"SELECTED";
        label12.position = CGPointMake(menuP12.position.x, menuP12.position.y - POS_ADJUSTMENT);
        label12.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke12];
        stroke12 = nil;
        stroke12 = [self createStroke:label12 size:0.5 color:ccBLACK];
        stroke12.position = label12.position;
        [self addChild:stroke12];
        
        [self removeChild:coin12];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyTurquoise:(id)sender{
    if ([GlobalDataManager isTurquoiseBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Turquoise"];
        label13.string = @"SELECTED";
        label13.position = CGPointMake(menuP13.position.x, menuP13.position.y - POS_ADJUSTMENT);
        label13.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke13];
        stroke13 = nil;
        stroke13 = [self createStroke:label13 size:0.5 color:ccBLACK];
        stroke13.position = label13.position;
        [self addChild:stroke13];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Turquoise"];
        [GlobalDataManager setIsTurquoiseBoughtWithDict:YES];
        
        [self fixSelected];
        label13.string = @"SELECTED";
        label13.position = CGPointMake(menuP13.position.x, menuP13.position.y - POS_ADJUSTMENT);
        label13.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke13];
        stroke13 = nil;
        stroke13 = [self createStroke:label13 size:0.5 color:ccBLACK];
        stroke13.position = label13.position;
        [self addChild:stroke13];
        
        [self removeChild:coin13];
        [self updateCoins];
        
        return;
    }
    
    
    [self notEnoughCoins];
}
-(void) buyYellow:(id)sender{
    if ([GlobalDataManager isYellowBoughtWithDict]) {
        [self fixSelected];
        
        [GlobalDataManager setPlayerColorWithDict:@"Yellow"];
        label14.string = @"SELECTED";
        label14.position = CGPointMake(menuP14.position.x, menuP14.position.y - POS_ADJUSTMENT);
        label14.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke14];
        stroke14 = nil;
        stroke14 = [self createStroke:label14 size:0.5 color:ccBLACK];
        stroke14.position = label14.position;
        [self addChild:stroke14];

        return;
    }
    
    int totalCoins = [GlobalDataManager totalCoinsWithDict];
    if (totalCoins >= PRICE) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] - PRICE];
        [GlobalDataManager setPlayerColorWithDict:@"Yellow"];
        [GlobalDataManager setIsYellowBoughtWithDict:YES];
        
        [self fixSelected];
        label14.string = @"SELECTED";
        label14.position = CGPointMake(menuP14.position.x, menuP14.position.y - POS_ADJUSTMENT);
        label14.fontSize = SMALLER_FONT_SIZE;
        
        [self removeChild:stroke14];
        stroke14 = nil;
        stroke14 = [self createStroke:label14 size:0.5 color:ccBLACK];
        stroke14.position = label14.position;
        [self addChild:stroke14];
        
        [self removeChild:coin14];
        [self updateCoins];
        
        return;
    }
    
    [self notEnoughCoins];
}

-(void) updateCoins {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Apparel* layer = (Apparel*)[scene getChildByTag:APPAREL_SCENE_TAG];
    
    [layer updateNumCoins];
}

-(void) notEnoughCoins {
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    Apparel* layer = (Apparel*)[scene getChildByTag:APPAREL_SCENE_TAG];

    [layer notEnoughCoins];
}

-(void) fixSelected {
    if ([label0.string isEqualToString:@"SELECTED"]) {
        label0.string = @"SELECT";
        label0.position = CGPointMake(menuP0.position.x, menuP0.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke0];
        stroke0 = nil;
        stroke0 = [self createStroke:label0 size:0.5 color:ccBLACK];
        stroke0.position = label0.position;
        [self addChild:stroke0];
    }
    if ([label1.string isEqualToString:@"SELECTED"]) {
        label1.string = @"SELECT";
        label1.position = CGPointMake(menuP1.position.x, menuP1.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke1];
        stroke1 = nil;
        stroke1 = [self createStroke:label1 size:0.5 color:ccBLACK];
        stroke1.position = label1.position;
        [self addChild:stroke1];
    }
    if ([label2.string isEqualToString:@"SELECTED"]) {
        label2.string = @"SELECT";
        label2.position = CGPointMake(menuP2.position.x, menuP2.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke2];
        stroke2 = nil;
        stroke2 = [self createStroke:label2 size:0.5 color:ccBLACK];
        stroke2.position = label2.position;
        [self addChild:stroke2];
    }
    if ([label3.string isEqualToString:@"SELECTED"]) {
        label3.string = @"SELECT";
        label3.position = CGPointMake(menuP3.position.x, menuP3.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke3];
        stroke3 = nil;
        stroke3 = [self createStroke:label3 size:0.5 color:ccBLACK];
        stroke3.position = label3.position;
        [self addChild:stroke3];
    }
    if ([label4.string isEqualToString:@"SELECTED"]) {
        label4.string = @"SELECT";
        label4.position = CGPointMake(menuP4.position.x, menuP4.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke4];
        stroke4 = nil;
        stroke4 = [self createStroke:label4 size:0.5 color:ccBLACK];
        stroke4.position = label4.position;
        [self addChild:stroke4];
    }
    if ([label5.string isEqualToString:@"SELECTED"]) {
        label5.string = @"SELECT";
        label5.position = CGPointMake(menuP5.position.x, menuP5.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke5];
        stroke5 = nil;
        stroke5 = [self createStroke:label5 size:0.5 color:ccBLACK];
        stroke5.position = label5.position;
        [self addChild:stroke5];
    }
    if ([label6.string isEqualToString:@"SELECTED"]) {
        label6.string = @"SELECT";
        label6.position = CGPointMake(menuP6.position.x, menuP6.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke6];
        stroke6 = nil;
        stroke6 = [self createStroke:label6 size:0.5 color:ccBLACK];
        stroke6.position = label6.position;
        [self addChild:stroke6];
    }
    if ([label7.string isEqualToString:@"SELECTED"]) {
        label7.string = @"SELECT";
        label7.position = CGPointMake(menuP7.position.x, menuP7.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke7];
        stroke7 = nil;
        stroke7 = [self createStroke:label7 size:0.5 color:ccBLACK];
        stroke7.position = label7.position;
        [self addChild:stroke7];
    }
    if ([label8.string isEqualToString:@"SELECTED"]) {
        label8.string = @"SELECT";
        label8.position = CGPointMake(menuP8.position.x, menuP8.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke8];
        stroke8 = nil;
        stroke8 = [self createStroke:label8 size:0.5 color:ccBLACK];
        stroke8.position = label8.position;
        [self addChild:stroke8];
    }
    if ([label9.string isEqualToString:@"SELECTED"]) {
        label9.string = @"SELECT";
        label9.position = CGPointMake(menuP9.position.x, menuP9.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke9];
        stroke9 = nil;
        stroke9 = [self createStroke:label9 size:0.5 color:ccBLACK];
        stroke9.position = label9.position;
        [self addChild:stroke9];
    }
    if ([label10.string isEqualToString:@"SELECTED"]) {
        label10.string = @"SELECT";
        label10.position = CGPointMake(menuP10.position.x, menuP10.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke10];
        stroke10 = nil;
        stroke10 = [self createStroke:label10 size:0.5 color:ccBLACK];
        stroke10.position = label10.position;
        [self addChild:stroke10];
    }
    if ([label11.string isEqualToString:@"SELECTED"]) {
        label11.string = @"SELECT";
        label11.position = CGPointMake(menuP11.position.x, menuP11.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke11];
        stroke11 = nil;
        stroke11 = [self createStroke:label11 size:0.5 color:ccBLACK];
        stroke11.position = label11.position;
        [self addChild:stroke11];
    }
    if ([label12.string isEqualToString:@"SELECTED"]) {
        label12.string = @"SELECT";
        label12.position = CGPointMake(menuP12.position.x, menuP12.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke12];
        stroke12 = nil;
        stroke12 = [self createStroke:label12 size:0.5 color:ccBLACK];
        stroke12.position = label12.position;
        [self addChild:stroke12];
    }
    if ([label13.string isEqualToString:@"SELECTED"]) {
        label13.string = @"SELECT";
        label13.position = CGPointMake(menuP13.position.x, menuP13.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke13];
        stroke13 = nil;
        stroke13 = [self createStroke:label13 size:0.5 color:ccBLACK];
        stroke13.position = label13.position;
        [self addChild:stroke13];
    }
    if ([label14.string isEqualToString:@"SELECTED"]) {
        label14.string = @"SELECT";
        label14.position = CGPointMake(menuP14.position.x, menuP14.position.y - POS_ADJUSTMENT);
        
        [self removeChild:stroke14];
        stroke14 = nil;
        stroke14 = [self createStroke:label14 size:0.5 color:ccBLACK];
        stroke14.position = label14.position;
        [self addChild:stroke14];
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


@end
