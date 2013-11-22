//
//  Background.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Background.h"
#import "GlobalDataManager.h"
#import "Game.h"


@implementation Background

@synthesize scoreLabel, coinsLabel;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Background *layer = [Background node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        self.touchEnabled = YES;
        winSizeActual = [[CCDirector sharedDirector]winSize];
        winSizeThreeInch = CGSizeMake(320, 480);
        winSizeFourInch = CGSizeMake(320, 568);
        
        //background scrolling order
        backgroundOrder = [CCArray arrayWithCapacity:6];
        for (int i = 0; i < [backgroundOrder capacity]; i++) {
            int rand = arc4random() % 6 + 1;
            while ([backgroundOrder containsObject:[NSNumber numberWithInt:rand]]) {
                rand = arc4random() % 6 + 1;
            }
            [backgroundOrder addObject:[NSNumber numberWithInt:rand]];
        }
        
        //add the background sprites
        bg1 = [CCSprite spriteWithFile:@"base background.png"];
        bg1.anchorPoint = CGPointMake(0.5, 0);
        //bg1.position = CGPointMake(bg1.contentSize.width/2, bg1.contentSize.height/2);
        bg1.position = CGPointMake(bg1.contentSize.width/2, 0);
        [self addChild:bg1 z:-10];
        
        NSString* name =[NSString stringWithFormat:@"%d.png",[[backgroundOrder objectAtIndex:0] intValue]];
        [backgroundOrder removeObjectAtIndex:0];
        
        bg2 = [CCSprite spriteWithFile:name];
        bg2.anchorPoint = CGPointMake(0.5, 0);
        bg2.position = CGPointMake(bg2.contentSize.width/2, bg1.position.y + bg1.contentSize.height);
        [self addChild:bg2 z:-10];
        
        //scrolling velocities
        backgroundScrollSpeed = CGPointMake(0, 5);
        
        
        //shows the score
        NSString* s = [NSString stringWithFormat:@"%05d",0];
        scoreLabel = [CCLabelTTF labelWithString:s fontName:@"Orbitron-Light" fontSize:20];
		scoreLabel.position = CGPointMake(winSizeActual.width/2, winSizeActual.height - winSizeThreeInch.height/20);
        [self addChild:scoreLabel z:1];
        
        stroke = [self createStroke:scoreLabel size:0.5 color:ccBLACK];
        stroke.position = scoreLabel.position;
        [self addChild:stroke z:0];
        
        //shows the coins
        coinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Orbitron-Light" fontSize:24];
		coinsLabel.position = CGPointMake(winSizeActual.width - winSizeActual.width/20, winSizeActual.height);
		// Adjust the label's anchorPoint's y position to make it align with the top.
		coinsLabel.anchorPoint = CGPointMake(1,1);
        [self addChild:coinsLabel];
        
        //shows the fuel left
        NSString* fuelText = [NSString stringWithFormat:@"%i", [[GlobalDataManager sharedGlobalDataManager]maxFuel]];
        fuelLabel = [CCLabelTTF labelWithString:fuelText fontName:@"arial" fontSize:24];
        fuelLabel.position = CGPointMake(winSizeActual.width - winSizeActual.width/32, winSizeActual.height - 50);
        fuelLabel.anchorPoint = CGPointMake(1, 1);
        [self addChild:fuelLabel];
        
        
        
        //[fuelLabel setFontFillColor:ccWHITE updateImage:YES];
        //[fuelLabel enableStrokeWithColor:ccBLACK size:1 updateImage:YES];
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(backgroundScrolling:)];
        [self schedule:@selector(updateScrollingSpeed:)];
    }
	return self;
}

//updates score, coins, and fuel
-(void) update:(ccTime)delta{
    //score
    if (scoreActual != [[GlobalDataManager sharedGlobalDataManager] scoreActual]) {
        scoreActual = [[GlobalDataManager sharedGlobalDataManager] scoreActual];
        
        NSString* scoreString = [NSString stringWithFormat:@"%i",scoreActual];
        int zeros = 5 - scoreString.length;
        for (int i = 0; i < zeros; i++) {
            scoreString = [@"0" stringByAppendingString:scoreString];
        }
        
        [scoreLabel setString: scoreString];
        
        [self removeChild:stroke cleanup:YES];
        stroke = nil;
        stroke = [self createStroke:scoreLabel size:0.5 color:ccBLACK];
        stroke.position = scoreLabel.position;
        [self addChild:stroke];
        
        scoreRaw = [[GlobalDataManager sharedGlobalDataManager] scoreRaw];
    }
    
    //coins
    if (numCoins != [GlobalDataManager numCoins]) {
        numCoins = [GlobalDataManager numCoins];
        [coinsLabel setString: [NSString  stringWithFormat:@"%i",numCoins]];
    }
    
    //fuel
    if (fuel != [GlobalDataManager fuel]) {
        fuel = [GlobalDataManager fuel];
        [fuelLabel setString: [NSString  stringWithFormat:@"%i",fuel]];
    }
}

//background scrolling
-(void) backgroundScrolling:(ccTime)delta{
    playerVelocity = [[GlobalDataManager sharedGlobalDataManager] player].velocity;
    player = [[GlobalDataManager sharedGlobalDataManager] player];
    BOOL isPaused = [[GlobalDataManager sharedGlobalDataManager] isPaused];
    
    //if its still in the atmosphere (clouds)
    if ([backgroundOrder count] > 0) {
        //if the background top is at the bottom of the screen
        //if (bg1.position.y <= -bg1.contentSize.height/2) {
        if (bg1.position.y <= -bg1.contentSize.height) {
            NSString* name = [NSString stringWithFormat:@"%d.png", [[backgroundOrder objectAtIndex:0] intValue]];
            [backgroundOrder removeObjectAtIndex:0];
        
            [bg1 setTexture:[[CCSprite spriteWithFile:name]texture]];
            bg1.position = CGPointMake(bg2.contentSize.width/2, bg2.position.y + bg2.contentSize.height);
        }
        //else if (bg2.position.y <= -bg2.contentSize.height/2) {
        else if (bg2.position.y <= -bg2.contentSize.height) {
            NSString* name =[NSString stringWithFormat:@"%d.png",[[backgroundOrder objectAtIndex:0] intValue]];
            [backgroundOrder removeObjectAtIndex:0];
        
            [bg2 setTexture:[[CCSprite spriteWithFile:name]texture]];
            bg2.position = CGPointMake(bg2.contentSize.width/2, bg1.position.y + bg1.contentSize.height);
        }
    }
    //adds transition background
    //if ([backgroundOrder count] <= 0 && !didTransition && bg2.position.y <= -bg2.contentSize.height/2) {
    if ([backgroundOrder count] <= 0 && !didTransition && bg2.position.y <= -bg2.contentSize.height) {
        bgTransition = [CCSprite spriteWithFile:@"transition.png"];
        bgTransition.anchorPoint = CGPointMake(0.5, 0);
        //bgTransition.position = CGPointMake(bgTransition.contentSize.width/2, bgTransition.contentSize.height/4 + bg1.position.y + bg1.contentSize.height);
        bgTransition.position = CGPointMake(bgTransition.contentSize.width/2, bg1.position.y + bg1.contentSize.height);
        [self addChild:bgTransition z:-10];
        
        [bg2 setTexture:[[CCSprite spriteWithFile:@"stars.png"]texture]];
        //bg2.position = CGPointMake(bg2.contentSize.width/2, bgTransition.position.y + bgTransition.contentSize.height*3/4);
        bg2.position = CGPointMake(bg2.contentSize.width/2, bgTransition.position.y + bgTransition.contentSize.height);
            
        didTransition = YES;
    }
    
    //space!!!
    if (didTransition) {
        //if (bgTransition.isRunning && bgTransition.position.y <= -bgTransition.contentSize.height/2) {
        if (bgTransition.isRunning && bgTransition.position.y <= -bgTransition.contentSize.height) {
            [self removeChild:bgTransition];
        }
        
        //loops through stars backgrounds
        //if (!bgTransition.isRunning && bg1.position.y <= -bg1.contentSize.height/2) {
        if (!bgTransition.isRunning && bg1.position.y <= -bg1.contentSize.height) {
            //reset any flippin of x and y
            bg1.scaleX = 1;
            bg1.scaleY = 1;
            
            [bg1 setTexture:[[CCSprite spriteWithFile:@"stars.png"]texture]];
            
            //can flipX and/or flipY
            int rand = arc4random()%100 + 1;
            if (rand <= 25) {
                bg1.scaleX = -1;
            }
            else if (rand <= 50) {
                bg1.scaleY = -1;
            }
            else if (rand <= 75) {
                bg1.scaleY = -1;
                bg1.scaleX = -1;
            }
            
            bg1.position = CGPointMake(bg1.contentSize.width/2, bg2.position.y + bg2.contentSize.height);
        }
        //else if (!bgTransition.isRunning && bg2.position.y <= -bg2.contentSize.height/2) {
        else if (!bgTransition.isRunning && bg2.position.y <= -bg2.contentSize.height) {
            //reset any flippin of x and y
            bg2.scaleX = 1;
            bg2.scaleY = 1;

            [bg2 setTexture:[[CCSprite spriteWithFile:@"stars2.png"]texture]];
            
            //can flipX and/or flipY
            int rand = arc4random()%100 + 1;
            if (rand <= 25) {
                bg2.scaleX = -1;
            }
            else if (rand <= 50) {
                bg2.scaleY = -1;
            }
            else if (rand <= 75) {
                bg2.scaleY = -1;
                bg2.scaleX = -1;
            }

            
            bg2.position = CGPointMake(bg2.contentSize.width/2, bg1.position.y + bg1.contentSize.height);
        }
    }
    
    
    //update the cloud backgrounds
    if (bg1.isRunning && playerVelocity.y > 0 && player.position.y >= MAX_HEIGHT && !isPaused) {
        bg1.position = CGPointMake(bg1.position.x, bg1.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
    if (bg2.isRunning && playerVelocity.y > 0 && player.position.y >= MAX_HEIGHT && !isPaused) {
        bg2.position = CGPointMake(bg2.position.x, bg2.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
    if (bgTransition.isRunning && playerVelocity.y > 0 && player.position.y >= MAX_HEIGHT && !isPaused) {
        bgTransition.position = CGPointMake(bgTransition.position.x, bgTransition.position.y - backgroundScrollSpeed.y * (playerVelocity.y / MAX_VELOCITY));
    }
}


-(void) shake:(ccTime)delta{
    if (bgTransition.position.x < 0) {
        bgTransition.position = CGPointMake(bgTransition.position.x + 20, bgTransition.position.y);
    }
    else {
        bgTransition.position = CGPointMake(bgTransition.position.x - 20, bgTransition.position.y);
    }
}


-(void) updateScrollingSpeed:(ccTime)delta{
    if (!didTransition) {
        if (backgroundScrollSpeed.y > MIN_SCROLLING_SPEED_ATMOS && highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y -= 0.04;
            highestScoreChanged = scoreRaw;
        }
        else if(highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y = MIN_SCROLLING_SPEED_ATMOS;
        }
    }
    else {
        if (backgroundScrollSpeed.y > MIN_SCROLLING_SPEED_SPACE && highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y -= 0.003;
            highestScoreChanged = scoreRaw;
        }
        else if (highestScoreChanged != scoreRaw) {
            backgroundScrollSpeed.y = MIN_SCROLLING_SPEED_SPACE;
        }
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




- (void) dealloc
{
	//[super dealloc];
}
@end