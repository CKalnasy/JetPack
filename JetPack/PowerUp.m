//
//  PowerUp.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "PowerUp.h"


@implementation PowerUp

@synthesize type, rect;

+(id) powerUp:(NSString*)name
{
	return [[self alloc] initWithPowerUp:name];
}


-(id) initWithPowerUp:(NSString*)name {
    if (( self = [super initWithFile:name] )){
        
        rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    }
    return self;
}

-(void) setType:(NSString *)_type{
    type = _type;
}
-(NSString*) getType{
    return type;
}

-(CGRect) getRect{
    rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    
    return rect;
}

-(void) setIsEnabled:(BOOL)_isEnabled{
    isEnabled = _isEnabled;
}
-(BOOL) isEnabled{
    return isEnabled;
}

-(void) setIsLooking:(BOOL)_isLooking{
    isLooking = _isLooking;
}
-(BOOL) isLooking{
    return isLooking;
}


@end
