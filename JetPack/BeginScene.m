//
//  BeginScene.m
//  JetPack
//
//  Created by Colin Kalnasy on 12/8/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "BeginScene.h"


@implementation BeginScene


+(CCScene*) scene {
    CCScene *scene = [CCScene node];
	BeginScene *layer = [BeginScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    if ((self = [super init])) {
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        
    }
    return self;
}




@end
