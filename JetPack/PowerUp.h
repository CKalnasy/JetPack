//
//  PowerUp.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PowerUp : CCSprite {
    NSString* type;
    CGRect rect;
    BOOL isEnabled;
    BOOL isLooking;
}

@property (nonatomic, readwrite, copy) NSString* type;
@property (nonatomic, readwrite) CGRect rect;
@property (nonatomic, readwrite) BOOL isEnabled;
@property (nonatomic, readwrite) BOOL isLooking;


+(id) powerUp:(NSString*)name;
-(id) initWithPowerUp:(NSString*)name;
-(void) setType:(NSString *)_type;
-(NSString*) getType;
-(CGRect) getRect;
-(void) setIsEnabled:(BOOL)_isEnabled;
-(BOOL) isEnabled;
-(void) setIsLooking:(BOOL)_isLooking;
-(BOOL) isLooking;



@end
