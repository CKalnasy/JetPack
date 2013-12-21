//
//  Stats.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define HEADER_SIZE 67
#define POS_OFFSET 10


@interface Stats : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;
    CCMenuItem* back;
    CCMenu* backMenu;
}

+(CCScene *) scene;

@end
