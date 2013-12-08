//
//  BeginScene.h
//  JetPack
//
//  Created by Colin Kalnasy on 12/8/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BeginScene : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
}

+(CCScene *) scene;

@end
