//
//  InAppPurchaseManager.h
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *premiumVersion, *moreCoinsOne, *moreCoinsTwo, *moreCoinsThree;
    SKProductsRequest *productsRequest;
	BOOL storeDoneLoading;
}

+(InAppPurchaseManager *)sharedInAppManager;

- (void)requestAppStoreProductData;
- (void)loadStore;
- (BOOL)storeLoaded;
- (BOOL)canMakePurchases;
- (void)purchaseMoreCoinsOne;
- (void)purchaseMoreCoinsTwo;
- (void)purchaseMoreCoinsThree;
- (void)purchasePremiumContent;
- (void)restoreCompletedTransactions;
- (SKProduct *)getMoreCoinsOne;
- (SKProduct *)getMoreCoinsTwo;
- (SKProduct *)getMoreCoinsThree;
- (SKProduct *)getPremiumVersion;

@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end