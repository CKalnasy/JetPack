//
//  Jetpacks.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define HEADER_SIZE 67

@interface Jetpacks : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    
    CCLabelTTF* coins;
    CCRenderTexture* stroke;
}

+(CCScene *) scene;

@end
