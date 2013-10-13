//
//  Obstacles.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Obstacles.h"

@implementation Obstacles

@synthesize speed, type, rect;

+(id) obstacle:(NSString*)name
{
	return [[self alloc] initWithObstacle:name];
}


-(id) initWithObstacle:(NSString*)name {
    if (( self = [super initWithFile:name] )){
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

-(CGRect) getRect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    
    return rect;
}

@end