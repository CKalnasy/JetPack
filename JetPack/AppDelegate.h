//
//  AppDelegate.h
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright Colin Kalnasy 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Chartboost.h"
#import "MMSDK.h"
#import <CoreLocation/CoreLocation.h>
#import "GADRequest.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*__unsafe_unretained director_;	// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;
@property (strong, nonatomic) CLLocationManager *locationManager;

+(AppController*)appDelegate;

-(GADRequest*)createRequest;

@end
