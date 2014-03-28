//
//  TimeTrial.m
//  JetPack
//
//  Created by Colin Kalnasy on 12/2/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "TimeTrial.h"
#import "BackgroundTimeTrial.h"
#import "GlobalDataManager.h"
#import "GameEndedTimeTrial.h"
#import "Pause.h"
#import "MainMenu.h"



@implementation TimeTrial


@synthesize isGameOver;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	TimeTrial *layer = [TimeTrial node];
	[scene addChild: layer z:0 tag:TIME_TRIAL_LAYER_TAG];
    
    BackgroundTimeTrial* background = [BackgroundTimeTrial node];
    [scene addChild:background z:-1 tag:BACKGROUND_LAYER_TAG];
    
    [scene setTag:TIME_TRIAL_SCENE_TAG];
	return scene;
}

-(id) init
{
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);    //screen size of 3.5" display
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        numObsPerScreen = 3.15;
        
        lastObsDeleted = 100;
        numObsAdded = 100;
        
        posBeforeFlip = winSizeActual.width * 2;
        
        //player init
        NSString* color = [GlobalDataManager playerColorWithDict];
        NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Jeff-", color, @".png"];
        
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
        
        
        NSString* version = [[UIDevice currentDevice] systemVersion];
        deviceVersion = version.floatValue;
        
        if (deviceVersion >= 7.0) {
            iAd = [[ADInterstitialAd alloc] init];
            iAd.delegate = self;
        }
        
        adMob = [[GADInterstitial alloc] init];
        adMob.adUnitID = @"ca-app-pub-2990915069046891/7775020160";
        [adMob loadRequest:[GADRequest request]];
        
        
        doDetectCollisions = YES;
        
        //adds touches input.  begins update methods
        self.touchEnabled=YES;
        
        [self addFirstObs];
        [self schedule:@selector(constUpdate:)];
        [self schedule:@selector(collisionDetection:)];
        [self schedule:@selector(accelerometerUpdate:)];
    }
	return self;
}

-(void) registerWithTouchDispatcher{
    //[[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/*
 -(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"jetpack.wav" loop:YES];
    }
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
    
    CCLOG(@"touches began");
}
 -(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self removeChild:opacityLayer cleanup:NO];
    [self schedule:@selector(gravityUpdate:)];
    [self unschedule:@selector(speedUpdate:)];
    hasGameBegun = YES;
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2];
    
    CCLOG(@"touches ended");
}
 */

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
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
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"jetpack.wav" loop:YES];
    }
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
    
    CCLOG(@"touches began");
    
    return YES;
}
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //[self removeChild:opacityLayer cleanup:NO];
    [self schedule:@selector(gravityUpdate:)];
    [self unschedule:@selector(speedUpdate:)];
    hasGameBegun = YES;
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2];
    
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
        if (player.position.x >= posBeforeFlip + POS_TO_FLIP) {
            [player faceRight];
            //[angledFeetPlayer faceRight];
            posBeforeFlip = winSizeActual.width * 2;
        }
    }
    else {
        if (player.position.x <= posBeforeFlip - POS_TO_FLIP) {
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
    scoreRaw = (highestPlayerPosition - firstObs.position.y + diffFirstObsAnd0) / SCORE_MODIFIER;
    [[GlobalDataManager sharedGlobalDataManager] setScoreRaw:scoreRaw];
    [[GlobalDataManager sharedGlobalDataManager] setScoreActual:scoreRaw];
    
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
        
        [self ranOutOfFuel];
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
        player.fuel += FUEL_IDLING_CONSTANT_TIME_TRIAL/5;
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
        }
    }
    
    //angled feet
    if (player.velocity.y <= 0 && [player areFeetAngled]) {
        [player setAngledFeet:NO];
    }
}

//fuel idling
-(void) idlingjetpack:(ccTime)delta{
    if (player.velocity.y > 0) {
        player.fuel -= FUEL_IDLING_CONSTANT_TIME_TRIAL;
    }
    else {
        player.fuel -= FUEL_IDLING_CONSTANT_TIME_TRIAL/3;
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
    
    if(pos.x < leftBorderLimit && !isTouchingHorizObs){
        pos.x = rightBorderLimit;
    }
    else if(pos.x > rightBorderLimit && !isTouchingHorizObs){
        pos.x = leftBorderLimit;
    }
    
    player.position = pos;
}

-(void) addObs:(ccTime)delta{
    //add new obstacles when the last one added is at twice the screen height
    if(lastObsAdded.position.y <= winSize.height * 2){
        //horizontal obs stuff
        int coinLocToAdd = 90 * (numFewHorizontalObsAdded + 1) - 4 * numFewHorizontalObsAdded;
        int rand = arc4random()%9 - 4;
        coinLocToAdd += rand;
        
        if (coinLocToAdd <= scoreRaw + winSize.height*2 / SCORE_MODIFIER) {
            //if the coins are supposed to be added to a pathed obs
            if ((previousPathedObsLoc < scoreRaw + winSize.height*2 / SCORE_MODIFIER)) {
                [self addFewHorizontalObs:lastObsAdded.position];
            }
            
            numFewHorizontalObsAdded++;
            return;
        }
        
        //pathed obs stuff
        //int locToAdd = 55 - (5 * numPathedObsAdded) + previousPathedObsLoc;
        int locToAdd = 147 - (13 * numPathedObsAdded) + previousPathedObsLoc;
        
        if (numPathedObsAdded > 3) {
            //locToAdd = 40 + previousPathedObsLoc;
            locToAdd = 107 + previousPathedObsLoc;
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
        
        numObsPerScreen += 0.08;
        if (numObsPerScreen > MAX_OBS_PER_SCREEN_TIME_TRIAL) {
            numObsPerScreen = MAX_OBS_PER_SCREEN_TIME_TRIAL;
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
    
    for(int i=2; i<11; i++){
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
} //todo: add horizontal obs like coins
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
//            CCLOG(@"removed obs at: %i", i);
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

-(void) addFewHorizontalObs:(CGPoint)point {
    int rand = arc4random()%100 + 1;
    int numObsToAdd;
    
    if (rand <= 30) {
        numObsToAdd = 3;
    }
    else {
        numObsToAdd = 4;
    }
    
    Obstacles* last;
    for (int i = 0; i < numObsToAdd; i++) {
        int r = arc4random()%100;
        NSString* name;
        
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
        obs.type = @"horizontal obstacle";
        
        int x = arc4random() % (int)(winSize.width - obs.contentSize.width) + obs.contentSize.width/2;
        int randPos = arc4random() % 9 - 4;
        if (i == 0) {
            obs.position = CGPointMake(x, point.y + winSize.height/numObsPerScreen + randPos);
        }
        else {
            obs.position = CGPointMake(x, last.position.y + winSize.height/numObsPerScreen + randPos);
        }
        [self makeHorizontalObs:obs];
        
        last = obs;
        
        [self addChild:obs z:0 tag:numObsAdded];
        numObsAdded++;
        
        if (i == numObsToAdd - 1) {
            lastObsAdded = obs;
        }
    }
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
        
        if (i + 1 >= numObsPerScreen*1.5*1.5) {
            lastObsAdded = obs;
        }
        
        [self makeHorizontalObs:obs];
    }
    
    return lastObsAdded.position.y - lastObsAdded.position.y + winSize.height/numObsPerScreen/1.5;
}


-(void) pathedObsToAdd {
    int locToAdd = 55 - (5 * numPathedObsAdded) + previousPathedObsLoc;
    
    if (numPathedObsAdded > 3) {
        locToAdd = 40 + previousPathedObsLoc;
    }
    
    Obstacles* best = (Obstacles*)[self getChildByTag:lastObsAdded.tag]; //reference to what lastobsadded references
    
    //choose which pathed obs to add
    int rand = arc4random() % 120 + 1;
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
    else {
        end = [self addHorizontalObsField];
    }
    
    numPathedObsAdded++;
    previousPathedObsLoc = scoreRaw + best.position.y / SCORE_MODIFIER + end;
}



//the player hit an obstacle
-(void) playerHitObs{
    self.touchEnabled = NO;
    self.accelerometerEnabled = NO;
    [self unschedule:@selector(collisionDetection:)];
    [self unschedule:@selector(speedUpdate:)];
    player.velocity = CGPointMake(player.velocity.x, -player.velocity.y/2);
    [self schedule:@selector(gravityUpdate:)];
    
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
        
        isGameOver = YES;
        [self gameEnded];
        
        opacityLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 150)];
        [self addChild:opacityLayer z:9];
        
        GameEndedTimeTrial* ge = [GameEndedTimeTrial node];
        [self addChild:ge z:10];

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

//game ended stuff
-(void) gameEnded{
    if (![GlobalDataManager isPremiumContentWithDict]) {
        
        if (deviceVersion >= 7.0) {
            int rand = arc4random()%6;
            
            if (rand == 0 || rand == 1) {
                if (iAd.loaded) {
                    [iAd presentFromViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if (adMob.isReady) {
                    [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                }
                else {
                    [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                        CCScene* s = [[CCDirector sharedDirector] runningScene];
                        if (s.tag == GAME_SCENE_TAG) {
                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                            
                            if (g.isGameOver) {
                                [fs showAd];
                                NSLog(@"Ad loaded");
                            }
                            else {
                                NSLog(@"Ad loaded but not at appropriate time");
                            }
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate scene");
                        }
                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                        NSLog(@"Ad error: %@",error);
                        //attempt to fill with other ad network here
                    } onClickHandler:^{
                        NSLog(@"Ad clicked");
                    } onCloseHandler:^{
                        NSLog(@"Ad closed");
                    }];
                }
            }
            else if (rand == 2 || rand == 3) {
                if (adMob.isReady) {
                    [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if (iAd.loaded) {
                    [iAd presentFromViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                }
                else {
                    [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                        CCScene* s = [[CCDirector sharedDirector] runningScene];
                        if (s.tag == GAME_SCENE_TAG) {
                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                            
                            if (g.isGameOver) {
                                [fs showAd];
                                NSLog(@"Ad loaded");
                            }
                            else {
                                NSLog(@"Ad loaded but not at appropriate time");
                            }
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate scene");
                        }
                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                        NSLog(@"Ad error: %@",error);
                        //attempt to fill with other ad network here
                    } onClickHandler:^{
                        NSLog(@"Ad clicked");
                    } onCloseHandler:^{
                        NSLog(@"Ad closed");
                    }];
                }
            }
            else  if (rand == 4 || rand == 5) {
                if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                }
                else if (adMob.isReady) {
                    [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if (iAd.loaded) {
                    [iAd presentFromViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else {
                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                        CCScene* s = [[CCDirector sharedDirector] runningScene];
                        if (s.tag == GAME_SCENE_TAG) {
                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                            
                            if (g.isGameOver) {
                                [fs showAd];
                                NSLog(@"Ad loaded");
                            }
                            else {
                                NSLog(@"Ad loaded but not at appropriate time");
                            }
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate scene");
                        }
                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                        NSLog(@"Ad error: %@",error);
                        //attempt to fill with other ad network here
                    } onClickHandler:^{
                        NSLog(@"Ad clicked");
                    } onCloseHandler:^{
                        NSLog(@"Ad closed");
                    }];
                }
                [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
            }
            else {
                RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                    CCScene* s = [[CCDirector sharedDirector] runningScene];
                    if (s.tag == GAME_SCENE_TAG) {
                        Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                        
                        if (g.isGameOver) {
                            [fs showAd];
                            NSLog(@"Ad loaded");
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate time");
                        }
                    }
                    else {
                        NSLog(@"Ad loaded but not at appropriate scene");
                    }
                } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                    NSLog(@"Ad error: %@",error);
                    //attempt to fill with other ad network here
                    if (iAd.loaded) {
                        [iAd presentFromViewController:[[CCDirector sharedDirector]parentViewController]];
                    }
                    else if (adMob.isReady) {
                        [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                    }
                    else if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                        [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                    }
                    else {
                        [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
                    }
                    
                } onClickHandler:^{
                    NSLog(@"Ad clicked");
                } onCloseHandler:^{
                    NSLog(@"Ad closed");
                }];
            }
        }
        else {
            int rand = arc4random()%4 + 2;
            
            if (rand == 2 || rand == 3) {
                if (adMob.isReady) {
                    [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                }
                else {
                    [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                        CCScene* s = [[CCDirector sharedDirector] runningScene];
                        if (s.tag == GAME_SCENE_TAG) {
                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                            
                            if (g.isGameOver) {
                                [fs showAd];
                                NSLog(@"Ad loaded");
                            }
                            else {
                                NSLog(@"Ad loaded but not at appropriate time");
                            }
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate scene");
                        }
                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                        NSLog(@"Ad error: %@",error);
                        //attempt to fill with other ad network here
                    } onClickHandler:^{
                        NSLog(@"Ad clicked");
                    } onCloseHandler:^{
                        NSLog(@"Ad closed");
                    }];
                }
            }
            else  if (rand == 4 || rand == 5) {
                if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                    [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                }
                else if (adMob.isReady) {
                    [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                }
                else {
                    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                        CCScene* s = [[CCDirector sharedDirector] runningScene];
                        if (s.tag == GAME_SCENE_TAG) {
                            Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                            
                            if (g.isGameOver) {
                                [fs showAd];
                                NSLog(@"Ad loaded");
                            }
                            else {
                                NSLog(@"Ad loaded but not at appropriate time");
                            }
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate scene");
                        }
                    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                        NSLog(@"Ad error: %@",error);
                        //attempt to fill with other ad network here
                    } onClickHandler:^{
                        NSLog(@"Ad clicked");
                    } onCloseHandler:^{
                        NSLog(@"Ad closed");
                    }];
                }
                [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
            }
            else {
                RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
                [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
                    CCScene* s = [[CCDirector sharedDirector] runningScene];
                    if (s.tag == GAME_SCENE_TAG) {
                        Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
                        
                        if (g.isGameOver) {
                            [fs showAd];
                            NSLog(@"Ad loaded");
                        }
                        else {
                            NSLog(@"Ad loaded but not at appropriate time");
                        }
                    }
                    else {
                        NSLog(@"Ad loaded but not at appropriate scene");
                    }
                } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
                    NSLog(@"Ad error: %@",error);
                    //attempt to fill with other ad network here
                    if (adMob.isReady) {
                        [adMob presentFromRootViewController:[[CCDirector sharedDirector]parentViewController]];
                    }
                    else if ([[Chartboost sharedChartboost] hasCachedInterstitial:@"After Game Ended"]) {
                        [[Chartboost sharedChartboost] showInterstitial:@"After Game Ended"];
                    }
                    else {
                        [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
                    }
                    
                } onClickHandler:^{
                    NSLog(@"Ad clicked");
                } onCloseHandler:^{
                    NSLog(@"Ad closed");
                }];
            }
        }
    }



    //reset fuel
    [[GlobalDataManager sharedGlobalDataManager] setFuel:player.maxFuel];

    //total games
    [GlobalDataManager setTotalGamesWithDict:[GlobalDataManager totalGamesWithDict] + 1];
    
    [self isHighScore];
}
//is the score received on the just finished game the highest
-(void) isHighScore{
    if (scoreRaw > [GlobalDataManager timeTrialHighScoreWithDict]) {
        [GlobalDataManager setTimeTrialHighScoreWithDict:scoreRaw];
        
        [[GameKitHelper sharedGameKitHelper] submitScore:scoreRaw category:@"com.JetPack.TimeTrialHighScore"];
    }
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
                
                [self playerHitObs];
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


-(void) addFuelBar{
    CCSprite* outer = [CCSprite spriteWithFile:@"fuel-boarder1.png"];
    innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar1.png"];
    
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
        
        innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar1.png" rect:CGRectMake(innerFuelBarRect.size.width/2 + 12, innerFuelBarRect.origin.y, 0, innerFuelBarRect.size.height)];
        innerFuelBar.position = CGPointMake(innerFuelBarRect.origin.x, innerFuelBarRect.origin.y);
        [self addChild:innerFuelBar];
        
        return;
    }
    innerFuelBarRect = CGRectMake(innerFuelBarRect.size.width/2 + 12, innerFuelBarRect.origin.y, player.fuel/player.maxFuel*87, innerFuelBarRect.size.height);
    //87 is the width of the inner bar before it is shrunk
    
    [self removeChild:innerFuelBar];
    innerFuelBar = nil;
    
    innerFuelBar = [CCSprite spriteWithFile:@"fuel-inner-bar1.png" rect:innerFuelBarRect];
    innerFuelBar.position = CGPointMake(innerFuelBarRect.origin.x, innerFuelBarRect.origin.y);
    [self addChild:innerFuelBar];
}

-(void) ranOutOfFuel {
    [player schedule:@selector(ranOutOfFuel:) interval:1.0/10];
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
    
    [player schedule:@selector(updateFlame:) interval:1.0/10.0];
    
    isMenuUp = NO;
    [self removeChild:opacityLayer cleanup:NO];
}

-(void) quitGame{
    [self gameEnded];
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
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



- (void) dealloc
{
    //[opacityLayer release];
	//[super dealloc];
}


#pragma mark ADInterstitialViewDelegate methods

// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    iAd = [[ADInterstitialAd alloc] init];
    iAd.delegate = self;
    NSLog(@"did unload");
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    iAd = [[ADInterstitialAd alloc] init];
    iAd.delegate = self;
    NSLog(@"did fail");
}


@end
