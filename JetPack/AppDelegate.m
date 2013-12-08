//
//  AppDelegate.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright Colin Kalnasy 2013. All rights reserved.
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "MainMenu.h"
#import "GlobalDataManager.h"
#import "Game.h"
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"
#import "GameEnded.h"
#import "MoreCoins.h"
#import "vunglepub.h"
#import <GameKit/GameKit.h>
#import "JetpackIAPHelper.h"


@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait;
	
	// iPad only
	return UIInterfaceOrientationMaskPortrait;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [MainMenu scene]];
	}
}
@end

@interface AppController () <ChartboostDelegate>
@end

@interface AppController () <VGVunglePubDelegate>
@end



@implementation AppController 

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [RevMobAds startSessionWithAppID:@"522e77a1db7709c9f9000031"];
    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    
    [self vungleStart];
    [VGVunglePub setDelegate:self];
    
    Chartboost* cbv = [GlobalDataManager sharedGlobalDataManager].cb;
    cbv = [Chartboost sharedChartboost];
    cbv.appId = @"522e7eb717ba477e16000009";
    cbv.appSignature = @"3ffe2184c225347db82fd1e9339e2bc30a299cc2";
    cbv.delegate = self;
    
    [cbv startSession];
    [[GlobalDataManager sharedGlobalDataManager] setCb:cbv];
    
    
    //cache ads (Vungle does this automatically)
    [[Chartboost sharedChartboost] cacheInterstitial:@"After Game Ended"];
    
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadAd];
    
    
    
    /*
     * Stuff I've added
     */
    //data.plist init
    NSString* dataPath = [[NSBundle mainBundle] bundlePath];
    NSString* finalDataPath = [dataPath stringByAppendingPathComponent:@"Data.plist"];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataDocPath = [documentsDirectory stringByAppendingPathComponent:@"Data.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *dataDict;
    
    if ([fileManager fileExistsAtPath: dataDocPath])
    {
        dataDict = [NSMutableDictionary dictionaryWithContentsOfFile: dataDocPath];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:finalDataPath];
        [fileManager copyItemAtPath:finalDataPath toPath:dataDocPath error:nil];
    }
    
    //data.plist reading/writing
    int maxFuel = [[dataDict valueForKey:@"max fuel"] intValue];
    [[GlobalDataManager sharedGlobalDataManager]setFuel:maxFuel];
    [GlobalDataManager setMaxFuelWithDict:maxFuel];
    
    int numSecondsBoost = [[dataDict valueForKey:@"max seconds boost"] intValue];
    [GlobalDataManager setNumSecondsBoostWithDict:numSecondsBoost];
    
    int numSecondsDoublePoints = [[dataDict valueForKey:@"max seconds double points"] intValue];
    [GlobalDataManager setNumSecondsDoublePointsWithDict:numSecondsDoublePoints];
    
    int numSecondsInvy = [[dataDict valueForKey:@"max seconds invy"] intValue];
    [GlobalDataManager setNumSecondsInvyWithDict:numSecondsInvy];
    
    
    //stats.plist init
    NSString* statsPath = [[NSBundle mainBundle] bundlePath];
    NSString* finalStatsPath =[statsPath stringByAppendingPathComponent:@"Stats.plist"];
    
    
    NSString *statsDocPath = [documentsDirectory stringByAppendingPathComponent:@"Stats.plist"];
    
    NSMutableDictionary *statsDict;
    
    if ([fileManager fileExistsAtPath: statsDocPath])
    {
        statsDict = [[NSMutableDictionary alloc] initWithContentsOfFile: statsDocPath];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        statsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:finalStatsPath];
        [fileManager copyItemAtPath:finalStatsPath toPath:statsDocPath error:nil];
    }
    
    
    //stats.plist reading
    int highScore = [[statsDict valueForKey:@"high score"] intValue];
    [GlobalDataManager setHighScoreWithDict: highScore];
    
    int totalGames = [[statsDict valueForKey:@"total games"] intValue];
    [GlobalDataManager setTotalGamesWithDict:totalGames];
    
    int coins = [[statsDict valueForKey:@"coins collected"] intValue];
    [GlobalDataManager setTotalCoinsWithDict:coins];
    
    
    [JetpackIAPHelper sharedInstance];
    
    
    //[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    
    [glView setMultipleTouchEnabled:YES];
	
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    CCScene* scene = [[CCDirector sharedDirector] runningScene];
    if (scene.tag == GAME_SCENE_TAG) {
        Game* gameLayer = (Game*)[scene getChildByTag:GAME_LAYER_TAG];
        [gameLayer pause:self];
    }
    
    
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	//if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	//if( [navController_ visibleViewController] == director_ )   commented out beacuse if the game center view is active, game will crash as this if statement will return false
    
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    [VGVunglePub stop];
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	/*[window_ release];
	[navController_ release];
	
	[super dealloc];*/
}






/*
 * Chartboost Delegate Methods
 *
 * Recommended for everyone: shouldDisplayInterstitial
 */


/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    CCScene* s = [[CCDirector sharedDirector] runningScene];
    if (s.tag == GAME_SCENE_TAG) {
        Game* g = (Game*)[s getChildByTag:GAME_LAYER_TAG];
        
        if (g.isGameOver) {
            NSLog(@"about to display interstitial at location %@", location);
        
            return YES;
        }
    }
    
    // Otherwise return NO to display the interstitial
    NSLog(@"not going to display interstitial at location %@", location);
    
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        NSLog(@"Ad loaded");
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error: %@",error);
        //attempt to fill with other ad network here
    } onClickHandler:^{
        NSLog(@"Ad clicked");
    } onCloseHandler:^{
        NSLog(@"Ad closed");
    }];
    
    return NO;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No publishing campaign matches for that user (go make a new one in the dashboard)
 */

- (void)didFailToLoadInterstitial:(NSString *)location {
    NSLog(@"failure to load interstitial at location %@", location);
    
    // Show a house ad or do something else when a chartboost interstitial fails to load
}


/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: cb.hasCachedInterstitial(String location)
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
    
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps {
    NSLog(@"failure to load more apps");
}


/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache interstitials
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}


/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache the more apps page
 */

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    
    [[Chartboost sharedChartboost] cacheMoreApps];
}

/*
 * shouldRequestInterstitialsInFirstSession
 *
 * This sets logic to prevent interstitials from being displayed until the second startSession call
 *
 * The default is NO, meaning that it will always request & display interstitials.
 * If your app displays interstitials before the first time the user plays the game, implement this method to return NO.
 */

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}




-(void)vungleStart
{
    VGUserData*  data  = [VGUserData defaultUserData];
    NSString*    appID = @"vungleTest";
    
    // set up config data
    data.adOrientation   = VGAdOrientationPortrait;
    data.locationEnabled = TRUE;
    
    // start vungle publisher library
    [VGVunglePub startWithPubAppID:appID userData:data];
}

+(AppController*)appDelegate
{
    UIApplication*  uapp = [UIApplication sharedApplication];
    AppController*    cntl = (AppController*) [uapp delegate];
    
    VG_ASSERT(VGIsKindOf(cntl, [AppDelegate class]));
    
    return cntl;
}

- (void)vungleMoviePlayed:(VGPlayData*)playData{
    if ([playData playedFull]) {
        MoreCoins* scene = (MoreCoins*)[[[CCDirector sharedDirector] runningScene] getChildByTag:MORE_COINS_LAYER_TAG];
        
        scene.didWatchAd = YES;
    }
}

- (void)vungleViewDidDisappear:(UIViewController*)viewController {
    MoreCoins* scene = (MoreCoins*)[[[CCDirector sharedDirector] runningScene] getChildByTag:MORE_COINS_LAYER_TAG];
    
    if (scene.didWatchAd) {
        [scene adClosed];
    }
}




+(UIImage*) screenshotWithStartNode:(CCNode*)startNode {
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImage];
}



@end
