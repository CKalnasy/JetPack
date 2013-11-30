//
//  InAppPurchaseManager.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "MoreCoins.h"


@implementation InAppPurchaseManager

static InAppPurchaseManager *_sharedInAppManager = nil;

+ (InAppPurchaseManager *)sharedInAppManager
{
	@synchronized([InAppPurchaseManager class])
	{
		if (!_sharedInAppManager)
			[[self alloc] init];
		
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([InAppPurchaseManager class])
	{
		NSAssert(_sharedInAppManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInAppManager = [super alloc];
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	storeDoneLoading = NO;
	return self;
}

- (void) dealloc
{
//	[levelUpgradeProduct release];
//	[playerUpgradeOne release];
//	[playerUpgradeTwo release];
//	[super dealloc];
}

- (BOOL) storeLoaded
{
	return storeDoneLoading;
}

- (void)requestAppStoreProductData
{
	
#define kProductCoinsOne @"1000_coins"
#define kProductCoinsTwo @"5000_coins"
#define kProductCoinsThree @"10000_coins"
#define kProductPremiumVersion @"premium_version"
	
    NSSet *productIdentifiers = [NSSet setWithObjects: kProductCoinsOne, kProductCoinsTwo, kProductCoinsThree, kProductPremiumVersion, nil ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark In-App Product Accessor Methods

- (SKProduct *)getMoreCoinsOne
{
	return moreCoinsOne;
}

- (SKProduct *)getMoreCoinsTwo
{
	return moreCoinsTwo;
}

- (SKProduct *)getMoreCoinsThree
{
	return moreCoinsThree;
}

- (SKProduct *)getPremiumVersion
{
    return premiumVersion;
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	for (SKProduct *inAppProduct in products)
	{
		if ([inAppProduct.productIdentifier isEqualToString:kProductCoinsOne])
		{
			moreCoinsOne = inAppProduct;
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductCoinsTwo])
		{
			moreCoinsTwo = inAppProduct;
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductCoinsThree])
		{
			moreCoinsThree = inAppProduct;
		}
        if ([inAppProduct.productIdentifier isEqualToString:kProductPremiumVersion])
		{
			premiumVersion = inAppProduct;
		}
	}
	
    /*** Used for testing AppStore responses
     if (specialUpgrade)
     {
     SKProduct *testProduct = specialUpgrade;
     
     NSLog(@"Product title: %@" , testProduct.localizedTitle);
     NSLog(@"Product description: %@" , testProduct.localizedDescription);
     NSLog(@"Product price: %@" , testProduct.price);
     NSLog(@"Product id: %@" , testProduct.productIdentifier);
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore OK"
     message:[NSString stringWithFormat:@"title: %@ desc: %@ price: %@ id: %@",testProduct.localizedTitle,testProduct.localizedDescription,testProduct.localizedPrice,testProduct.productIdentifier]
     delegate:self
     cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     [alert release];
     
     }
     ***/
    
	storeDoneLoading = YES;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore Error"
														message:invalidProductId
													   delegate:self
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
//		[alert release];
		
		storeDoneLoading = NO;
    }
    
    // finally release the reqest we alloc/init’ed in requestlevelUpgradeProductData
//    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseMoreCoinsOne
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductCoinsOne];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseMoreCoinsTwo
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductCoinsTwo];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseMoreCoinsThree
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductCoinsThree];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchasePremiumContent
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductPremiumVersion];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


// Restore completed transactions
- (void) restoreCompletedTransactions
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];

    
    if ([transaction.payment.productIdentifier isEqualToString:kProductCoinsOne])
    {
        // save the transaction receipt to disk
//        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"moreCoinsOneReceipt" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [dataDict setValue:transaction.transactionReceipt forKey:@"moreCoinsOneReceipt"];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductCoinsTwo])
    {
        // save the transaction receipt to disk
//        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"moreCoinsTwoReceipt" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [dataDict setValue:transaction.transactionReceipt forKey:@"moreCoinsTwoReceipt"];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductCoinsThree])
    {
        // save the transaction receipt to disk
//        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"moreCoinsThreeReceipt" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [dataDict setValue:transaction.transactionReceipt forKey:@"moreCoinsThreeReceipt"];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductPremiumVersion])
    {
        // save the transaction receipt to disk
//        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"premiumContentReceipt" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [dataDict setValue:transaction.transactionReceipt forKey:@"premiumContentReceipt"];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kProductCoinsOne])
    {
        // enable the requested features by setting a global user value
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLevelUpgradePurchased" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [MoreCoins increaseCoins:1000];
    }
    if ([productId isEqualToString:kProductCoinsTwo])
    {
        // enable the requested features by setting a global user value
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlayerUpgradeOnePurchased" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [MoreCoins increaseCoins:5000];
    }
    if ([productId isEqualToString:kProductCoinsThree])
    {
        // enable the requested features by setting a global user value
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlayerUpgradeTwoPurchased" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [MoreCoins increaseCoins:10000];
    }
    if ([productId isEqualToString:kProductPremiumVersion])
    {
        // enable the requested features by setting a global user value
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPremiumContentPurchased" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString* path = [[NSBundle mainBundle] bundlePath];
        NSString* finalPath = [path stringByAppendingPathComponent:@"Data.plist"];
        NSDictionary* dataDict =[NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        [dataDict setValue:@YES forKey:@"isPremiumContentPurchased"];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
		NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
//		[alert release];
		
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
//    [numberFormatter release];
    return formattedString;
}

@end