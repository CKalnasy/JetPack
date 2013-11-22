//
//  Clothes.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Clothes.h"
#import "GlobalDataManager.h"


@implementation Clothes

+(CCScene *) scene{
    CCScene *scene = [CCScene node];
	Clothes *layer = [Clothes node];
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
        
        
        top = [Player player:@"Jeff-Black.png"];
        top.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height);
        [self addChild:top];
        
        CCMenuItem* buttonP0 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyBlack:)];
        CCMenu* menuP0 = [CCMenu menuWithItems:buttonP0, nil];
        menuP0.position = CGPointMake(winSizeActual.width - buttonP0.contentSize.width/2 - 5, top.position.y);
        [self addChild:menuP0];
        
        if ([[dataDict objectForKey:@"is black bought"]boolValue] == YES) {
            buttonP0.isEnabled = NO;
        }
        
    
        
        Player* p1 = [Player player:@"Jeff-Blue.png"];
        p1.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - top.contentSize.height*1.25);
        [self addChild:p1];
        
        CCMenuItem* buttonP1 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyBlue:)];
        CCMenu* menuP1 = [CCMenu menuWithItems:buttonP1, nil];
        menuP1.position = CGPointMake(winSizeActual.width - buttonP1.contentSize.width/2 - 5, p1.position.y);
        [self addChild:menuP1];
        
        if ([[dataDict objectForKey:@"is blue bought"]boolValue] == YES) {
            buttonP1.isEnabled = NO;
        }
        
        
        
        Player* p2 = [Player player:@"Jeff-Brown.png"];
        p2.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 2 * top.contentSize.height*1.25);
        [self addChild:p2];
        
        CCMenuItem* buttonP2 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyBrown:)];
        CCMenu* menuP2 = [CCMenu menuWithItems:buttonP2, nil];
        menuP2.position = CGPointMake(winSizeActual.width - buttonP2.contentSize.width/2 - 5, p2.position.y);
        [self addChild:menuP2];
        
        if ([[dataDict objectForKey:@"is brown bought"]boolValue] == YES) {
            buttonP2.isEnabled = NO;
        }
        
        
        
        Player* p3 = [Player player:@"Jeff-Green.png"];
        p3.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 3 * top.contentSize.height*1.25);
        [self addChild:p3];
        
        CCMenuItem* buttonP3 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyGreen:)];
        CCMenu* menuP3 = [CCMenu menuWithItems:buttonP3, nil];
        menuP3.position = CGPointMake(winSizeActual.width - buttonP3.contentSize.width/2 - 5, p3.position.y);
        [self addChild:menuP3];
        
        if ([[dataDict objectForKey:@"is green bought"]boolValue] == YES) {
            buttonP3.isEnabled = NO;
        }
        
        
        
        Player* p4 = [Player player:@"Jeff-Grey.png"];
        p4.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 4 * top.contentSize.height*1.25);
        [self addChild:p4];
        
        CCMenuItem* buttonP4 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyGrey:)];
        CCMenu* menuP4 = [CCMenu menuWithItems:buttonP4, nil];
        menuP4.position = CGPointMake(winSizeActual.width - buttonP4.contentSize.width/2 - 5, p4.position.y);
        [self addChild:menuP4];
        
        if ([[dataDict objectForKey:@"is grey bought"]boolValue] == YES) {
            buttonP4.isEnabled = NO;
        }
        
        
        
        Player* p5 = [Player player:@"Jeff-Maroon.png"];
        p5.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 5 * top.contentSize.height*1.25);
        [self addChild:p5];
        
        CCMenuItem* buttonP5 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyMaroon:)];
        CCMenu* menuP5 = [CCMenu menuWithItems:buttonP5, nil];
        menuP5.position = CGPointMake(winSizeActual.width - buttonP5.contentSize.width/2 - 5, p5.position.y);
        [self addChild:menuP5];
        
        if ([[dataDict objectForKey:@"is maroon bought"]boolValue] == YES) {
            buttonP5.isEnabled = NO;
        }
        
        
        
        Player* p6 = [Player player:@"Jeff-Military-Green.png"];
        p6.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 6 * top.contentSize.height*1.25);
        [self addChild:p6];
        
        CCMenuItem* buttonP6 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyMilitaryGreen:)];
        CCMenu* menuP6 = [CCMenu menuWithItems:buttonP6, nil];
        menuP6.position = CGPointMake(winSizeActual.width - buttonP6.contentSize.width/2 - 5, p6.position.y);
        [self addChild:menuP6];
        
        if ([[dataDict objectForKey:@"is military green bought"]boolValue] == YES) {
            buttonP6.isEnabled = NO;
        }
        
        
        
        Player* p7 = [Player player:@"Jeff-Navy.png"];
        p7.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 7 * top.contentSize.height*1.25);
        [self addChild:p7];
        
        CCMenuItem* buttonP7 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyNavy:)];
        CCMenu* menuP7 = [CCMenu menuWithItems:buttonP7, nil];
        menuP7.position = CGPointMake(winSizeActual.width - buttonP7.contentSize.width/2 - 5, p7.position.y);
        [self addChild:menuP7];
        
        if ([[dataDict objectForKey:@"is navy bought"]boolValue] == YES) {
            buttonP7.isEnabled = NO;
        }
        
        
        
        Player* p8 = [Player player:@"Jeff-Orange.png"];
        p8.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 8 * top.contentSize.height*1.25);
        [self addChild:p8];
        
        CCMenuItem* buttonP8 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyOrange:)];
        CCMenu* menuP8 = [CCMenu menuWithItems:buttonP8, nil];
        menuP8.position = CGPointMake(winSizeActual.width - buttonP8.contentSize.width/2 - 5, p8.position.y);
        [self addChild:menuP8];
        
        if ([[dataDict objectForKey:@"is orange bought"]boolValue] == YES) {
            buttonP8.isEnabled = NO;
        }
        
        
        
        Player* p9 = [Player player:@"Jeff-Pink.png"];
        p9.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 9 * top.contentSize.height*1.25);
        [self addChild:p9];
        
        CCMenuItem* buttonP9 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyPink:)];
        CCMenu* menuP9 = [CCMenu menuWithItems:buttonP9, nil];
        menuP9.position = CGPointMake(winSizeActual.width - buttonP9.contentSize.width/2 - 5, p9.position.y);
        [self addChild:menuP9];
        
        if ([[dataDict objectForKey:@"is pink bought"]boolValue] == YES) {
            buttonP9.isEnabled = NO;
        }
        
        
        
        Player* p10 = [Player player:@"Jeff-Purple.png"];
        p10.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 10 * top.contentSize.height*1.25);
        [self addChild:p10];
        
        CCMenuItem* buttonP10 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyPurple:)];
        CCMenu* menuP10 = [CCMenu menuWithItems:buttonP10, nil];
        menuP10.position = CGPointMake(winSizeActual.width - buttonP10.contentSize.width/2 - 5, p10.position.y);
        [self addChild:menuP10];
        
        if ([[dataDict objectForKey:@"is purple bought"]boolValue] == YES) {
            buttonP10.isEnabled = NO;
        }
        
        
        
        Player* p11 = [Player player:@"Jeff-Red.png"];
        p11.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 11 * top.contentSize.height*1.25);
        [self addChild:p11];
        
        CCMenuItem* buttonP11 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyRed:)];
        CCMenu* menuP11 = [CCMenu menuWithItems:buttonP11, nil];
        menuP11.position = CGPointMake(winSizeActual.width - buttonP11.contentSize.width/2 - 5, p11.position.y);
        [self addChild:menuP11];
        
        if ([[dataDict objectForKey:@"is red bought"]boolValue] == YES) {
            buttonP11.isEnabled = NO;
        }
        
        
        
        Player* p12 = [Player player:@"Jeff-Tan.png"];
        p12.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 12 * top.contentSize.height*1.25);
        [self addChild:p12];
        
        CCMenuItem* buttonP12 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyTan:)];
        CCMenu* menuP12 = [CCMenu menuWithItems:buttonP12, nil];
        menuP12.position = CGPointMake(winSizeActual.width - buttonP12.contentSize.width/2 - 5, p12.position.y);
        [self addChild:menuP12];
        
        if ([[dataDict objectForKey:@"is tan bought"]boolValue] == YES) {
            buttonP12.isEnabled = NO;
        }
        
        
        
        Player* p13 = [Player player:@"Jeff-Turquoise.png"];
        p13.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 13 * top.contentSize.height*1.25);
        [self addChild:p13];
        
        CCMenuItem* buttonP13 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyTurquoise:)];
        CCMenu* menuP13 = [CCMenu menuWithItems:buttonP13, nil];
        menuP13.position = CGPointMake(winSizeActual.width - buttonP13.contentSize.width/2 - 5, p13.position.y);
        [self addChild:menuP13];
        
        if ([[dataDict objectForKey:@"is turquoise bought"]boolValue] == YES) {
            buttonP13.isEnabled = NO;
        }
        
        
        
        bottom = [Player player:@"Jeff-Yellow.png"];
        bottom.position = CGPointMake(5 + top.contentSize.width/2, winSizeActual.height - 14 * top.contentSize.height*1.25);
        [self addChild:bottom];
        
        CCMenuItem* buttonP14 = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" disabledImage:@"back-button.png" target:self selector:@selector(buyYellow:)];
        CCMenu* menuP14 = [CCMenu menuWithItems:buttonP14, nil];
        menuP14.position = CGPointMake(winSizeActual.width - buttonP14.contentSize.width/2 - 5, bottom.position.y);
        [self addChild:menuP14];
        
        if ([[dataDict objectForKey:@"is yellow bought"]boolValue] == YES) {
            buttonP14.isEnabled = NO;
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
    
    //CGPoint diff = ccpSub(touchLocation,prevLocation);
    
    CGPoint diff = CGPointMake(self.position.x, diffY);
    
    [self setPosition: ccpAdd(self.position, diff)];
    
    
    if (self.position.y <= -138) {
        self.position = CGPointMake(self.position.x, -138.42);
    }
    if (self.position.y >= 114.58 + 568 - winSizeActual.height) {
        self.position = CGPointMake(self.position.x, 114.58 + 568 - winSizeActual.height);
    }
}


-(void) buyBlack:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"black"];
}
-(void) buyBlue:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"blue"];
}
-(void) buyBrown:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"brown"];
}
-(void) buyGreen:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"green"];
}
-(void) buyGrey:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"grey"];
}
-(void) buyMaroon:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"maroon"];
}
-(void) buyMilitaryGreen:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"military green"];
}
-(void) buyNavy:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"navy"];
}
-(void) buyOrange:(id)sender{
    if (![sender isEnabled]) {
        return;
    }

    [self confirmPurchase:150 color:@"black"];
}
-(void) buyPink:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"pink"];
}
-(void) buyPurple:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"purple"];
}
-(void) buyRed:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"red"];
}
-(void) buyTan:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"tan"];
}
-(void) buyTurquoise:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"turquoise"];
}
-(void) buyYellow:(id)sender{
    if (![sender isEnabled]) {
        return;
    }
    
    [self confirmPurchase:150 color:@"yellow"];
}


-(void) confirmPurchase:(int)price color:(NSString*)color {
    int numCoins = [[GlobalDataManager sharedGlobalDataManager] numCoins];
    
    if (numCoins >= price) {
        //todo: add "buy" button to middle of screen
    }
    else {
        //todo: add "you don't have enough coins, would you like to get more?"
    }
}

@end
