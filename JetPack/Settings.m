//
//  Settings.m
//  JetPack
//
//  Created by Colin Kalnasy on 12/13/13.
//  Copyright 2013 Colin Kalnasy. All rights reserved.
//

#import "Settings.h"
#import "JetpackIAPHelper.h"
#import "GlobalDataManager.h"
#import "SimpleAudioEngine.h"


@implementation Settings

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
	Settings *layer = [Settings node];
	[scene addChild:layer];
	return scene;
}

-(id) init {
    if( (self=[super init])) {
        winSize = CGSizeMake(320, 480);
        winSizeActual = [[CCDirector sharedDirector] winSize];
        
        CCSprite* background = [CCSprite spriteWithFile:@"base background.png"];
        background.anchorPoint = CGPointMake(0.5, 0);
        background.position = CGPointMake(background.contentSize.width/2, 0);
        [self addChild:background z:-100];
        
        
        CCSprite* settingsHeader = [CCSprite spriteWithFile:@"settings-header.png"];
        settingsHeader.position = CGPointMake(settingsHeader.contentSize.width/2, winSizeActual.height - settingsHeader.contentSize.height/2);
        [self addChild:settingsHeader];
        
        //back button
        back = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"Push-back.png" target:self selector:@selector(back:)];
        backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointMake(back.contentSize.width/6 + back.contentSize.width/2, (winSizeActual.height - HEADER_SIZE) - back.contentSize.width/6 - back.contentSize.height/2);
        
        [self addChild:backMenu];
        
        float pos = (backMenu.position.y - back.contentSize.height/2) / 3.0;
        
        BOOL isSoundOn = [GlobalDataManager isSonudOnWithDict];
        if (isSoundOn) {
            on = @"Sound-on-button.png";
            onPushed = @"Push-Sound-on.png";
            off =@"Sound-off-button.png";
            offPushed = @"Push-Sound-off.png";
        }
        else {
            on = @"Sound-off-button.png";
            onPushed = @"Push-Sound-off.png";
            off = @"Sound-on-button.png";
            offPushed = @"Push-Sound-on.png";
        }
        soundSwapOn = [CCMenuItemImage itemWithNormalImage:on selectedImage:onPushed];
        soundSwapOff = [CCMenuItemImage itemWithNormalImage:off selectedImage:offPushed];
        soundSwapToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundOnOff:) items:soundSwapOn, soundSwapOff, nil];
        
        soundOnOffMenu = [CCMenu menuWithItems:soundSwapToggle, nil];
        soundOnOffMenu.position = CGPointMake(winSizeActual.width/2, pos * 2);
        [self addChild:soundOnOffMenu];
        
        
        CCMenuItem* restorePurchases = [CCMenuItemImage itemWithNormalImage:@"Restore-purchases-button.png" selectedImage:@"Push-Restore-purchases.png" target:self selector:@selector(restore:)];
        CCMenu* restorePurchasesMenu = [CCMenu menuWithItems:restorePurchases, nil];
        restorePurchasesMenu.position = CGPointMake(winSizeActual.width/2, pos * 1);
        [self addChild:restorePurchasesMenu];
        
    }
    return self;
}



-(void) back:(id)sender {
    [[CCDirector sharedDirector] popScene];
}

-(void) soundOnOff:(id)sender {
    [GlobalDataManager setIsSoundOnWithDict:![GlobalDataManager isSonudOnWithDict]];
    
    [[SimpleAudioEngine sharedEngine] setMute:[GlobalDataManager isSonudOnWithDict]];
}

-(void) restore:(id)sender {
    [[JetpackIAPHelper sharedInstance] restoreCompletedTransactions];
}

@end
