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
#import "AppDelegate.h"
#import "GameKitHelper.h"


@implementation Game

@synthesize isGameOver;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Game *layer = [Game node];
	[scene addChild: layer z:0 tag:GAME_LAYER_TAG];
    
    Background* background = [Background node];
    [scene addChild:background z:-1 tag:BACKGROUND_LAYER_TAG];
    
    [scene setTag:GAME_SCENE_TAG];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);    //screen size of 3.5" display
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        numObsPerScreen = 3.3;
        
        lastObsDeleted = 100;
        numObsAdded = 100;
        
        posBeforeFlip = winSizeActual.width * 2;
        
        coinRand = arc4random() % 10 - 4;
        
        //power up adding arrays init
        powerUpLow = [NSArray arrayWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:100], [NSNumber numberWithInt:150], [NSNumber numberWithInt:200], nil];
        
        powerUpHigh = [NSArray arrayWithObjects:[NSNumber numberWithInt:70], [NSNumber numberWithInt:120], [NSNumber numberWithInt:170], [NSNumber numberWithInt:220], nil];
        
        
        //after 10 power ups, use constant difference
        powerUpDifferenceLate = 160;   // 160 through 190
        
        //player init
        NSString* color = [GlobalDataManager playerColorWithDict];
        NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Jeff-", color, @".png"];
        
        //Number of seconds for each power up init
        maxNumSecondsBoost = [GlobalDataManager numSecondsBoostWithDict];
        maxNumSecondsDouble = [GlobalDataManager numSecondsDoublePointsWithDict];
        maxNumSecondsInvy = [GlobalDataManager numSecondsInvyWithDict];
        
        //player init
        player = [Player player:name];
        player.position = ccp(winSize.width/2, player.contentSize.height/2 + 2.5);
        [self addChild:player z:1];
        [[GlobalDataManager sharedGlobalDataManager] setPlayer:player];
        
        //fuel init
        player.maxFuel = [[GlobalDataManager sharedGlobalDataManager] maxFuel];
        player.fuel = player.maxFuel;
        didAlreadyMakeFuelBarSmaller = YES;
        [self addFuelBar];
        
        //pause button init
        CCMenuItem* pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"Pause.png" selectedImage:@"Push-Pause.png" target:self selector:@selector(pause:)];
        
        CCMenu* pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        pauseMenu.position = CGPointMake(winSizeActual.width - pauseMenuItem.contentSize.width/2, winSizeActual.height - pauseMenuItem.contentSize.height/2);
        [self addChild:pauseMenu];
        [[GlobalDataManager sharedGlobalDataManager] setIsPaused:NO];
        
        
        doDetectCollisions = YES;
        
        //adds touches input.  begins update methods
        self.touchEnabled=YES;
        
        [self addFirstObs];
        [self schedule:@selector(constUpdate:)];
        [self schedule:@selector(collisionDetection:)];
        [self schedule:@selector(accelerometerUpdate:)];
        [self schedule:@selector(whenToAddFuelCan:)];
        [self schedule:@selector(whenToAddPowerUp:)];
    }
	return self;
}

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
    //    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (player.isBoostingEnabled) {
        return;
    }
    //dont move the player if the opacity layer is visible
    [self schedule:@selector(speedUpdate:)];
    [self unschedule:@selector(gravityUpdate:)];
    self.accelerometerEnabled = YES;
    
    if (!isGameRunning) {
        [self schedule:@selector(idlingjetpack:)];
    }
    isGameRunning = YES;
    
    isTouchingHorizObs = NO;
    horizObsLandedOn = nil;
    
    if (![player areFeetAngled]) {
        [player setAngledFeet:YES];
    }
    
    CCLOG(@"touches began");
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (player.isBoostingEnabled) {
        return;
    }
    //[self removeChild:opacityLayer cleanup:NO];
    [self schedule:@selector(gravityUpdate:)];
    [self unschedule:@selector(speedUpdate:)];
    hasGameBegun = YES;
    
    CCLOG(@"touches ended");
}

/*-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //dont move the player if the opacity layer is visible
    [self schedule:@selector(speedUpdate:)];
    [self unschedule:@selector(gravityUpdate:)];
    self.accelerometerEnabled = YES;
    
    if (!isGameRunning) {
        [self schedule:@selector(idlingjetpack:)];
    }
    isGameRunning = YES;
    
    isTouchingHorizObs = NO;
    horizObsLandedOn = nil;
    
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
*/
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
            //[angledFeetPlayer faceRight];
            posBeforeFlip = winSizeActual.width * 2;
        }
    }
    else {
        if (player.position.x <= posBeforeFlip - 6) {
            [player faceLeft];
            //[angledFeetPlayer faceLeft];
            posBeforeFlip = winSizeActual.width * 2;
        }
    }
    
    previousAcc = acceleration.x;
}

//score and fall to bottom.  afterlife power up.  horiz obs movement call here. angled feet
-(void) constUpdate:(ccTime)delta{
    if(player.position.y - player.contentSize.height/2> highestPlayerPosition){
        highestPlayerPosition = player.position.y - player.contentSize.height/2;
    }
    //score
    if (player.isDoublePointsEnabled) {
        int newScore = (highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER;
        if (newScore != scoreRaw) {
            numOfDoublePoints++;
        }
    }
    
    scoreRaw = (highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER;
    [[GlobalDataManager sharedGlobalDataManager] setScoreRaw:scoreRaw];
    
    scoreActual = ((highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER) + numOfDoublePoints;
    [[GlobalDataManager sharedGlobalDataManager] setScoreActual:scoreActual];
    
    //fall to bottom
    if(player.position.y < -player.contentSize.height/2){
        //do falling to bottom stuff bere
        [self schedule:@selector(playerFellToBottom:)];
        [self unschedule:@selector(constUpdate:)];
    }
    
    //horizontal movement
    Obstacles* obs;
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        obs = (Obstacles*)[self getChildByTag:i];
        //if the obstacle is a horizontal moving one call the horizontal movement method
        if ([obs.type isEqualToString:@"horizontal obstacle"] && !isMenuUp) {
            [self horizontalMovement:obs];
        }
    }
    
    //give all classes access to velocity in y direction (by accessing player)
    [[GlobalDataManager sharedGlobalDataManager] setPlayer:player];
    
    if (player.fuel <= 0) {
        player.fuel = 0;
        [[GlobalDataManager sharedGlobalDataManager] setFuel:player.fuel];
        
        self.touchEnabled = NO;
        [self unschedule:@selector(speedUpdate:)];
        [self schedule:@selector(gravityUpdate:)];
        [self unschedule:@selector(idlingjetpack:)];
        didRunOutOfFuel = YES;
    }
}

//makes the player and flame accelerate.  fuel stuff here. flame update
-(void) speedUpdate:(ccTime)delta{
    self.accelerometerEnabled = YES;
    
    if (player.velocity.y >= MAX_VELOCITY) {
        player.velocity = CGPointMake(player.velocity.x, MAX_VELOCITY);
    }
    else {
        //updates the velocity and acceleration
        player.acceleration = CGPointMake(0, 0.15);
        player.velocity = CGPointMake(player.velocity.x, player.velocity.y + player.acceleration.y);
    }
    
    [[GlobalDataManager sharedGlobalDataManager]setFuel:player.fuel];
    
    //updates the players position
    if (player.position.y < MAX_HEIGHT) {
        CGPoint pos = player.position;
        pos.y += player.velocity.y;
        player.position = pos;
    }
    
    //moves objects and keeps the player centered on screen
    if(player.position.y >= MAX_HEIGHT){
        player.position = ccp(player.position.x, MAX_HEIGHT);
        
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
    if(player.position.y >= MAX_HEIGHT){
        if(player.velocity.y >= 0){
            player.position = ccp(player.position.x, MAX_HEIGHT);
            
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
    
    //angled feet
    if (player.velocity.y <= 0 && [player areFeetAngled]) {
        [player setAngledFeet:NO];
    }
}

//fuel idling
-(void) idlingjetpack:(ccTime)delta{
    if (player.isBoostingEnabled) {
        return;
    }
    
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
//        if (!added) {
//            [self addCoinField:lastObsAdded.position];
//            added = YES;
//            return;
//        }
        
        //coin stuff
        int coinLocToAdd = 40 * (numFewCoinsAdded + 1) + 5 * numFewCoinsAdded + coinRand;
        if (coinLocToAdd <= scoreRaw + winSize.height*2 / SCORE_MODIFIER) {
            //if the coins are supposed to be added to a pathed obs
            if ((previousPathedObsLoc < scoreRaw + winSize.height*2 / SCORE_MODIFIER)) {
                [self addFewCoins:lastObsAdded.position];
            }
            
            //reset coinRand for each new few coin
            coinRand = arc4random() % 10 - 4;
            numFewCoinsAdded++;
            return;
        }
        
        //pathed obs stuff
        int locToAdd = 55 - (5 * numPathedObsAdded) + previousPathedObsLoc;
        
        if (numPathedObsAdded > 3) {
            locToAdd = 40 + previousPathedObsLoc;
        }
        
        if (locToAdd <= scoreRaw + winSize.height * 2 / SCORE_MODIFIER) {
            [self pathedObsToAdd];
            return;
        }
        
        NSString* name;
        int r = arc4random()%100 + 1;
        if (r <= 70) {
            name = @"obstacle1.png";
        }
        else if (r <= 85) {
            name = @"obstacle2.png";
        }
        else {
            name = @"obstacle3.png";
        }
        
        Obstacles* obs = [Obstacles obstacle:name];
        [obs setType:@"obstacle"];
        
        int randomXPosition = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        
        int randomYPosition = arc4random() % 8 - 4;
        
        obs.position = ccp(randomXPosition, (lastObsAdded.position.y + randomYPosition + winSize.height / numObsPerScreen));
        
        [self addChild: obs z:0 tag:numObsAdded];
        
        lastObsAdded = obs;
        numObsAdded++;
        
        numObsPerScreen += 0.007;
        if (numObsPerScreen > MAX_OBS_PER_SCREEN) {
            numObsPerScreen = MAX_OBS_PER_SCREEN;
        }
    }
}
-(void) addFirstObs{
    firstObs = [Obstacles obstacle:@"obstacle1.png"];
    [firstObs setType:@"obstacle"];
    
    int randomXPosition = arc4random() % (int)(winSize.width - firstObs.contentSize.width) + firstObs.contentSize.width/2;
    int randomYPosition = arc4random() % 8 - 4;
    
    firstObs.position = ccp(randomXPosition, randomYPosition + winSize.height * 0.7);
    [self addChild:firstObs z:0 tag:numObsAdded];
    
    diffFirstObsAnd0 = firstObs.position.y;
    numObsAdded++;
    lastObsAdded = firstObs;
    
    for(int i=2; i<21; i++){
        Obstacles* obs = [Obstacles obstacle:@"obstacle1.png"];
        [obs setType:@"obstacle"];
        
        int randomXPosition = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        
        int randomYPosition = arc4random() % 8 - 4;
        
        obs.position = ccp(randomXPosition, randomYPosition + winSize.height / numObsPerScreen + lastObsAdded.position.y);
        [self addChild: obs z:0 tag:numObsAdded];
        
        lastObsAdded = obs;
        numObsAdded++;
    }
    [self schedule:@selector(addObs:)];
    [self schedule:@selector(cleanUpObs:)];
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

//pathed obs begin
//return value for all obs is the difference between the first one added and the second (in score)
-(int) addNarrowingObs{
    int begin = numObsAdded;
    for (int i = 0; i < 6; i++) {
        Obstacles* obs1 = [Obstacles obstacle:@"obstacle1.png"];
        [obs1 setType:@"special obstacle 1"];
        Obstacles* obs2 = [Obstacles obstacle:@"obstacle1.png"];
        [obs2 setType:@"special obstacle 1"];
        
        int xPos = obs1.contentSize.width/5 * (i + 1) + obs1.contentSize.width * (1.5/5.0);
        int yPos = lastObsAdded.position.y + (i + 1) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
        
        obs1.position = CGPointMake(xPos, yPos);
        obs2.position = CGPointMake(winSize.width - xPos, yPos);
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        
        if (i == 5) {
            lastObsAdded = obs1;
        }
    }
    
    int end = numObsAdded - 1;
    
    Obstacles* first = (Obstacles*)[self getChildByTag:begin];
    Obstacles* last = (Obstacles*)[self getChildByTag:end];
    
    return (last.position.y - first.position.y)/SCORE_MODIFIER;
}

-(int) addPathedObs{
    int begin = numObsAdded;
    Obstacles* o = [Obstacles obstacle:@"obstacle1.png"];
    float width = winSizeActual.width / 3.2 + o.contentSize.width;
    float diff = (winSizeActual.width - width) / 7.0;
    
    int r = arc4random()%2;
    BOOL isMovingLeft;
    if (r == 0) {
        isMovingLeft = NO;
    }
    else {
        isMovingLeft = NO;
    }
    
    //add the obstacles to make the player fall into the path
    Obstacles* left;
    Obstacles* right;
    int i = 0;
    do {
        Obstacles* obs1 = [Obstacles obstacle:@"obstacle1.png"];
        [obs1 setType:@"special obstacle 1"];
        Obstacles* obs2 = [Obstacles obstacle:@"obstacle1.png"];
        [obs2 setType:@"special obstacle 1"];
        
//        int xPos = obs1.contentSize.width/3 * (i + 1);
        int yPos = lastObsAdded.position.y + (i + 1) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
//
//        obs1.position = CGPointMake(xPos, yPos);
//        obs2.position = CGPointMake(winSize.width - xPos, yPos);
        
        if (isMovingLeft) {
            obs1.position = CGPointMake(i * diff + obs1.contentSize.width/2, yPos);
            obs2.position = CGPointMake(winSizeActual.width - obs2.contentSize.width/2, yPos);
        }
        else {
            obs1.position = CGPointMake(obs1.contentSize.width/2, yPos); //not sure about below this
            obs2.position = CGPointMake(winSizeActual.width - i * diff - obs2.contentSize.width/2, yPos);
        }
        
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        
        left = obs1;
        right = obs2;
        i++;
    } while (right.position.x - left.position.x > width + diff);
    
    lastObsAdded = left;
    Obstacles* lastPathedObs = lastObsAdded;
    
    //make the path to follow
    for (int j = 0; j <19; j++) {
        Obstacles* obs1 = [Obstacles obstacle:@"obstacle1.png"];
        [obs1 setType:@"special obstacle 1"];
        Obstacles* obs2 = [Obstacles obstacle:@"obstacle1.png"];
        [obs2 setType:@"special obstacle 1"];
        
        int xPos;
        if (isMovingLeft) {
            xPos = lastPathedObs.position.x - diff;
            
            if (xPos <= obs1.contentSize.width/2) {
                isMovingLeft = NO;
                //todo: change xpos so that it alligns obs on the boarder
                xPos = obs1.contentSize.width/2;
            }
        }
        else {
            xPos = lastPathedObs.position.x + diff;
            
            if (xPos > winSizeActual.width - width - obs1.contentSize.width/2) {
                isMovingLeft = YES;
                //todo: change xpos so that it alligns obs on the boarder
                xPos = winSizeActual.width - width - obs1.contentSize.width/2;
            }
        }
        
        int yPos = winSize.height * 2 + (j + 1 + i) * (player.contentSize.height * 1.25 + obs1.contentSize.height);
        
        obs1.position = CGPointMake(xPos, yPos);
        obs2.position = CGPointMake(width + xPos, yPos);
        
        [self addChild:obs1 z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obs2 z:0 tag:numObsAdded];
        numObsAdded++;
        
        if (j == 18) {
            lastObsAdded = obs1;
        }
        lastPathedObs = obs1;
    }
    
    int end = numObsAdded - 1;
    
    Obstacles* first = (Obstacles*)[self getChildByTag:begin];
    Obstacles* last = (Obstacles*)[self getChildByTag:end];
    
    return (last.position.y - first.position.y)/SCORE_MODIFIER;
}

-(int) addEdgeToEdgeObs:(BOOL)isLeft{
    int begin = numObsAdded;
    
    if (isLeft) {
        for (int i = 0; i < 10; i++) {
            Obstacles* obs = [Obstacles obstacle:@"obstacle1.png"];
            obs.type = @"special obstacle 2";
            
            int x = obs.contentSize.width/2 + (i+1)*(winSize.width - obs.contentSize.width)/10;
            int y = lastObsAdded.position.y + (i+1)*(winSize.height/10);
            
            obs.position = CGPointMake(x, y);
            
            [self addChild:obs z:0 tag:numObsAdded];
            numObsAdded++;
            if (i == 9) {
                lastObsAdded = obs;
            }
        }
    }
    else {
        for (int i = 0; i < 10; i++) {
            Obstacles* obs = [Obstacles obstacle:@"obstacle1.png"];
            obs.type = @"special obstacle 2";
            
            int x = winSize.width - (obs.contentSize.width/2 + (i+1)*(winSize.width - obs.contentSize.width)/10);
            int y = lastObsAdded.position.y + (i+1)*(winSize.height/10);
            
            obs.position = CGPointMake(x, y);
            
            [self addChild:obs z:0 tag:numObsAdded];
            numObsAdded++;
            
            if (i == 9) {
                lastObsAdded = obs;
            }
        }
    }
    
    int end = numObsAdded - 1;
    
    Obstacles* first = (Obstacles*)[self getChildByTag:begin];
    Obstacles* last = (Obstacles*)[self getChildByTag:end];
    
    return (last.position.y - first.position.y)/SCORE_MODIFIER;
}

-(int) addObsOnEdges{
    int begin = numObsAdded;
    
    for (int i = 0; i < 24; i++) {
        Obstacles* obsLeft;
        Obstacles* obsRight;
        
        if ((i + 1) % 8 != 0) {
            obsLeft = [Obstacles obstacle:@"obstacle1.png"];
            obsRight = [Obstacles obstacle:@"obstacle1.png"];
        }
        else {
            obsLeft = [Obstacles obstacle:@"obstacle2.png"];
            obsRight = [Obstacles obstacle:@"obstacle2.png"];
        }
        
        obsLeft.type = @"special obstacle 3";
        obsRight.type = @"special obstacle 3";
        
        obsLeft.position  = CGPointMake(obsLeft.contentSize.width/2, lastObsAdded.position.y + (i+1)*winSize.height/8);
        obsRight.position = CGPointMake(winSize.width - obsRight.contentSize.width/2, lastObsAdded.position.y + (i+1)*winSize.height/8);
        
        [self addChild:obsLeft z:0 tag:numObsAdded];
        numObsAdded++;
        [self addChild:obsRight z:0 tag:numObsAdded];
        numObsAdded++;
        
        
        //adds obs to the middle of screen
        if ((i + 1 + 4) % 8 == 0) {
            Obstacles* obsMid = [Obstacles obstacle:@"obstacle1.png"];
            obsMid.type = @"obstacle";
            
            obsMid.position = CGPointMake(winSize.width/2 , lastObsAdded.position.y + (i+1)*winSize.height/8);
            
            [self addChild:obsMid z:0 tag:numObsAdded];
            numObsAdded++;
        }
        
        if (i == 23) {
            lastObsAdded = obsRight;
        }
    }
    
    int end = numObsAdded - 1;
    
    Obstacles* first = (Obstacles*)[self getChildByTag:begin];
    Obstacles* last = (Obstacles*)[self getChildByTag:end];
    
    return (last.position.y - first.position.y)/SCORE_MODIFIER;
}

-(void) addOneOpening:(int)loc{
    int i = 0;
    Obstacles* last;
    
    while (i < loc && i < 4) {
        Obstacles* obs = [Obstacles obstacle:@"obstacle1.png"];
        obs.type = @"special obstacle 4";
        
        obs.position = CGPointMake((i + 0.5) * obs.contentSize.width, lastObsAdded.position.y + winSize.height/numObsPerScreen*2.4);
        
        [self addChild:obs z:0 tag:numObsAdded];
        numObsAdded++;
        last = obs;
        i++;
    }
    i++;
    while (i < 5) {
        Obstacles* obs = [Obstacles obstacle:@"obstacle1.png"];
        obs.type = @"special obstacle 4";
        
        obs.position = CGPointMake((i + .5) * obs.contentSize.width + 65/2.0, lastObsAdded.position.y + winSize.height/numObsPerScreen*2.4);
        
        [self addChild:obs z:0 tag:numObsAdded];
        numObsAdded++;
        last = obs;
        i++;
    }
    lastObsAdded = last;
}

-(int) addOneOpeningMany {
    int begin = numObsAdded;
    int cap = arc4random() % 2 + 4;
    
    for (int i = 0; i < cap; i++) {
        int rand = arc4random() % 5;
        [self addOneOpening:rand];
    }
    
    int end = numObsAdded - 1;
    
    Obstacles* first = (Obstacles*)[self getChildByTag:begin];
    Obstacles* last = (Obstacles*)[self getChildByTag:end];
    
    return (last.position.y - first.position.y)/SCORE_MODIFIER;
}

-(int) addHorizontalObsField {
    for (int i = 0; i < numObsPerScreen*1.5*1.5; i++) {
        int r = arc4random()%100 + 1;
        int o;
        if (r <= 70) {
            o = 1;
        }
        else if (r <= 85) {
            o = 2;
        }
        else {
            o = 3;
        }
        
        
        NSString* name = [NSString stringWithFormat:@"obstacle%i.png",o];
        Obstacles* obs = [Obstacles obstacle:name];
        obs.type = @"horizontal obstacle";
        
        
        int rand = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        obs.position = CGPointMake(rand, lastObsAdded.position.y + (i+1)*winSize.height/numObsPerScreen/1.5);
        
        [self addChild:obs z:0 tag:numObsAdded];
        numObsAdded++;
        
        if (i == (int)(numObsPerScreen*1.5*1.5) - 1) {
            lastObsAdded = obs;
        }
        
        [self makeHorizontalObs:obs];
    }
    
    return lastObsAdded.position.y - lastObsAdded.position.y + winSize.height/numObsPerScreen/1.5;
}


-(void) whenToAddPowerUp:(ccTime)delta{
    if ([self isLookingForAnyPowerUpOrEnabled]) {
        return;
    }
    
    int locToAdd = 60 + (numPowerUpsAdded * 7.5) + lastPowerUpEndOrLoc;
    
    if (numPowerUpsAdded >= 8) {
        locToAdd = 120 + lastPowerUpEndOrLoc;
    }
    
    if (locToAdd <= scoreRaw + winSize.height * 2 / SCORE_MODIFIER) {
        Obstacles* best = (Obstacles*)[self getChildByTag:lastObsDeleted];
        for (int i = lastObsDeleted + 1; i < numObsAdded; i++) {
            Obstacles* temp = (Obstacles*)[self getChildByTag:i];
        
            if (abs(locToAdd - (int)(temp.position.y / SCORE_MODIFIER) - scoreRaw) < abs(locToAdd - (int)(best.position.y / SCORE_MODIFIER) - scoreRaw)) {
                best = temp;
            }
        }
        CGPoint pointToAdd = [self findBestObs:best];
    
        //choose which power up to add
        int rand = arc4random() % 100 + 1;
        if (rand <= 500) {
            [self addBoost:pointToAdd];
        }
        else if (rand <= 70) {
            [self addDoublePoints:pointToAdd];
        }
        else {
            [self addInvy:pointToAdd];
        }
    
        numPowerUpsAdded++;
        lastPowerUpEndOrLoc = scoreRaw + pointToAdd.y / SCORE_MODIFIER;
    }
}
-(CGPoint) findBestObs:(Obstacles*)obs {
    CGPoint pos;
    
    //if its supposed to be added to an obstacle that's narrowing or pathed
    if ([obs.type isEqualToString:@"special obstacle 1"]) {
        Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag-1];
        
        float x;
        if (next.position.y == obs.position.y) {
            x = fabsf(next.position.x + obs.position.x) / 2.0;
        }
        else {
            x = fabsf(last.position.x + obs.position.x) / 2.0;
        }
        
        pos = CGPointMake(x, obs.position.y); //fuelCan
    }
    //if its supposed to be added to an obstacle that's moving from edge to edge
    else if ([obs.type isEqualToString:@"special obstacle 2"]) {
        if (obs.position.x > winSize.width/2) {
            int x = obs.position.x - winSize.width/4 - obs.contentSize.width/2;
            
            pos = CGPointMake(x, obs.position.y);
        }
        else {
            int x = obs.position.x + winSize.width/4 + obs.contentSize.width/2;
            
            pos = CGPointMake(x, obs.position.y);
        }
    }

    //if its supposed to be added to obs on the edges w/ obs in middle
    else if ([obs.type isEqualToString:@"special obstacle 3"]) {
        Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+2];
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag+1];
        
        if ([next.type isEqualToString:@"obstacle"] || [last.type isEqualToString:@"obstacle"]) {
            pos = [self findBestObs:next];
        }
        
        pos = CGPointMake(winSize.width/2, obs.position.y);
    }
    //if its supposed to be added to only one opening obs
    else if ([obs.type isEqualToString:@"special obstacle 4"]) {
        Obstacles* left = (Obstacles*)[self getChildByTag:obs.tag];
        while (left.position.y == obs.position.y) {
            
            left = (Obstacles*)[self getChildByTag:left.tag-1];
        }
        left = (Obstacles*)[self getChildByTag:left.tag+1];
        
        Obstacles* next = (Obstacles*)[self getChildByTag:left.tag+1];
        for (int i = 0; i < 3; i++) {
            Obstacles* last = (Obstacles*)[self getChildByTag:next.tag-1];
            
            if (next.position.x - last.position.x > obs.contentSize.width*1.2) {
                pos = CGPointMake(next.position.x - obs.contentSize.width, obs.position.y);
                break;
            }
            if (i == 2 && next.position.x > obs.contentSize.width*3.35) {
                pos = CGPointMake(next.position.x + obs.contentSize.width, obs.position.y);
                break;
            }
            if (i == 0 && left.position.x > obs.contentSize.width) {
                pos = CGPointMake(left.position.x - obs.contentSize.width, obs.position.y);
                break;
            }
            
            next = (Obstacles*)[self getChildByTag:next.tag+1];
        }
    }
    //obstacle that has been "removed" (moved off screen and replaced with something else
    else if ([obs.type isEqualToString:@"removed obstacle"]) {
        Obstacles* prev = (Obstacles*)[self getChildByTag:obs.tag-1];
        if (prev.position.y < winSize.height*1.2) {
            pos = [self findBestObs:prev];
        }
        else {
            Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
            pos = [self findBestObs:next];
        }
    }
    //randomly placed obs, coin
    else {
        pos = obs.position;
        
        obs.visible = NO;
        obs.position = CGPointMake(winSizeActual.width * 2, obs.position.y);
        obs.type = @"removed obstacle";
        //[self removeChild:obs];
    }
    return pos;
}

-(void) pathedObsToAdd {
    int locToAdd = 55 - (5 * numPathedObsAdded) + previousPathedObsLoc;
    
    if (numPathedObsAdded > 3) {
        locToAdd = 40 + previousPathedObsLoc;
    }
    
    Obstacles* best = (Obstacles*)[self getChildByTag:lastObsAdded.tag]; //reference to what lastobsadded references
    
    //choose which pathed obs to add
    int rand = arc4random() % 160 + 1;
    int end;
    
    if (rand <= 20) {
        end = [self addNarrowingObs];
    }
    else if (rand <= 40) {
        end = [self addPathedObs];
    }
    else if (rand <= 50) {
        end = [self addEdgeToEdgeObs:YES];
    }
    else if (rand <= 60) {
        end = [self addEdgeToEdgeObs:NO];
    }
    else if (rand <= 80) {
        end = [self addObsOnEdges];
    }
    else if (rand <= 100) {
        end = [self addOneOpeningMany];
    }
    else if (rand <= 120) {
        end = [self addHorizontalObsField];
    }
    else {
        end = [self addCoinField:lastObsAdded.position];
    }
    
    numPathedObsAdded++;
    previousPathedObsLoc = scoreRaw + best.position.y / SCORE_MODIFIER + end;
}


-(int) addCoinField:(CGPoint)point {
    int rand = arc4random() % 100 + 1;
    int numCoinsToAdd;
    
    if (rand <= 5) {
        numCoinsToAdd = 4;
    }
    else if (rand <= 10) {
        numCoinsToAdd = 5;
    }
    else if (rand <= 20) {
        numCoinsToAdd = 6;
    }
    else if (rand <= 60) {
        numCoinsToAdd = 8;
    }
    else if (rand <= 80) {
        numCoinsToAdd = 9;
    }
    else {
        numCoinsToAdd = 10;
    }
    
    int bagRandPos = arc4random() % (numCoinsToAdd * 2);
    
    //coins.contentSize.width = 12 at most
    int x = arc4random() % (int)(winSize.width - 12) + 6;
    
    for (int i = 0; i < numCoinsToAdd; i++) {
        [coinLoc addObject:[NSNumber numberWithInt:numObsAdded]];
        
        int randStartingPos = arc4random() % 5 + 1;
        NSString* name = [NSString stringWithFormat:@"Coin%i.png",randStartingPos];
        
        Obstacles* coin;
        if (i == bagRandPos) {
            coin = [Obstacles obstacle:@"Money-bag.png"];
            coin.type = @"money bag";
        }
        else {
            coin = [Obstacles obstacle:name];
            coin.type = @"coin";
            coin.coinStage = randStartingPos;
        }
        
        
        coin.position = CGPointMake(x, point.y + winSize.height/numObsPerScreen + i*2*coin.contentSize.height);
        [self addChild:coin z:0 tag:numObsAdded];
        numObsAdded++;
        
        
        if (i == numCoinsToAdd-1) {
            lastObsAdded = coin;
        }
    }
    
    [self schedule:@selector(updateCoins:) interval:1/4.0];
    
    return lastObsAdded.position.y - (point.y + winSize.height/numObsPerScreen);
}
-(void) addFewCoins:(CGPoint)point {
    int rand = arc4random()%100 + 1;
    int numCoinsToAdd;
    
    if (rand <= 30) {
        numCoinsToAdd = 3;
    }
    else {
        numCoinsToAdd = 4;
    }
    
    int bagRandPos = arc4random() % (numCoinsToAdd * 4);
    
    unsigned int randNum = arc4random(); //must have max of 2^32-1 for arc4random()
    Obstacles* c = [Obstacles obstacle:@"Coin1.png"];
    
    for (int i = 0; i < numCoinsToAdd; i++) {
        int startingPos = arc4random()%5 + 1;
        NSString* name = [NSString stringWithFormat:@"Coin%i.png", startingPos];
        
        Obstacles* coin;
        if (i == bagRandPos) {
            coin = [Obstacles obstacle:@"Money-bag.png"];
            coin.type = @"money bag";
        }
        else {
            coin = [Obstacles obstacle:name];
            coin.type = @"coin";
            coin.coinStage = startingPos;
        }
        
        int x = randNum % (int)(winSize.width - c.contentSize.width) + c.contentSize.width/2;
        coin.position = CGPointMake(x, point.y + winSize.height/numObsPerScreen + i*c.contentSize.height*2);
        
        [self addChild:coin z:0 tag:numObsAdded];
        numObsAdded++;
        
        if (i == numCoinsToAdd - 1) {
            lastObsAdded = coin;
        }
    }
    [self schedule:@selector(updateCoins:) interval:1/4.0];
}
-(void) updateCoins:(ccTime)delta{
    BOOL atLeastOneCoin = NO;
    
    for (int i = lastObsDeleted; i < numObsAdded; i++) {
        Obstacles* o = (Obstacles*)[self getChildByTag:i];
        
        if ([o.type isEqualToString:@"coin"]) {
            BOOL isLast = NO;
            if (lastObsAdded == o) {
                isLast = YES;
            }
            
            [o incrementCoinStage];
            NSString* name = [NSString stringWithFormat:@"Coin%i.png",o.coinStage];
            
            //basically a copy constructor. The dimensions of the sprite need to change with each update, thus cannot just change texture
            CGPoint pos = o.position;
            int tag = o.tag;
            NSString* type = o.type;
            int stage = o.coinStage;
            
            [self removeChild:o];
            o = nil;
            
            o = [Obstacles obstacle:name];
            o.type = type;
            o.position = pos;
            o.coinStage = stage;
            o.tag = tag;
            [self addChild:o z:0 tag:tag];
//            Obstacles* oCopy = [Obstacles obstacle:name];
//            oCopy.position = pos;
//            oCopy.type = type;
//            oCopy.coinStage = stage;
//            
//            [self addChild:oCopy z:0 tag:tag];
            
            //to re-reference last obs added
            if (isLast) {
                lastObsAdded = o;
            }
            
            atLeastOneCoin = YES;
        }
    }
    
    if (!atLeastOneCoin) {
        [self unschedule:@selector(updateCoins:)];
    }
}

-(void) addBoost:(CGPoint)point {
    boost = [PowerUp powerUp:@"Boost.png"];
    boost.type = @"Boost";
    boost.isLooking = YES;
    
    boost.position = point;
    
//    obs.visible = NO;
//    obs.position = CGPointMake(winSize.width * 2, obs.position.y);
//    obs.type = @"removed obstacle";
    
    [self addChild:boost];
    
    [self schedule:@selector(collideWithBoost:)];
}
-(void) collideWithBoost:(ccTime)delta{
    //do the sprites intersect
    if ([self doesPlayerIntersectPowerUp:boost]) {
        //do boostly things
        player.isBoostingEnabled = YES;
        
        //stop the player from moving up/down anymore
        [self unschedule:@selector(speedUpdate:)];
        [self unschedule:@selector(gravityUpdate:)];
        
        //no more touches can occur
        //self.touchEnabled = NO;
        
        //call a boost method to shoot up the player
        [self schedule:@selector(boostUp:)];
        
        //stop detecting colisions
        doDetectCollisions = NO;
        
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
    //give the player an extra second before collision detection begins
    if (numSecondsPowerUp >= (maxNumSecondsBoost + 1) * 60 ) {
        numSecondsPowerUp = 0;
        doDetectCollisions = YES;
        [self unschedule:@selector(boostUp:)];
        //player.isBoostingEnabled = NO;
        return;
    }
    else if (numSecondsPowerUp > 60 * maxNumSecondsBoost) {
        player.isBoostingEnabled = NO;
        numSecondsPowerUp++;
        return;
    }
    if (numSecondsPowerUp >= 60 * maxNumSecondsBoost) {
        lastPowerUpEndOrLoc = scoreRaw + player.position.y / SCORE_MODIFIER;
        numSecondsPowerUp++;
        
        [self unschedule:@selector(updatePowerUpBar:)];
        [self removeChild:innerPowerUpBar];
        [self removeChild:outerPowerUpBar];
        
        self.touchEnabled = YES;
        [self schedule:@selector(gravityUpdate:)];
        return;
    }
    if (player.velocity.y >= 9) {
        player.velocity = CGPointMake(player.velocity.x, 9);
    }
    if (player.position.y < MAX_HEIGHT || player.velocity.y < 9) {
        player.acceleration = CGPointMake(0, 0.4);
        player.velocity = CGPointMake(player.velocity.x, player.velocity.y + player.acceleration.y);
        CGPoint pos = player.position;
        pos.y += player.velocity.y;
        player.position = pos;
    }
    if (player.position.y >= MAX_HEIGHT) {
        player.position = ccp(player.position.x, MAX_HEIGHT);
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
        
        //updates the fuel can if its present
        if (fuelCan.isLooking) {
            CGPoint fuelCanPos = fuelCan.position;
            fuelCanPos.y -= player.velocity.y;
            fuelCan.position = fuelCanPos;
        }
    }
    numSecondsPowerUp++;
}


-(void) addInvy:(CGPoint)point {
    invy = [PowerUp powerUp:@"Invincibility.png"];
    invy.type = @"Invy";
    invy.isLooking = YES;
    
    invy.position = point;
    
//    obs.visible = NO;
//    obs.position = CGPointMake(winSize.width * 2, obs.position.y);
//    obs.type = @"removed obstacle";
    
    [self addChild:invy];
    
    [self schedule:@selector(collideWithInvy:)];
    
}
-(void) collideWithInvy:(ccTime)delta{
    if ([self doesPlayerIntersectPowerUp:invy]) {
        CCLOG(@"COLLISION WITH INVY!!!");
        
        //do invincibilityly things
        player.isInvyEnabled = YES;
        
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
-(void) invy:(ccTime)delta{
    if (numSecondsPowerUp >= 60 * maxNumSecondsInvy) {
        lastPowerUpEndOrLoc = scoreRaw + player.position.y / SCORE_MODIFIER;
        numSecondsPowerUp = 0;
        
        [self unschedule:@selector(updatePowerUpBar:)];
        [self removeChild:innerPowerUpBar];
        [self removeChild:outerPowerUpBar];
        
        player.isInvyEnabled = NO;
        player.isFading = NO;
        [self unschedule:@selector(invy:)];
        return;
    }
    
    for (int i = lastObsDeleted; i < numObsAdded; i++) {
        Obstacles* obs = (Obstacles*)[self getChildByTag:i];
        
        if ([obs.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound) {
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
    
    numSecondsPowerUp++;
}


-(void) addDoublePoints:(CGPoint)point{
    doublePoints = [PowerUp powerUp:@"DoublePoints.png"];
    doublePoints.type = @"Double Points";
    doublePoints.isLooking = YES;
    
    doublePoints.position = point;
    
    [self addChild:doublePoints];
    
    [self schedule:@selector(collideWithDoublePoints:)];
}
-(void) collideWithDoublePoints:(ccTime)delta{
    if ([self doesPlayerIntersectPowerUp:doublePoints]) {
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
    if (numSecondsPowerUp >= 60 * maxNumSecondsDouble) {
        lastPowerUpEndOrLoc = scoreRaw + player.position.y / SCORE_MODIFIER;
        numSecondsPowerUp = 0;
        
        [self unschedule:@selector(updatePowerUpBar:)];
        [self removeChild:innerPowerUpBar];
        [self removeChild:outerPowerUpBar];
        
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
        Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag-1];
        float x;
        if (next.position.y == obs.position.y) {
            x = fabsf(next.position.x + obs.position.x) / 2.0;
        }
        else {
            x = fabsf(last.position.x + obs.position.x) / 2.0;
        }
        
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
    //if its supposed to be added to obs on the edges w/ obs in middle
    else if ([obs.type isEqualToString:@"special obstacle 3"]) {
        Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+2];
        Obstacles* last = (Obstacles*)[self getChildByTag:obs.tag+1];

        if ([next.type isEqualToString:@"obstacle"] || [last.type isEqualToString:@"obstacle"]) {
            [self addFuelCan:next];
            return;
        }
        
        fuelCan.position = CGPointMake(winSize.width/2, obs.position.y);
        [self addChild:fuelCan];
    }
    //if its supposed to be added to only one opening obs
    else if ([obs.type isEqualToString:@"special obstacle 4"]) {
        Obstacles* left = (Obstacles*)[self getChildByTag:obs.tag];
        while (left.position.y == obs.position.y) {
            
            left = (Obstacles*)[self getChildByTag:left.tag-1];
        }
        left = (Obstacles*)[self getChildByTag:left.tag+1];
        
        Obstacles* next = (Obstacles*)[self getChildByTag:left.tag+1];
        for (int i = 0; i < 3; i++) {
            Obstacles* last = (Obstacles*)[self getChildByTag:next.tag-1];
            
            if (next.position.x - last.position.x > obs.contentSize.width*1.2) {
                fuelCan.position = CGPointMake(next.position.x - obs.contentSize.width, obs.position.y);
                [self addChild:fuelCan];
                break;
            }
            if (i == 2 && next.position.x > obs.contentSize.width*3.35) {
                fuelCan.position = CGPointMake(next.position.x + obs.contentSize.width, obs.position.y);
                [self addChild: fuelCan];
                break;
            }
            if (i == 0 && left.position.x > obs.contentSize.width) {
                fuelCan.position = CGPointMake(left.position.x - obs.contentSize.width, obs.position.y);
                [self addChild:fuelCan];
                break;
            }
            
            next = (Obstacles*)[self getChildByTag:next.tag+1];
        }
    }
    //obstacle that has been "removed" (moved off screen and replaced with something else
    else if ([obs.type isEqualToString:@"removed obstacle"]) {
        Obstacles* prev = (Obstacles*)[self getChildByTag:obs.tag-1];
        if (prev.position.y < winSize.height*1.2) {
            [self addFuelCan:prev];
        }
        else {
            Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
            [self addFuelCan:next];
        }
        return;
    }
    //horizontal obs
    else if ([obs.type isEqualToString:@"horizontal obstacle"]) {
        Obstacles* prev = (Obstacles*)[self getChildByTag:obs.tag-1];
        if (prev.position.y < winSize.height*1.2) {
            [self addFuelCan:prev];
        }
        else {
            Obstacles* next = (Obstacles*)[self getChildByTag:obs.tag+1];
            [self addFuelCan:next];
        }
        return;
    }
    //randomly placed obs, coin
    else {
        fuelCan.position = obs.position;
    
        obs.visible = NO;
        obs.position = CGPointMake(winSizeActual.width * 2, obs.position.y);
        obs.type = @"removed obstacle";
        
        [self addChild:fuelCan];
    }
    
    [self schedule:@selector(collideWithFuelCan:)];
}
-(void) collideWithFuelCan:(ccTime)delta{
    if ([self doesPlayerIntersectPowerUp:fuelCan]) {
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
    
    if (didRunOutOfFuel) {
        self.touchEnabled = YES;
        didRunOutOfFuel = NO;
        [self schedule:@selector(idlingjetpack:)];
    }
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

-(BOOL) isLookingForAnyPowerUpOrEnabled{
    return invy.isLooking || player.isInvyEnabled || boost.isEnabled || player.isBoostingEnabled || doublePoints.isLooking || player.isDoublePointsEnabled;
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
    if (player.position.y < -player.contentSize.height/2 && !player.isBoostingEnabled) {
        self.touchEnabled = NO;
        self.accelerometerEnabled = NO;
        player.velocity = CGPointMake(0, player.velocity.y);
        
        [self unschedule:@selector(speedUpdate:)];
        [self unschedule:@selector(gravityUpdate:)];
        [self unschedule:@selector(playerFellToBottom:)];
        [self unschedule:@selector(idlingjetpack:)];

        if (numContinuesUsed < 1 && [[GlobalDataManager sharedGlobalDataManager]totalCoins] >= COINS_TO_CONTINUE) {
            [self continueGame];
        }
        else {
            [self gameEnded];
            [self removeChild:continueMenu];
            
            opacityLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 150)];
            [self addChild:opacityLayer z:9];
            
            isGameOver = YES;
            GameEnded* ge = [GameEnded node];
            [self addChild:ge z:10];
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
-(void) continueGame {
    //todo: ask if they would like to continue
    CCMenuItem* continueYes = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(doContinue:)];
    CCMenuItem* continueNo = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" target:self selector:@selector(doNotContinue:)];
    
    continueMenu = [CCMenu menuWithItems:continueNo, continueYes, nil];
    [continueMenu alignItemsHorizontallyWithPadding:continueYes.contentSize.width];
    [self addChild:continueMenu];
    
    self.touchEnabled = NO;
}

-(void) cont:(ccTime)delta {
    Obstacles* lowest = (Obstacles*)[self getChildByTag:lastObsDeleted];
    if (lowest.position.y >= winSize.height / 2.2) {
        [self unschedule:@selector(cont:)];
        
        [self beginAfterContinue];
        
        return;
    }
    
    
    for (int i = lastObsDeleted; i < numObsAdded; i++) {
        Obstacles* o = (Obstacles*)[self getChildByTag:i];
        o.position = CGPointMake(o.position.x, o.position.y + 1);
    }
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
-(void) beginAfterContinue {
    //put the player on an appropriate obstacle or on the bottom of the screen
    //    int pos = [self obsToBeginOn];
    //
    //    if (pos == -1) {
    //        player.position = CGPointMake(winSizeActual.width/2, player.contentSize.height/2 + 2.5);
    //    }
    //    else {
    //        Obstacles* start = (Obstacles*)[self getChildByTag:pos];
    //        player.position = CGPointMake(start.position.x, start.position.y + start.contentSize.height/2 + player.contentSize.height/2 + 2.5);
    //    }
    
    player.position = CGPointMake(winSizeActual.width/2, player.contentSize.height/2 + 2.5);
    
    //lower total coins
    [[GlobalDataManager sharedGlobalDataManager] setTotalCoins:[[GlobalDataManager sharedGlobalDataManager] totalCoins] - COINS_TO_CONTINUE];
    
    //set game to original state
    [self schedule:@selector(collisionDetection:)];
    [self schedule:@selector(constUpdate:)];
    player.velocity = CGPointMake(0, 0);
    self.touchEnabled = YES;
    [self schedulePowerUpLookers];
    
    //reset hasgamebegun
    hasGameBegun = NO;
    
    isGameRunning = NO;
}
-(void) doContinue:(id)sender {
    numContinuesUsed++;
    
    //top off the fuel tank
    player.fuel = player.maxFuel;
    didRunOutOfFuel = NO;
    
    [self schedule:@selector(cont:)];
    
    [self removeChild:continueMenu cleanup:NO];
}
-(void) doNotContinue:(id)sender {
    [self gameEnded];
    [self removeChild:continueMenu];
    
    opacityLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 150)];
    [self addChild:opacityLayer z:9];
    
    isGameOver = YES;
    GameEnded* ge = [GameEnded node];
    [self addChild:ge z:10];
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
-(void)unschedulePowerUpEnablers{
    if (player.isDoublePointsEnabled) {
        [self unschedule:@selector(doublePoints:)];
    }
    if (player.isBoostingEnabled) {
        [self unschedule:@selector(boostUp:)];
    }
    if (player.isInvyEnabled) {
        [self unschedule:@selector(invy:)];
    }
}
-(void)schedulePowerUpEnablers{
    if (player.isDoublePointsEnabled) {
        [self schedule:@selector(doublePoints:)];
    }
    if (player.isBoostingEnabled) {
        [self schedule:@selector(boostUp:)];
        self.touchEnabled = NO;
    }
    if (player.isInvyEnabled) {
        [self schedule:@selector(invy:)];
    }
}

//game ended stuff
-(void) gameEnded{
    //add to the total number of coins
    int totalCoins = [GlobalDataManager sharedGlobalDataManager].totalCoins + numCoins;
    [[GlobalDataManager sharedGlobalDataManager] setTotalCoins:totalCoins];
    
    //reset fuel
    [[GlobalDataManager sharedGlobalDataManager] setFuel:player.maxFuel];
    
    //reset numCoins
    [[GlobalDataManager sharedGlobalDataManager] setNumCoins:0];
    
    [self isHighScore];
}
//is the score received on the just finished game the highest
-(void) isHighScore{
    if (scoreActual > [GlobalDataManager sharedGlobalDataManager].highScore) {
        [[GlobalDataManager sharedGlobalDataManager] setHighScore:scoreActual];
        
        [[GameKitHelper sharedGameKitHelper] submitScore:scoreActual category:@"jetpack_test"];
    }
}

-(Obstacles*) findLowestObs {
    Obstacles* lowest = (Obstacles*)[self getChildByTag:numObsAdded - 1];
    
    for (int i = lastObsDeleted; i < numObsAdded; i++) {
        Obstacles* o = (Obstacles*)[self getChildByTag:i];
        
        if (o.position.y < lowest.position.y && [o.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound && o.position.y > 0) {
            lowest = o;
        }
    }
    
    //if its a horizontal obs, make it a normal obstacle
    if ([lowest.type isEqualToString:@"horizontal obstacle"]) {
        lowest.type = @"obstacle";
        lowest.speed = 0;
    }
    
    return lowest;
}

-(void) collisionDetection:(ccTime)delta{
    //collision detection for obstacles
    Obstacles* temp;
    
    for (int i=lastObsDeleted; i<numObsAdded; i++) {
        temp = (Obstacles*)[self getChildByTag:i];
        
        if ([self doesPlayerIntersectObstacle:temp]) {
            //COLLISION!!!!!!!
            //find out what the player collided with
            if (([temp.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound)  &&  (player.velocity.y > 0 || player.velocity.y <= -4) && doDetectCollisions) {
                //if statement: if its a obstacle and the player is moving up (i.e. hit the bottom) or the player is comimg crashing down on an obsacle. Then he loses.
                
                //[self playerHitObs];
            }
            else if ([temp.type isEqualToString:@"coin"] || [temp.type isEqualToString:@"money bag"]) {
                //add to the coins count
                if ([temp.type isEqualToString:@"coin"]) {
                    numCoins++;
                }
                else {
                    numCoins += MONEY_BAG_VALUE;
                }
                
                [[GlobalDataManager sharedGlobalDataManager] setNumCoins:numCoins];
               
                //todo: remove the coin, not move it
                //position the coin outside of the viewing window and make it not visible
                [temp setVisible:NO];
                temp.position = CGPointMake(winSize.width * 2, temp.position.y);
            }
            else if (CGRectIntersectsRect([player feetRect], [temp bottomRect])  &&  ([temp.type rangeOfString:@"obstacle" options:NSCaseInsensitiveSearch].location != NSNotFound)  &&  (player.velocity.y <= 0 && player.velocity.y > -4) && !didRunOutOfFuel) {
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
                if (CGRectIntersectsRect([player feetRect], [temp bottomRect])) {
                    if (([temp.type isEqualToString:@"obstacle"])) {
                        player.position = CGPointMake(player.position.x, temp.position.y + temp.contentSize.height / 2 + player.contentSize.height / 2 + 2.5);
                    }
                    else if ([temp.type isEqualToString:@"horizontal obstacle"]) {
                        player.position = CGPointMake(player.position.x, temp.position.y + temp.contentSize.height / 2 + player.contentSize.height / 2 + 2.5);
                        
                        if (!isTouchingHorizObs) {
                            diffCenterObsAndPlayer = player.position.x - temp.position.x;
                            isTouchingHorizObs = YES;
                            horizObsLandedOn = temp;
                        }
                    }
                    if (didRunOutOfFuel) {
                        [self schedule:@selector(gravityUpdate:)];
                    }
                }
            }
        }
        if (isTouchingHorizObs) {
            player.position = CGPointMake(horizObsLandedOn.position.x + diffCenterObsAndPlayer, player.position.y);
        }
    }
}


-(BOOL) doesPlayerIntersectObstacle:(Obstacles*)temp{
    return CGRectIntersectsRect([player playerRect], [temp bottomRect]) || CGRectIntersectsRect([player jetpackRect], [temp bottomRect]) || CGRectIntersectsRect([player playerRect], [temp middleRect]) || CGRectIntersectsRect([player jetpackRect], [temp middleRect]) || CGRectIntersectsRect([player feetRect], [temp bottomRect]) || CGRectIntersectsRect([player feetRect], [temp middleRect]);
}
-(BOOL) doesPlayerIntersectPowerUp:(PowerUp*)temp{
    return CGRectIntersectsRect([player playerRect], [temp getRect]) || CGRectIntersectsRect([player jetpackRect], [temp getRect]);
}

-(void) addFuelBar{
    CCSprite* outer = [CCSprite spriteWithFile:@"fuel-boarder.png"];
    innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar.png"];
    
    outer.position = CGPointMake(10 + outer.contentSize.width/2, winSizeActual.height - winSize.height/20);
    innerFuelBar.position = CGPointMake(outer.position.x, winSizeActual.height - winSize.height/20);
    
    innerFuelBarRect = CGRectMake(innerFuelBar.position.x, innerFuelBar.position.y, innerFuelBar.contentSize.width, innerFuelBar.contentSize.height);
    
    [self addChild:outer];
    [self addChild:innerFuelBar];
    [self schedule:@selector(updateFuelBar:)];
}
-(void) updateFuelBar:(ccTime)delta{
    if (didRunOutOfFuel) {
        player.fuel = 0;
        innerFuelBarRect = CGRectMake(innerFuelBarRect.size.width/2 + 10, innerFuelBarRect.origin.y, 0, innerFuelBarRect.size.height);
        
        [self removeChild:innerFuelBar];
        innerFuelBar = nil;
        
        innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar.png" rect:CGRectMake(innerFuelBarRect.size.width/2 + 12, innerFuelBarRect.origin.y, 0, innerFuelBarRect.size.height)];
        innerFuelBar.position = CGPointMake(innerFuelBarRect.origin.x, innerFuelBarRect.origin.y);
        [self addChild:innerFuelBar];

        return;
    }
    innerFuelBarRect = CGRectMake(innerFuelBarRect.size.width/2 + 12, innerFuelBarRect.origin.y, player.fuel/player.maxFuel*87, innerFuelBarRect.size.height);
    //87 is the width of the inner bar before it is shrunk
    
    [self removeChild:innerFuelBar];
    innerFuelBar = nil;
    
    innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar.png" rect:innerFuelBarRect];
    innerFuelBar.position = CGPointMake(innerFuelBarRect.origin.x, innerFuelBarRect.origin.y);
    [self addChild:innerFuelBar];
}

-(void) addPowerUpBar: (PowerUp*)powerUp{
    outerPowerUpBar = [CCSprite spriteWithFile:@"PU-boarder.png"];
    innerPowerUpBar = [CCSprite spriteWithFile:@"PU-inner-bar.png"];
    
    //outerPowerUpBar.position = CGPointMake(winSizeActual.width - (10 + outerPowerUpBar.contentSize.width/2), winSizeActual.height - winSize.height/20);
    outerPowerUpBar.position = CGPointMake(10 + outerPowerUpBar.contentSize.width/2, innerFuelBar.position.y - outerPowerUpBar.contentSize.height - 3);
    innerPowerUpBar.position = outerPowerUpBar.position;
    
    innerPowerUpBarRect = CGRectMake(innerPowerUpBar.position.x, innerPowerUpBar.position.y, innerPowerUpBar.contentSize.width, innerPowerUpBar.contentSize.height);
    
    [self addChild:outerPowerUpBar];
    [self addChild:innerPowerUpBar];
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
    
    //innerPowerUpBarRect = CGRectMake(winSizeActual.width - (innerPowerUpBarRect.size.width/2 + 12), innerPowerUpBarRect.origin.y, 87 - numSecondsPowerUp / (maxSecondsPowerUp*60.0) * 87, innerPowerUpBarRect.size.height);
    innerPowerUpBarRect = CGRectMake(innerPowerUpBarRect.size.width/2 + 12, innerPowerUpBarRect.origin.y, 87 - numSecondsPowerUp/(maxSecondsPowerUp*60.0) * 87, innerPowerUpBarRect.size.height);
    //87 is the width of the inner bar before being shrunk
    
    [self removeChild:innerPowerUpBar];
    innerPowerUpBar = nil;
    
    innerPowerUpBar = [CCSprite spriteWithFile:@"PU-inner-bar.png" rect:innerPowerUpBarRect];
    innerPowerUpBar.position = CGPointMake(innerPowerUpBarRect.origin.x, innerPowerUpBarRect.origin.y);
    [self addChild:innerPowerUpBar];
}


//pause game and resume game stuff
-(void) pause:(id)sender{
    if (isMenuUp == YES || self.touchEnabled == NO) {
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
    
    [self unschedulePowerUpEnablers];
    [player unschedule:@selector(updateFlame:)];
    
    isMenuUp = YES;
    [[GlobalDataManager sharedGlobalDataManager] setIsPaused:YES];
}
-(void) resumeGame{
    if (hasGameBegun) {
        self.accelerometerEnabled = YES;
    }
    self.touchEnabled = YES;
    [self schedule:@selector(accelerometerUpdate:)];
    [[GlobalDataManager sharedGlobalDataManager] setIsPaused:NO];

    if (hasGameBegun) {
        [self schedule:@selector(idlingjetpack:)];
    }
    if (hasGameBegun && !player.isBoostingEnabled) {
        [self schedule:@selector(gravityUpdate:)];
    }
    
    [self schedulePowerUpEnablers];
    [player schedule:@selector(updateFlame:) interval:1.0/10.0];
    
    isMenuUp = NO;
    [self removeChild:opacityLayer cleanup:NO];
}

-(void) quitGame{
    [self gameEnded];
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}



- (void) dealloc
{
    //[opacityLayer release];
	//[super dealloc];
}

@end

/*
 *** Where I left off ***
 
 
 
 *** todo ***
 
 main menu
 other jetpacks
 fuel fine tuning
 in-app purchases (need bank acc. for)
 game ended scene (wait until artwork)
 settings (wait until artwork)
 
 will need to figure out how high the player can go (1/3 size, 1/2 size... idk)
 
 
 */