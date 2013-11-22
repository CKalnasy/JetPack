//
//  Clothes.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Apparel.h"

@interface Clothes : CCLayer {
    CGSize winSize;
    CGSize winSizeActual;

    Player* top;
    Player* bottom;
}

+(CCScene *) scene;

@end
