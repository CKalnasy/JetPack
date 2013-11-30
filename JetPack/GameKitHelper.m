//
//  GameKitHelper.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

@synthesize currentLeaderBoard;

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}


#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}




-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}


#pragma mark Game Center UI method
-(void) showGameCenterViewController {
    BOOL isVerified;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    /*localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController == nil && error == nil) {
            NSLog(@"Here, you know that the user has already signed to Game Center, whether in through your app or not.");
        }
    };*/
    
    isVerified = localPlayer.authenticated;
    
    if (!isVerified) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        return;
    }
    
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateDefault;
    [self presentViewController:gameCenterViewController];
}

//- (void)showLeaderboard {
//    NSLog(@"leaderboard = %@", self.currentLeaderBoard);
//    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
//    if (leaderboardController != NULL)
//    {
//        leaderboardController.category = self.currentLeaderBoard;
//        //leaderboardController.category = nil;
//        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
//        leaderboardController.leaderboardDelegate = self;
//        [self presentModalViewController: leaderboardController animated: YES];
//    }
//}

#pragma mark GKGameCenterControllerDelegate method
- (void)gameCenterViewControllerDidFinish:
(GKGameCenterViewController *)gameCenterViewController {
    [self dismissModalViewController];
}

-(void) dismissModalViewController {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
}















-(void)viewAppear:(BOOL)animated
{
    //[self presentViewController]
}









@end