//
//  Game.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Game.h"
#import "MainMenu.h"
#import "Background.h"
#import "GlobalDataManager.h"
#import "Obstacles.h"
#import "Player.h"
#import "PowerUp.h"
#import "Pause.h"
#import "GameEnded.h"


@implementation Game


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Game *layer = [Game node];
	[scene addChild: layer z:0 tag:GAME_LAYER_TAG];
    
    Background* background = [Background node];
    [scene addChild:background z:-1];
    
    [scene setTag:GAME_SCENE_TAG];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        //winSize = [[CCDirector sharedDirector] winSize];
        winSize = CGSizeMake(320, 480);    //screen size of 3.5" display
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        numObsPerScreen = 3.5;
        
        lastObsDeleted = 100;
        numObsAdded = 100;
        
        posBeforeFlip = winSizeActual.width * 2;
        
        //power up adding arrays init
        powerUpLow = [NSArray arrayWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:100], [NSNumber numberWithInt:150], [NSNumber numberWithInt:200], nil];
        
        powerUpHigh = [NSArray arrayWithObjects:[NSNumber numberWithInt:70], [NSNumber numberWithInt:120], [NSNumber numberWithInt:170], [NSNumber numberWithInt:220], nil];
        
        
        //after 10 power ups, use constant difference
        powerUpDifferenceLate = 160;   // 160 through 190
        
        //player init
        player = [Player player:@"Jeff.png"];
        player.position = ccp(winSize.width/2, player.contentSize.height/2);
        [self addChild:player z:1];
        [[GlobalDataManager sharedGlobalDataManager] setPlayer:player];
        
        //fuel init
        player.maxFuel = [[GlobalDataManager sharedGlobalDataManager] maxFuel];
        player.fuel = player.maxFuel;
        didAlreadyMakeFuelBarSmaller = YES;
        [self addFuelBar];
        
        //pause button init
        CCMenuItem* pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png" target:self selector:@selector(pause:)];
        pauseMenuItem.position = CGPointMake(winSizeActual.width/2 - pauseMenuItem.contentSize.width/2, winSizeActual.height/2 - pauseMenuItem.contentSize.height/2);
        
        CCMenu* pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        [self addChild:pauseMenu];
        [[GlobalDataManager sharedGlobalDataManager] setIsPaused:NO];
        
        //adds touches input.  begins update methods
        self.touchEnabled=YES;
        [self addFirstObs];
        [self schedule:@selector(constUpdate:)];
        //[self schedule:@selector(horizontalMovement:)];
        [self schedule:@selector(collisionDetection:)];
        [self schedule:@selector(accelerometerUpdate:)];
        [self schedule:@selector(whenToAddFuelCan:)];
        
        //[self schedule:@selector(invertedMagnet:)];
    }
	return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //dont move the player if the opacity layer is visible
    [self schedule:@selector(speedUpdate:)];
    [self unschedule:@selector(gravityUpdate:)];
    self.accelerometerEnabled = YES;
    
    if (!isGameRunning) {
        [self schedule:@selector(idlingjetpack:)];
    }
    isGameRunning = YES;
    
    CCLOG(@"touch began");
    return YES;
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [self removeChild:opacityLayer cleanup:NO];
    [self schedule:@selector(gravityUpdate:)];
    [self unschedule:@selector(speedUpdate:)];
    hasGameBegun = YES;
    CCLOG(@"touch ended");
}
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    float deceleration = 0.4f;
    float sensitivity = 6.0f;
    float maxVelocity = 200;
    
    player.velocity = CGPointMake(player.velocity.x * deceleration + acceleration.x * sensitivity, player.velocity.y);
    
    if(player.velocity.x> maxVelocity){
        player.velocity = CGPointMake(maxVelocity, player.velocity.y);
    }
    else if(player.velocity.x< -maxVelocity){
        player.velocity = CGPointMake(-maxVelocity, player.velocity.y);
    }
    
    
    //flips the player appropiately when player changes direction
    if ((previousAcc > 0 && acceleration.x < 0)  ||  (previousAcc < 0 && acceleration.x > 0)) {
        posBeforeFlip = player.position.x;
        didChangeLeftToRight = (previousAcc < 0 && acceleration.x > 0);
    }
    if (didChangeLeftToRight) {
        if (player.position.x >= posBeforeFlip + 6) {
            [player faceRight];
            posBeforeFlip = winSizeActual.width * 2;
        }
    }
    else {
        if (player.position.x <= posBeforeFlip - 6) {
            [player faceLeft];
            posBeforeFlip = winSizeActual.width * 2;
        }
    }
    
    previousAcc = acceleration.x;
}

//score and fall to bottom.  afterlife power up.  horiz obs movement call here
-(void) constUpdate:(ccTime)delta{
    if(player.position.y - player.contentSize.height/2> highestPlayerPosition){
        highestPlayerPosition = player.position.y - player.contentSize.height/2;
    }
    //score
    scoreRaw = (highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER;
    [[GlobalDataManager sharedGlobalDataManager] setScoreRaw:scoreRaw];
    
    if (player.isDoublePointsEnabled) {
        scoreActual = (highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER;
    }
    scoreActual = ((highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER);
    [[GlobalDataManager sharedGlobalDataManager] setScoreActual:scoreActual];
    
    //fall to bottom
    if(player.position.y < -player.contentSize.height){
        //do falling to bottom stuff bere
        [self schedule:@selector(playerFellToBottom:)];
        [self unschedule:@selector(constUpdate:)];
    }
    
    //horizontal movement
    Obstacles* obs;
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        obs = (Obstacles*)[self getChildByTag:i];
        //if the obstacle is a horizontal moving one call the horizontal movement method
        if ([obs.type isEqualToString:@"horizontal obstacle"]) {
            [self horizontalMovement:obs];
        }
    }
    
    if ([[GlobalDataManager sharedGlobalDataManager] fuel] == 0) {
        CCLOG(@"score: %d", scoreRaw);
    }
}

//makes the player and flame accelerate.  fuel stuff here. flame update
-(void) speedUpdate:(ccTime)delta{
    if (player.velocity.y >= MAX_VELOCITY) {
        player.velocity = CGPointMake(player.velocity.x, MAX_VELOCITY);
    }
    else {
        //updates the velocity and acceleration
        player.acceleration = CGPointMake(0, 0.15);
        player.velocity = CGPointMake(player.velocity.x, player.velocity.y + player.acceleration.y);
    }
    
    //1/17 = 0 ****
    //player.fuel -= ((((1/17) * velocity.y * velocity.y + 2) / (2.5)) - FUEL_IDLING_CONSTANT);
    //player.fuel -= ((((1/19.0) * powf(velocity.y, 1.07))) - FUEL_IDLING_CONSTANT);
    
    [[GlobalDataManager sharedGlobalDataManager]setFuel:player.fuel];
    
    //updates the players position
    CGPoint pos = player.position;
    pos.y += player.velocity.y;
    player.position = pos;
    
    //moves objects and keeps the player centered on screen
    if(player.position.y >= winSizeActual.height / 3){
        player.position = ccp(player.position.x, winSizeActual.height / 3);
        
        Obstacles* obs;
        
        //updates the obstacles and coins. they are all tagged with numObsAdded
        for (int i=lastObsDeleted; i<=numObsAdded; i++) {
            obs = (Obstacles*)[self getChildByTag:i];
            
            CGPoint posObs = obs.position;
            posObs.y -= player.velocity.y;
            obs.position = posObs;
        }
        
        //updates the first obs
        if (firstObs.position.y < 0) {
            CGPoint posObs = firstObs.position;
            posObs.y -= player.velocity.y;
            firstObs.position = posObs;
        }
        
        
        //updates any and all power ups
        if (invy.isLooking) {
            CGPoint posPow = invy.position;
            posPow.y -= player.velocity.y;
            invy.position = posPow;
        }
        if (boost.isLooking) {
            CGPoint posPow = boost.position;
            posPow.y -= player.velocity.y;
            boost.position = posPow;
        }
        if (doublePoints.isLooking) {
            CGPoint posPow = doublePoints.position;
            posPow.y -= player.velocity.y;
            doublePoints.position = posPow;
        }
        if (fuelCan.isLooking) {
            CGPoint posPow = fuelCan.position;
            posPow.y -= player.velocity.y;
            fuelCan.position = posPow;
        }
    }
    
    //fuel
    NSString* fuelText = [NSString stringWithFormat:@"%i",(int)player.fuel];
    fuelLabel.string = fuelText;
    //if fuel runs out stop all touches and make the player fall
    if(player.fuel <= 0){
        //self.isTouchEnabled = NO;
        //[self unschedule:@selector(speedUpdate:)];
        
        //todo: player ran out of fuel
        //may want to make it so that the jetpack gives 3 bursts of fuel after running out
    }
    
    //give all classes access to velocity in y direction (by accessing player)
    [[GlobalDataManager sharedGlobalDataManager] setPlayer:player];
}

//makes the player fall
-(void) gravityUpdate:(ccTime)delta{
    //use a gravity velocity that "feels good" for your app
    player.acceleration = CGPointMake(0, -0.1125);
    
    //update velocity with gravitational influence
    player.velocity = CGPointMake(player.velocity.x, player.velocity.y + player.acceleration.y);
    
    // update sprite position with velocity
    CGPoint pos = player.position;
    pos.y += player.velocity.y;
    player.position = pos;
    
    if (player.velocity.y > 0) {
        player.fuel += FUEL_IDLING_CONSTANT/5;
    }
    
    //moves objects and keeps the player centered on screen
    if(player.position.y >= winSizeActual.height / 3){
        if(player.velocity.y >= 0){
            player.position = ccp(player.position.x, winSizeActual.height / 3);
            
            //updates the obstacles and coins. they are all tagged with numObsAdded
            for (int i=lastObsDeleted; i<=numObsAdded; i++) {
                Obstacles* obs = (Obstacles*)[self getChildByTag:i];
                
                CGPoint posObs = obs.position;
                posObs.y -= player.velocity.y;
                obs.position = posObs;
            }
            
            //updates the first obs
            if (firstObs.position.y < 0) {
                CGPoint posObs = firstObs.position;
                posObs.y -= player.velocity.y;
                firstObs.position = posObs;
            }
            
            
            //updates any and all power ups
            if (invy.isLooking) {
                CGPoint posPow = invy.position;
                posPow.y -= player.velocity.y;
                invy.position = posPow;
            }
            if (boost.isLooking) {
                CGPoint posPow = boost.position;
                posPow.y -= player.velocity.y;
                boost.position = posPow;
            }
            if (doublePoints.isLooking) {
                CGPoint posPow = doublePoints.position;
                posPow.y -= player.velocity.y;
                doublePoints.position = posPow;
            }
            if (fuelCan.isLooking) {
                CGPoint posPow = fuelCan.position;
                posPow.y -= player.velocity.y;
                fuelCan.position = posPow;
            }
            
        }
    }
    
    //give all classes access to velocity in y direction (by accessing player)
    [[GlobalDataManager sharedGlobalDataManager] setPlayer:player];
}

//fuel idling
-(void) idlingjetpack:(ccTime)delta{
    if (player.velocity.y > 0) {
        player.fuel -= FUEL_IDLING_CONSTANT;
    }
    else {
        player.fuel -= FUEL_IDLING_CONSTANT/3;
    }
        
    //player.fuel -= FUEL_IDLING_CONSTANT;
    [[GlobalDataManager sharedGlobalDataManager] setFuel:(int)player.fuel];
}

-(void) accelerometerUpdate:(ccTime)delta{
    CGPoint pos = player.position;
    pos.x += player.velocity.x;
    
    float halfWidthImage = player.contentSize.width * 0.5f;
    float leftBorderLimit = halfWidthImage;
    float rightBorderLimit = winSizeActual.width;
    
    if(pos.x < leftBorderLimit){
        pos.x = rightBorderLimit;
    }
    else if(pos.x > rightBorderLimit){
        pos.x = leftBorderLimit;
    }
    
    player.position = pos;
}


-(void) addObs:(ccTime)delta{
    //add new obstacles when the last one added is at twice the screen height
    if(lastObsAdded.position.y <= winSize.height * 2){
        if (scoreRaw > 5 && !added) {
            [self addObsOnEdges];
            added = YES;
            return;
        }
        
        Obstacles* obs = [Obstacles obstacle:@"obsticle.png"];
        [obs setType:@"obstacle"];
        
        int randomXPosition = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        
        int randomYPosition = arc4random() % 8;
        
        obs.position = ccp(randomXPosition, (winSize.height * 2 + randomYPosition + winSize.height / numObsPerScreen));
        
        [self addChild: obs z:0 tag:numObsAdded];
        
        lastObsAdded = obs;
        numObsAdded++;
        
        //[self addNarrowingObs];
        
        numObsPerScreen += 0.007;
        if (numObsPerScreen > MAX_OBS_PER_SCREEN) {
            numObsPerScreen = MAX_OBS_PER_SCREEN;
        }
    }
}
-(void) addFirstObs{
    firstObs = [Obstacles obstacle:@"obsticle.png"];
    [firstObs setType:@"obstacle"];
    
    int randomXPosition = arc4random() % (int)(winSize.width - firstObs.contentSize.width) + firstObs.contentSize.width/2;
    int randomYPosition = (arc4random() % 8 + (winSize.height/numObsPerScreen));
    
    firstObs.position = ccp(randomXPosition, randomYPosition + winSize.height * 0.6);
    [self addChild:firstObs z:0 tag:numObsAdded];
    
    diffFirstObsAnd0 = firstObs.position.y;
    numObsAdded++;
    
    for(int i=2; i<21; i++){
        Obstacles* obs = [Obstacles obstacle:@"obsticle.png"];
        [obs setType:@"obstacle"];
        
        int randomXPosition = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        
        int randomYPosition = (arc4random() % 8 + (winSize.height/4));
        
        obs.position = ccp(randomXPosition, (i * randomYPosition) + winSize.height * 0.75);
        [self addChild: obs z:0 tag:numObsAdded];
        
        lastObsAdded = obs;
        numObsAdded++;
    }
    [self schedule:@selector(addObs:)];
    [self schedule:@selector(cleanUpObs:)];

    //[self addNarrowingObs];
}
-(void) cleanUpObs:(ccTime)delta{
    Obstacles* temp;
    //loops from the number of the last obs deleted to the most recently added obs
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        //never remove the first obs. it is needed for keeping the score
        if(i == 100){
            if (i+1 < numObsAdded) {
                i++;
            }
            else {
                i++;
                break;
            }
        }
        
        temp = (Obstacles*)[self getChildByTag:i];
        
        //if the lowest i value possible is the same as the lowest obs and it's already been removed, increment lastObsDeleted
        int last = lastObsDeleted;
        if (lastObsDeleted == 100) {
            last++;
        }
        if (temp == nil && i == last) {
            lastObsDeleted++;
            break;
        }
        
        if(temp.position.y <= 0 - temp.contentSize.height && temp != nil){
            [self removeChildByTag:i cleanup:NO];
            //lastObsDeleted = i + 1;
            CCLOG(@"removed obs at: %i", i);
        }
        temp = nil;
    }
}



//horizontal movement stuff.  this method is called with one obstacle as the parameter
-(void) horizontalMovement:(Obstacles*)spr{
    NSAssert([spr.type isEqualToString:@"horizontal obstacle"], @"Obstacle is not a horizontal moving obstacle");
    
    if (spr.position.x >= winSize.width - spr.contentSize.width/2 || spr.position.x <= spr.contentSize.width/2) {
        [spr setSpeed: (spr.speed * -1)];
    }
    horizontalVelocity = CGPointMake(spr.speed, 0);
    
    CGPoint pos = spr.position;
    pos.x += horizontalVelocity.x;
    spr.position = pos;
}

-(void) makeHorizontalObs:(Obstacles*) obs{
    [obs setType:@"horizontal obstacle"];
    [obs setSpeed:2.0];
}

-(void) addNarrowingObs{
    for (int i = 0; i < 6; i++) {
        Obstacles* obs1 = [Obstacles obstacle:@"obsticle.png"];
        [obs1 setType:@"special obstacle 1"];
        Obstacles* obs2 = [Obstacles obstacle:@"obsticle.png"];
        [obs2 setType:@"special obstacle 1"];
        
        int xPos = obs1.contentSize.width/5 * (i + 1) + obs1.contentSize.width * (1.5/5.0);
        int yPos = winSize.height * 2 + (i + 1) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
        
        obs1.position = CGPointMake(xPos, yPos);
        obs2.position = CGPointMake(winSize.width - xPos, yPos);
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        
        lastObsAdded = obs1;
    }
}

-(void) addPathedObs{
    //add the obstacles to make the player fall into the
    for (int i = 0; i < 3; i++) {
        Obstacles* obs1 = [Obstacles obstacle:@"obsticle.png"];
        [obs1 setType:@"special obstacle 1"];
        Obstacles* obs2 = [Obstacles obstacle:@"obsticle.png"];
        [obs2 setType:@"special obstacle 1"];
        
        int xPos = obs1.contentSize.width/3 * (i + 1);
        int yPos = winSize.height * 2 + (i + 1) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
        
        obs1.position = CGPointMake(xPos, yPos);
        obs2.position = CGPointMake(winSize.width - xPos, yPos);
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        lastObsAdded = obs1;
    }
    
    BOOL isMovingLeft = YES;
    //make the path to follow
    for (int i = 0; i < 26; i++) {
        Obstacles* obs1 = [Obstacles obstacle:@"obsticle.png"];
        [obs1 setType:@"obstacle"];
        Obstacles* obs2 = [Obstacles obstacle:@"obsticle.png"];
        [obs2 setType:@"obstacle"];
        
        int width = winSize.width / 3.1 + obs1.contentSize.width;
        
        int xPos;
        if (isMovingLeft) {
            xPos = lastObsAdded.position.x - winSize.width/15;
            
            if (xPos < obs1.contentSize.width/2 + winSize.width/15) {
                isMovingLeft = NO;
            }
        }
        else {
            xPos = lastObsAdded.position.x + winSize.width/15;
            
            if (xPos > winSize.width - width - obs1.contentSize.width) {
                isMovingLeft = YES;
            }
        }
        
        //                              add 3 from last for loop
        int yPos = winSize.height * 2 + (i + 1 + 3) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
        
        obs1.position = CGPointMake(xPos, yPos);
        obs2.position = CGPointMake(width + xPos, yPos);
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        
        lastObsAdded = obs1;
    }
}

-(void) addEdgeToEdgeObs:(BOOL)isLeft{
    if (isLeft) {
        for (int i = 0; i < 10; i++) {
            Obstacles* obs = [Obstacles obstacle:@"obsticle.png"];
            obs.type = @"special obstacle 2";
            
            int x = obs.contentSize.width/2 + (i+1)*(winSize.width - obs.contentSize.width)/10;
            int y = winSize.height * 2 + (i+1)*(winSize.height/10);
            
            obs.position = CGPointMake(x, y);
            
            [self addChild:obs z:0 tag:numObsAdded];
            numObsAdded++;
            lastObsAdded = obs;
        }
    }
    else {
        for (int i = 0; i < 10; i++) {
            Obstacles* obs = [Obstacles obstacle:@"obsticle.png"];
            obs.type = @"special obstacle 2";
            
            int x = winSize.width - (obs.contentSize.width/2 + (i+1)*(winSize.width - obs.contentSize.width)/10);
            int y = winSize.height * 2 + (i+1)*(winSize.height/10);
            
            obs.position = CGPointMake(x, y);
            
            [self addChild:obs z:0 tag:numObsAdded];
            numObsAdded++;
            lastObsAdded = obs;
        }
    }
}

-(void) addObsOnEdges{
    for (int i = 0; i < 24; i++) {
        Obstacles* obsLeft = [Obstacles obstacle:@"obsticle.png"];
        Obstacles* obsRight = [Obstacles obstacle:@"obsticle.png"];
        obsLeft.type = @"special obstacle 3";
        obsRight.type = @"special obstacle 3";
        
        obsLeft.opacity = 150;
        obsRight.opacity = 150;
        
        obsLeft.position  = CGPointMake(obsLeft.contentSize.width/2, winSize.height*2 + (i+1)*winSize.height/8);
        obsRight.position = CGPointMake(winSize.width - obsRight.contentSize.width/2, winSize.height*2 + (i+1)*winSize.height/8);
        
        [self addChild:obsLeft z:0 tag:numObsAdded];
        numObsAdded++;
        
        //adds obs to the middle of screen
        if ((i + 1 + 4) % 8 == 0) {
            Obstacles* obsMid = [Obstacles obstacle:@"obsticle.png"];
            obsMid.type = @"obstacle";
            
            obsMid.position = CGPointMake(winSize.width/2 , winSize.height*2 + (i+1)*winSize.height/8);
            
            [self addChild:obsMid z:0 tag:numObsAdded];
            numObsAdded++;
        }
        //makes the sides come out farther
        else if ((i + 1) % 8 == 0) {
            //todo: switch obsleft and obsright with larger obs
        }
        
        
        [self addChild:obsRight z:0 tag:numObsAdded];
        numObsAdded++;
        
        lastObsAdded = obsRight;
    }
}

-(void) addOneOpening:(int)loc{
    Obstacles* obs1 = [Obstacles obstacle:@"obsticle.png"];
    obs1.type = @"special obstacle 4";
    Obstacles* obs2 = [Obstacles obstacle:@"obsticle.png"];
    obs2.type = @"special obstacle 4";
    Obstacles* obs3 = [Obstacles obstacle:@"obsticle.png"]; //make to be the smaller one
    obs3.type = @"special obstacle 4";
    Obstacles* obs4 = [Obstacles obstacle:@"obsticle.png"]; //make to be larger one. todo:
    obs4.type = @"special obstacle 4";
    
    
    
}



-(void) addCoins{
    //first unschedule the add obs update
    [self unschedule:@selector(addObs:)];
    
    int numCoinsToAdd = 10;
    
    //determines which pattern the coins should be added in
    int rand = arc4random() % 3 + 1;
    rand = 1;
    if (rand == 1) {
        for (int i=0; i<numCoinsToAdd; i++) {
            Obstacles* coin = [Obstacles obstacle:@"coin.png"];
            [coin setType:@"coin"];
            int x = winSize.width/2;
            int y = lastObsAdded.position.y + winSize.height/5;
            
            //adds coin to middle of screen and one fifth the screen size
            coin.position = ccp(x,y);
            
            [self addChild:coin z:0 tag:numObsAdded];
            lastObsAdded = coin;
            //number of coins is odd. so always add 2
            numObsAdded++;
        }
    }
    else if (rand == 2) {
        
    }
    else {
        
    }
    //schedule the add obs update after adding coins to screen
    [self schedule:@selector(addObs:)];
}

-(void) addBoost:(Obstacles*)obs{
    boost = [PowerUp powerUp:@"Boost.png"];
    boost.type = @"Boost";
    boost.isLooking = YES;
    
    boost.position = obs.position;
    
    obs.visible = NO;
    obs.position = CGPointMake(winSize.width * 2, obs.position.y);
    [self addChild:boost];
    
    [self schedule:@selector(collideWithBoost:)];
}
-(void) collideWithBoost:(ccTime)delta{
    boost.isLooking = YES;
    //do the sprites intersect
    if (CGRectIntersectsRect([player getRect], [boost getRect])) {
        CCLOG(@"COLLISION WITH BOOST!!!");
        
        //do boostly things
        player.isBoostingEnabled = YES;
        
        //stop the player from moving up/down anymore
        [self unschedule:@selector(speedUpdate:)];
        [self unschedule:@selector(gravityUpdate:)];
        
        //no more touches can occur
        self.touchEnabled = NO;
        
        //call a boost method to shoot up the player
        [self schedule:@selector(boostUp:)];
        
        //stop detecting colisions
        [self unschedule:@selector(collisionDetection:)];
        
        //add power up bar
        [self addPowerUpBar:boost];
        
        [self removeChild:boost cleanup:NO];
        [self unschedule:@selector(collideWithBoost:)];
        
        boost.isLooking = NO;
    }
    if (boost.position.y < 0-boost.contentSize.height/2) {
        [self removeChild:boost cleanup:NO];
        [self unschedule:@selector(collideWithBoost:)];
        
        boost.isLooking = NO;
    }
}
-(void) boostUp:(ccTime)delta{
    //this number is divided by 60 (number of calls per second)
    if (numSecondsPowerUp >= 300) {
        numSecondsPowerUp = 0;
        player.isBoostingEnabled = NO;
        self.touchEnabled = YES;
        [self schedule:@selector(collisionDetection:)];
        [self schedule:@selector(gravityUpdate:)];
        [self unschedule:@selector(boostUp:)];
        return;
    }
    if (player.velocity.y >= 9) {
        player.velocity = CGPointMake(player.velocity.x, 9);
    }
    if (player.position.y >= winSize.height/2) {
        player.position = ccp(player.position.x, winSize.height/2);
        Obstacles* obs;
        
        //updates the obstacles and coins. they are all tagged with numObsAdded
        for (int i=lastObsDeleted; i<=numObsAdded; i++) {
            obs = (Obstacles*)[self getChildByTag:i];
            
            CGPoint posObs = obs.position;
            posObs.y -= player.velocity.y;
            obs.position = posObs;
        }
        
        //updates the first obs
        CGPoint posObs = firstObs.position;
        posObs.y -= player.velocity.y;
        firstObs.position = posObs;
    }
    
    player.acceleration = CGPointMake(0, 0.4);
    player.velocity = CGPointMake(player.velocity.x, player.velocity.y + player.acceleration.y);
    CGPoint pos = player.position;
    pos.y += player.velocity.y;
    player.position = pos;
    
    numSecondsPowerUp++;
}


-(void) addInvy:(Obstacles*)obs{
    invy = [PowerUp powerUp:@"Invincibility.png"];
    invy.type = @"Invy";
    invy.isLooking = YES;
    
    invy.position = obs.position;
    
    obs.visible = NO;
    obs.position = CGPointMake(winSize.width * 2, obs.position.y);
    [self addChild:invy];
    
    [self schedule:@selector(collideWithInvy:)];
    
}
-(void) collideWithInvy:(ccTime)delta{
    invy.isLooking = YES;
    if (CGRectIntersectsRect([player getRect], [invy getRect])) {
        CCLOG(@"COLLISION WITH INVY!!!");
        
        //do invincibilityly things
        player.isInvyEnabled = YES;
        
        //stop collision detection
        [self unschedule:@selector(collisionDetection:)];
        
        //add power up bar
        [self addPowerUpBar:invy];
        
        [self removeChild:invy cleanup:NO];
        [self schedule:@selector(invy:)];
        [self unschedule:@selector(collideWithInvy:)];
        
        invy.isLooking = NO;
    }
    if (invy.position.y < 0-invy.contentSize.height/2) {
        [self removeChild:invy cleanup:NO];
        [self unschedule:@selector(collideWithInvy:)];
        
        invy.isLooking = NO;
    }
}
//will want to make the player fade in/out to make it seem like he's invincible
-(void) invy:(ccTime)delta{
    if (numSecondsPowerUp >= 300 && player.opacity >= 255) {
        numSecondsPowerUp = 0;
        player.isInvyEnabled = NO;
        player.isFading = NO;
        [self schedule:@selector(collisionDetection:)];
        [self unschedule:@selector(invy:)];
        return;
    }
    if (player.isFading) {
        player.opacity -= 3;
        if (player.opacity <= 0) {
            player.opacity = 0;
            player.isFading = NO;
        }
    }
    else {
        player.opacity += 3;
        if (player.opacity >= 255) {
            player.opacity = 225;
            player.isFading = YES;
        }
    }
    numSecondsPowerUp++;
}


-(void) addDoublePoints:(Obstacles*)obs{
    doublePoints = [PowerUp powerUp:@"DoublePoints.png"];
    doublePoints.type = @"Double Points";
    doublePoints.isLooking = YES;
    
    doublePoints.position = obs.position;
    
    obs.visible = NO;
    obs.position = CGPointMake(winSize.width * 2, obs.position.y);
    [self addChild:doublePoints];
    
    [self schedule:@selector(collideWithDoublePoints:)];
}
-(void) collideWithDoublePoints:(ccTime)delta{
    doublePoints.isLooking = YES;
    if (CGRectIntersectsRect([player getRect], [doublePoints getRect])) {
        CCLOG(@"COLLISION WITH DOUBLE POINTS!!!");
        
        //do double pointsly things
        player.isDoublePointsEnabled = YES;
        
        //add power up bar
        [self addPowerUpBar:doublePoints];
        
        [self removeChild:doublePoints cleanup:NO];
        [self schedule:@selector(doublePoints:)];
        [self unschedule:@selector(collideWithDoublePoints:)];
        
        doublePoints.isLooking = NO;
    }
    if (doublePoints.position.y < 0-doublePoints.contentSize.height/2) {
        [self removeChild:doublePoints cleanup:NO];
        [self unschedule:@selector(collideWithDoublePoints:)];
        
        doublePoints.isLooking = NO;
    }
}
-(void) doublePoints:(ccTime)delta{
    if (numSecondsPowerUp >= 300) {
        numSecondsPowerUp = 0;
        player.isDoublePointsEnabled = NO;
        [self unschedule:@selector(doublePoints:)];
        return;
    }
    numSecondsPowerUp++;
}

-(void) addFuelCan:(Obstacles*)obs{
    fuelCan = [PowerUp powerUp:@"Fuel-tank.png"];
    fuelCan.type = @"Fuel Can";
    fuelCan.isLooking = YES;
    
    //if its supposed to be added to an obstacle that's narrowing or pathed
    if ([obs.type isEqualToString:@"special obstacle 1"]) {
        Obstacles* obs2 = (Obstacles*)[self getChildByTag:obs.tag+1];
        
        float x = obs2.position.x - lastObsAdded.position.x;
        
        fuelCan.position = CGPointMake(x, obs.position.y);
        [self addChild:fuelCan];
    }
    //if its supposed to be added to an obstacle that's moving from edge to edge
    else if ([obs.type isEqualToString:@"special obstacle 2"]) {
        if (obs.position.x > winSize.width/2) {
            int x = obs.position.x - winSize.width/4 - obs.contentSize.width/2;
            
            fuelCan.position = CGPointMake(x, obs.position.y);
            [self addChild:fuelCan];
        }
        else {
            int x = obs.position.x + winSize.width/4 + obs.contentSize.width/2;
            
            fuelCan.position = CGPointMake(x, obs.position.y);
            [self addChild:fuelCan];
        }
    }
    //untested
    else if ([obs.type isEqualToString:@"Boost"] || [obs.type isEqualToString:@"Invy"] || [obs.type isEqualToString:@"Double Points"]) {
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag-1];
        
        if ([last.type isEqualToString:@"obstacle"] || [last.type isEqualToString:@"coin"]) {
            fuelCan.position = last.position;
            
            last.visible = NO;
            last.position = CGPointMake(winSize.width * 2, obs.position.y);
            [self addChild:fuelCan];
        }
        last = (Obstacles*)[self getChildByTag:obs.tag+1];
        if (last != nil && ([last.type isEqualToString:@"obstacle"] || [last.type isEqualToString:@"coin"])) {
            fuelCan.position = last.position;
            
            last.visible = NO;
            last.position = CGPointMake(winSize.width * 2, obs.position.y);
            [self addChild:fuelCan];
        }
        else {
            Obstacles* o = [Obstacles obstacle:@"obsticle.png"];
            o.type = @"obstacle";
            
            int x = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
            o.position = CGPointMake(x, obs.position.y + winSize.height/numObsPerScreen);
            
            [self addChild:o z:0 tag:numObsAdded];
            numObsAdded++;
            last = o;
            
            fuelCan.position = o.position;
            
            last.visible = NO;
            last.position = CGPointMake(winSize.width * 2, obs.position.y);

            [self addChild:fuelCan];
        }
    }
    //if its supposed to be added too obs on the edges w/ obs in middle
    else if ([obs.type isEqualToString:@"special obstacle 3"]) {
        Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag-1];

        if ([next.type isEqualToString:@"obstacle"] || [last.type isEqualToString:@"obstacle"]) {
            [self addFuelCan:next];
            return;
        }
        
        fuelCan.position = CGPointMake(winSize.width/2, obs.position.y);
        [self addChild:fuelCan];
    }
    //randomly placed obs, coin
    else {
        fuelCan.position = obs.position;
    
        obs.visible = NO;
        obs.position = CGPointMake(winSizeActual.width * 2, obs.position.y);
        [self addChild:fuelCan];
    }
    
    [self schedule:@selector(collideWithFuelCan:)];
}
-(void) collideWithFuelCan:(ccTime)delta{
    if (CGRectIntersectsRect([player getRect], [fuelCan getRect])) {
        CCLOG(@"COLLISION WITH FUEL CAN!!!");
        CCLOG(@"%i", (int)player.fuel);
        
        //do fuel canly things
        [self removeChild:fuelCan cleanup:NO];
        fuelCan.isLooking = NO;
        [self addFuel];
        [self unschedule:@selector(collideWithFuelCan:)];
    }
    if (fuelCan.position.y < -fuelCan.contentSize.height/2) {
        [self removeChild:fuelCan cleanup:NO];
        fuelCan.isLooking = NO;
        [self unschedule:@selector(collideWithFuelCan:)];
    }
}
-(void) addFuel{
    //top off the fuel tank
    player.fuel = player.maxFuel;
    innerFuelBar.position = CGPointMake(winSize.width - innerFuelBar.contentSize.width/2 - 3, innerFuelBar.contentSize.height/2 + 3);
}

-(void) whenToAddFuelCan:(ccTime)delta{
    int locToAdd = (90 + (25 * (numFuelCansAddedAfterDoubled + 1))) / FUEL_CONSTANT + previousFuelCanLoc;
    
    //if the fuel can is supposed to be added higher than the max it can be added
    if (numFuelCansAddedAfterDoubled + 1 >= FUEL_CANS_BEFORE_MAX) {
        locToAdd = (100 + (25 * FUEL_CANS_BEFORE_MAX)) / FUEL_CONSTANT + previousFuelCanLoc; //test this
    }
    
    //if fuel can should be added at a score of less than or equal to 2 screen sizes higher
    if (locToAdd <= scoreRaw + winSize.height * 2 / SCORE_MODIFIER) {
        Obstacles* best = (Obstacles*)[self getChildByTag:lastObsDeleted];
        for (int i = lastObsDeleted + 1; i < numObsAdded; i++) {
            Obstacles* temp = (Obstacles*)[self getChildByTag:i];
            
            if (abs(locToAdd - (int)(temp.position.y / SCORE_MODIFIER) - scoreRaw) < abs(locToAdd - (int)(best.position.y / SCORE_MODIFIER) - scoreRaw)) {
                best = temp;
            }
        }
        [self addFuelCan:best];
        numFuelCansAddedAfterDoubled++;
        previousFuelCanLoc = scoreRaw + best.position.y / SCORE_MODIFIER;
    }
}

-(void) addPowerUp:(ccTime)delta{
    int min = [[powerUpLow objectAtIndex:numPowerUpsAdded] intValue];
    int max = [[powerUpHigh objectAtIndex:numPowerUpsAdded] intValue];
    
    Obstacles* obs = (Obstacles*)[self getChildByTag:numObsAdded-1];
    int highestObsPos = (int)obs.position.y;
    
    if (highestObsPos / SCORE_MODIFIER + scoreRaw >= min && highestObsPos / SCORE_MODIFIER + scoreRaw <= max) {
        int rand = arc4random() % 1000;
        
        if ([self isLookingForAnyPowerUpOrEnabled]) {
            numPowerUpsAdded++;
            CCLOG(@"Already looking for power up or one is enabled");
            return;
        }
        
        if (rand <= 250) {
            [self addBoost:obs];
        }
        else if (rand <= 650) {
            [self addDoublePoints:obs];
        }
        else {
            [self addInvy:obs];
        }
        numPowerUpsAdded++;
        CCLOG(@"added power up");
    }
}
-(BOOL) isLookingForAnyPowerUpOrEnabled{
    return invy.isLooking || invy.isEnabled || boost.isEnabled || boost.isLooking || doublePoints.isLooking || doublePoints.isEnabled;
}


//the player hit an obstacle
-(void) playerHitObs{
    self.touchEnabled = NO;
    self.accelerometerEnabled = NO;
    [self unschedule:@selector(collisionDetection:)];
    [self unschedule:@selector(speedUpdate:)];
    player.velocity = CGPointMake(player.velocity.x, -player.velocity.y/2);
    [self schedule:@selector(gravityUpdate:)];
    [self unschedulePowerUpLookers];
    
    //make ending animation of player falling to the bottom
    [self schedule:@selector(playerFellToBottom:)];
    [self unschedule:@selector(constUpdate:)];
}
-(void) playerFellToBottom:(ccTime)delta{
    if (player.position.y < -player.contentSize.height/2) {
        self.touchEnabled = NO;
        self.accelerometerEnabled = NO;
        player.velocity = CGPointMake(0, player.velocity.y);
        
        [self unschedule:@selector(gravityUpdate:)];
        [self unschedule:@selector(playerFellToBottom:)];
        
        if (numContinuesUsed < 1) {
            [self continueGame];
        }
        else {
            [self gameEnded];
            [[CCDirector sharedDirector] replaceScene:[GameEnded scene]];
        }
    }
    //keep horizontal moving obs moving horizontally
    Obstacles* obs;
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        obs = (Obstacles*)[self getChildByTag:i];
        
        //if the obstacle is a horizontal moving one call the horizontal movement method
        if ([obs.type isEqualToString:@"horizontal obstacle"]) {
            [self horizontalMovement:obs];
        }
    }
}
-(void) continueGame{
    CCMenuItem* continueGame = [CCMenuItemImage itemWithNormalImage:@"Stats.png" selectedImage:@"Stats.png" target:self selector:@selector(doContinue:)];
    continueMenu = [CCMenu menuWithItems:continueGame, nil];
    [self addChild:continueMenu];
    
    self.touchEnabled = NO;
    
    [self unschedule:@selector(idlingjetpack:)];
}
//will need timer for how long this is shown for
-(void) doContinue:(id)sender{
    if ([GlobalDataManager sharedGlobalDataManager].numContinues > 0) {
        //reset the players position
        player.position = CGPointMake(winSize.width/2, player.contentSize.height/2);
        
        //set game to original state
        [self schedule:@selector(collisionDetection:)];
        [self schedule:@selector(constUpdate:)];
        player.velocity = CGPointMake(0, 0);
        self.touchEnabled = YES;
        [self schedulePowerUpLookers];
        
        //add to continues used and subtract one from numContinues
        numContinuesUsed++;
        [[GlobalDataManager sharedGlobalDataManager] setNumContinues:[GlobalDataManager sharedGlobalDataManager].numContinues - 1];
        
        //reset hasgamebegun
        hasGameBegun = NO;
        
        isGameRunning = NO;
        
        [self removeChild:continueMenu cleanup:NO];
    }
    else {
        [self gameEnded];
        //todo: send user to in app purchase of continue coins
        [[CCDirector sharedDirector] replaceScene: [GameEnded scene]];
    }
}

-(void)unschedulePowerUpLookers{
    if (doublePoints.isLooking) {
        [self unschedule:@selector(collideWithDoublePoints:)];
    }
    if (boost.isLooking) {
        [self unschedule:@selector(collideWithBoost:)];
    }
    if (invy.isLooking) {
        [self unschedule:@selector(collideWithInvy:)];
    }
}
-(void)schedulePowerUpLookers{
    if (doublePoints.isLooking) {
        [self schedule:@selector(collideWithDoublePoints:)];
    }
    if (boost.isLooking) {
        [self schedule:@selector(collideWithBoost:)];
    }
    if (invy.isLooking) {
        [self schedule:@selector(collideWithInvy:)];
    }
}

//game ended stuff
-(void) gameEnded{
    //add to the total number of coins
    int totalCoins = [GlobalDataManager sharedGlobalDataManager].totalCoins + numCoins;
    [[GlobalDataManager sharedGlobalDataManager] setTotalCoins:totalCoins];
    
    //reset fuel
    [[GlobalDataManager sharedGlobalDataManager] setFuel:player.maxFuel];
    
    [self isHighScore];
    
}
//is the score received on the just finished game the highest
-(void) isHighScore{
    if (scoreActual > [GlobalDataManager sharedGlobalDataManager].highScore) {
        [[GlobalDataManager sharedGlobalDataManager] setHighScore:scoreActual];
    }
}


//collision detection.  should maybe detect collisions with his head and feet, not all the white space around the player
-(void) collisionDetection:(ccTime)delta{
    //collision detection for obstacles
    Obstacles* temp;
    
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        temp = (Obstacles*)[self getChildByTag:i];
        
        if (CGRectIntersectsRect([player getRect], [temp getRect])) {
            //COLLISION!!!!!!!
            //find out what the player collided with
            if (([temp.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound)  &&  (player.velocity.y > 0 || player.velocity.y <= -4)) {
                //if statement: if its a obstacle and the player is moving up (i.e. hit the bottom) or the player is comimg crashing down on an obsacle. Then he loses.
                
                //[self playerHitObs];
            }
            else if ([temp.type isEqualToString:@"coin"]) {
                CCLOG(@"COLLISION WITH COIN: %i,",i);
                //add to the coins count
                numCoins++;
                [[GlobalDataManager sharedGlobalDataManager] setNumCoins:numCoins];
                
                //position the coin outside of the viewing window and make it not visible
                [temp setVisible:NO];
                temp.position = CGPointMake(winSize.width * 2, temp.position.y);
            }
            else if (CGRectIntersectsRect([player feetRect], [temp getRect])  &&  ([temp.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound)  &&  (player.velocity.y <= 0 && player.velocity.y > -4)) {
                //if statement: if the player comes in contact with an obstacle and he isn't coming crashing down on it, he will land on it
                player.velocity = CGPointMake(player.velocity.x, 0);
                
                //dont allow the player to fall any farther
                [self unschedule:@selector(gravityUpdate:)];
                
                //dont allow the player to move horizontally
                self.accelerometerEnabled = NO;
                player.velocity = CGPointMake(0, player.velocity.y);
            }

            
            //if the player is sitting on the obstacle, make him be on the very top of the obstacle
            if (player.velocity.y == 0) {
                if (CGRectIntersectsRect([player feetRect], [temp getRect])) {
                    if (([temp.type isEqualToString:@"obstacle"] || [temp.type isEqualToString:@"horizontal obstacle"])) {
                        player.position = CGPointMake(player.position.x, temp.position.y + temp.contentSize.height / 2 + player.contentSize.height / 2);
                    }
                }
            }
        }
    }
}


-(void) addFuelBar{
    CCSprite* outer = [CCSprite spriteWithFile:@"outer.png"];
    innerFuelBar = [CCSprite spriteWithFile:@"inner.png"];
    
    outer.position = CGPointMake(winSize.width - outer.contentSize.width/2, outer.contentSize.height/2);
    innerFuelBar.position = CGPointMake(winSize.width - innerFuelBar.contentSize.width/2 - 3, innerFuelBar.contentSize.height/2 + 3);
    
    
    [self addChild:outer z:1];
    [self addChild:innerFuelBar z:0];
    [self schedule:@selector(updateFuelBar:)];
}
-(void) updateFuelBar:(ccTime)delta{
    if ((int)player.fuel % (player.maxFuel / (int)innerFuelBar.contentSize.width) == 0  && !didAlreadyMakeFuelBarSmaller) {
        innerFuelBar.position = CGPointMake(innerFuelBar.position.x + 1, innerFuelBar.position.y);
        didAlreadyMakeFuelBarSmaller = YES;
    }
    else if ((int)player.fuel % (player.maxFuel / (int)innerFuelBar.contentSize.width) != 0) {
        didAlreadyMakeFuelBarSmaller = NO;
    }
}
//test above and below methods
-(void) addPowerUpBar: (PowerUp*)powerUp{
    CCSprite* outer = [CCSprite spriteWithFile:@"outer.png"];
    innerPowerUpBar = [CCSprite spriteWithFile:@"inner.png"];
    
    outer.position = CGPointMake(outer.contentSize.width/2, outer.contentSize.height/2);
    innerFuelBar.position = CGPointMake(innerFuelBar.contentSize.width/2 + 6, innerFuelBar.contentSize.height/2 - 6);
    
    
    [self addChild:outer z:1];
    [self addChild:innerPowerUpBar z:0];
    [self schedule:@selector(updatePowerUpBar:)];
}

-(void) updatePowerUpBar:(ccTime)delta{
    //find the max seconds of the power up in use
    int maxSecondsPowerUp;
    if (player.isBoostingEnabled) {
        maxSecondsPowerUp = maxNumSecondsBoost;
    }
    else if (player.isDoublePointsEnabled) {
        maxSecondsPowerUp = maxNumSecondsDouble;
    }
    else {
        maxSecondsPowerUp = maxNumSecondsInvy;
    }
    
    //"shrink" the power up bar
    if (numSecondsPowerUp % (maxSecondsPowerUp / (int)innerPowerUpBar.contentSize.width == 0) && didAlreadyMakePowerUpBarSmaller == NO) {
        innerPowerUpBar.position = CGPointMake(innerPowerUpBar.position.x + 1, innerPowerUpBar.position.y);
    }
    else if (numSecondsPowerUp % (maxSecondsPowerUp / (int)innerPowerUpBar.contentSize.width == 0)) {
        didAlreadyMakePowerUpBarSmaller = NO;
    }
}


//pause game and resume game stuff
-(void) pause:(id)sender{
    if (isMenuUp == YES) {
        return;
    }
    opacityLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 150)];
    [self addChild:opacityLayer z:9];
    
    Pause* pauseMenu = [Pause node];
    [self addChild:pauseMenu z:10];
    self.touchEnabled = NO;
    self.accelerometerEnabled = NO;
    [self unschedule:@selector(speedUpdate:)];
    [self unschedule:@selector(gravityUpdate:)];
    [self unschedule:@selector(accelerometerUpdate:)];
    [self unschedule:@selector(idlingjetpack:)];
    isMenuUp = YES;
    [[GlobalDataManager sharedGlobalDataManager] setIsPaused:YES];
}
-(void) resumeGame{
    self.touchEnabled = YES;
    self.accelerometerEnabled = YES;
    [self schedule:@selector(accelerometerUpdate:)];
    [[GlobalDataManager sharedGlobalDataManager] setIsPaused:NO];
    [self schedule:@selector(idlingjetpack:)];
    
    if (hasGameBegun) {
        [self schedule:@selector(gravityUpdate:)];
    }
    isMenuUp = NO;
    [self removeChild:opacityLayer cleanup:NO];
}

-(void) quitGame{
    [self gameEnded];
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}


-(void) invertedMagnet:(ccTime)delta{
    for (int i = lastObsDeleted; i < numObsAdded; i++) {
        Obstacles* obs = (Obstacles*)[self getChildByTag:i];
        
        CGPoint obsPos = obs.position;
        CGPoint playerPos = player.position;
        
        float deltaX = obsPos.x - playerPos.x;
        float deltaY = obsPos.y - playerPos.y;
        
        //this makes an eclipse
        float distance = 1.35*powf( powf(deltaX, 2)  +  0.45*powf(deltaY, 2) , 0.5);
        
        if (abs(distance) <= 150) {
            //set distance to the actual distance, not the adjusted one above for eclipse
            distance = powf( powf(deltaX, 2)  +  powf(deltaY, 2) , 0.5);
            
            //distance to move the obs
            float extendedDist = distance + 2;
            float theta = atan2f(deltaY, deltaX);
            
            float newX = cosf(theta)*extendedDist - deltaX;
            float newY = sinf(theta)*extendedDist - deltaY;
            
            //when the player is closer to an obstacle, make the obs move away faster
            float magnitude = -distance/150 + 3;
            
            obs.position = CGPointMake(magnitude * newX + obs.position.x, magnitude* newY +obs.position.y);
        }
    }
}



- (void) dealloc
{
    //[opacityLayer release];
	//[super dealloc];
}

@end

/*
 *** Where I left off ***
 
 just added fuel cans. next thing is to add power ups. draw on paper to see what'd be best

 
 
 todo:
 when game ends save data to plists.
 */