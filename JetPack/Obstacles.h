//
//  Obstacles.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Obstacles : CCSprite {
    float speed;
    NSString* type;
    CGRect rect;
    CGRect bottomRect;
    CGRect middleRect;
}

@property (nonatomic, readwrite) float speed;
@property (nonatomic, readwrite, copy) NSString* type;
@property (nonatomic, readwrite) CGRect rect;
@property (nonatomic, readwrite) CGRect bottomRect;
@property (nonatomic, readwrite) CGRect middleRect;

+(id) obstacle:(NSString*)name;
-(id) initWithObstacle:(NSString*)name;
-(float) getSpeed;
-(void) setSpeed:(float)_speed;
-(NSString *) getType;
-(void) setType:(NSString *)_type;
-(CGRect) rect;
-(CGRect) bottomRect;
-(CGRect) middleRect;

@end
