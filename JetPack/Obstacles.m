//
//  Obstacles.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Obstacles.h"

@implementation Obstacles

@synthesize speed, type, rect, bottomRect, middleRect, coinStage;

+(id) obstacle:(NSString*)name
{
//    if ([name rangeOfString:@"Coin" options:NSCaseInsensitiveSearch].location != NSNotFound) {
//        name = @"Coin3.png";
//    }
	return [[self alloc] initWithObstacle:name];
}


-(id) initWithObstacle:(NSString*)name {
    if (( self = [super initWithFile:name] )){
//        if ([name rangeOfString:@"Coin" options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            coinStage = arc4random()%8;
//            name = [NSString stringWithFormat:@"Coin%i.png",coinStage];
//            
//            self.texture = [[CCSprite spriteWithFile:name]texture];
//        }
        
        speed = 0;
        rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    }
    return self;
}




-(float) getSpeed{
    return speed;
}
-(void) setSpeed:(float)_speed{
    speed = _speed;
}

-(NSString *) getType{
    return type;
}
-(void) setType:(NSString *)_type{
    type = _type;
}

-(CGRect) rect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    
    return rect;
}

-(CGRect) middleRect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y, self.contentSize.width, 1);
    
    return rect;
}

-(CGRect) bottomRect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2 + 2, self.position.y - self.contentSize.height/2, self.contentSize.width - 4, self.contentSize.height);
    
    return rect;
}

-(int) coinStage {
    return coinStage;
}
-(void) incrementCoinStage {
    if (coinStage == NUMBER_OF_STAGES) {
        coinStage = 0;
    }
    else {
        coinStage++;
    }
}


@end