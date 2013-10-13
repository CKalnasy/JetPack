//
//  Player.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize isInvyEnabled, isDoublePointsEnabled, isBoostingEnabled, isFading, rect, fuel, maxFuel, isAPowerUpEnabled, velocity, acceleration;


+(id) player:(NSString*)name
{
	return [[self alloc] initWithPlayer:name];
}


-(id) initWithPlayer:(NSString*)name {
    if (( self = [super initWithFile:name] )){
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector]winSize];
        
        isBoostingEnabled = NO;
        isDoublePointsEnabled = NO;
        isInvyEnabled = NO;
        isFading = NO;
        
        //makes the player rectangle
        rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, /*self.contentSize.width*/ 18, self.contentSize.height);
                    //there is a bunch of white space behind jeff now
        feetRect = CGRectMake(self.position.x - self.contentSize.width/2 + 3 , self.position.y - self.contentSize.height/2, 6, 4);
        //change when adding in actual player
        
        
        //jetpack init
        NSString* path = [[NSBundle mainBundle] bundlePath];
        NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
        NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        NSString* jetpackName = [dataDict valueForKey:@"jetpack selected"];
        jetpack = [CCSprite spriteWithFile:jetpackName];
        jetpack.position = CGPointMake(13.5, 19.5);
        
        
        //jetpack flame init
        flameSmall = [CCSprite spriteWithFile:@"FlameSmall.png"];
        flameMedium = [CCSprite spriteWithFile:@"FlameMedium.png"];
        flameLarge = [CCSprite spriteWithFile:@"FlameLarge.png"];
        
        flameSmall.position = CGPointMake(1.5, 4);
        flameSmall.visible = NO;
        [self addChild:flameSmall];
        flameMedium.position = CGPointMake(1.5, 2);
        flameMedium.visible = NO;
        [self addChild:flameMedium];
        flameLarge.position = CGPointMake(1.5, 1);
        flameLarge.visible = NO;
        [self addChild:flameLarge];
        
        [self addChild:jetpack z:10];
        
        [self schedule:@selector(updateFlame:)interval:1.0/10.0];
    }
    return self;
}

-(void) setIsInvyEnabled:(BOOL)_isBoostingEnabled{
    isInvyEnabled = _isBoostingEnabled;
}
-(BOOL) isInvyEnabled{
    return isInvyEnabled;
}

-(void) setIsBoostingEnabled:(BOOL)_isBoostingEnabled{
    isBoostingEnabled = _isBoostingEnabled;
}
-(BOOL) isBoostingEnabled{
    return isBoostingEnabled;
}

-(void) setIsDoublePointsEnabled:(BOOL)_isDoublePointsEnabled{
    isDoublePointsEnabled = _isDoublePointsEnabled;
}
-(BOOL) isDoublePointsEnabled{
    return isDoublePointsEnabled;
}

-(void) setIsFading:(BOOL)_isFading{
    isFading = _isFading;
}
-(BOOL) isFading{
    return isFading;
}

-(void) setFuel:(float)_fuel{
    fuel = _fuel;
}
-(float) getFuel{
    return fuel;
}

-(void) setMaxFuel:(int)_maxFuel{
    maxFuel = _maxFuel;
}
-(int) getMaxFuel{
    return maxFuel;
}

-(BOOL) getIsAPowerUpEnabled{
    if(isBoostingEnabled || isInvyEnabled || isDoublePointsEnabled){
        return true;
    }
    return false;
}


-(void)updateFlame:(ccTime)delta{
    //if the player is accelerating
    if (acceleration.y > 0) {
        if (flameSmall.visible == YES) {
            flameSmall.visible = NO;
            flameMedium.visible = YES;
        }
        else if (flameMedium.visible == YES) {
            flameMedium.visible = NO;
            flameLarge.visible = YES;
        }
        else if (flameLarge.visible == YES) {
            flameLarge.visible = NO;
            flameMedium.visible = YES;
        }
        else {
            flameSmall.visible = YES;
        }
    }
    //if the player is decelerating
    else {
        if (flameSmall.visible == YES) {
            flameSmall.visible = NO;
        }
        else if (flameMedium.visible == YES) {
            flameSmall.visible = YES;
            flameMedium.visible = NO;
        }
        else if (flameLarge.visible == YES) {
            flameMedium.visible = YES;
            flameLarge.visible = NO;
        }
    }
    isFlameChanging = YES;
}


-(CGRect) getRect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    
    return rect;
}

-(CGRect) feetRect{
    feetRect = CGRectMake(self.position.x - self.contentSize.width/2 + 3, self.position.y - self.contentSize.height/2, 6, 1);
    
    return feetRect;
}


-(CGPoint) acceleration{
    return acceleration;
}
-(void) setAcceleration:(CGPoint)point{
    acceleration = point;
}


-(void) faceLeft{
    if (isFacingRight) {
        self.scaleX = 1;
        isFacingRight = NO;
    }
}
-(void) faceRight{
    if (!isFacingRight) {
        self.scaleX = -1;
        isFacingRight = YES;
    }
}


@end
