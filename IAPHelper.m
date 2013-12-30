//
//  IAPHelper.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//


#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "GlobalDataManager.h"
#import "MoreCoins.h"
#import "Store.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";


@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    if (_completionHandler) {
        _completionHandler(YES, skProducts);
    }
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}


- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
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
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    if ([transaction.error.localizedDescription isEqualToString:@"Cannot connect to iTunes Store"] && transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cannot connect to iTunes Store" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thank you, your purchase was successful" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    if ([productIdentifier isEqualToString:@"com.JetPack.1000_Coins"]) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] + 1000];
        
        [GlobalDataManager setNumberOfAllCoinsWithDict:[GlobalDataManager numberOfAllCoinsWithDict] + 1000];
        [[GameKitHelper sharedGameKitHelper] submitScore:[GlobalDataManager numberOfAllCoinsWithDict] category:@"com.JetPack.TotalCoins"];
        
        CCScene* scene = [[CCDirector sharedDirector] runningScene];
        MoreCoins* layer = (MoreCoins*)[scene getChildByTag:MORE_COINS_LAYER_TAG];
        [layer updateCoins];
    }
    else if ([productIdentifier isEqualToString:@"com.JetPack.5000_Coins"]) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] + 5000];
        
        [GlobalDataManager setNumberOfAllCoinsWithDict:[GlobalDataManager numberOfAllCoinsWithDict] + 5000];
        [[GameKitHelper sharedGameKitHelper] submitScore:[GlobalDataManager numberOfAllCoinsWithDict] category:@"com.JetPack.TotalCoins"];
        
        CCScene* scene = [[CCDirector sharedDirector] runningScene];
        MoreCoins* layer = (MoreCoins*)[scene getChildByTag:MORE_COINS_LAYER_TAG];
        [layer updateCoins];
    }
    else if ([productIdentifier isEqualToString:@"com.JetPack.10000_Coins"]) {
        [GlobalDataManager setTotalCoinsWithDict:[GlobalDataManager totalCoinsWithDict] + 10000];
        
        [GlobalDataManager setNumberOfAllCoinsWithDict:[GlobalDataManager numberOfAllCoinsWithDict] + 10000];
        [[GameKitHelper sharedGameKitHelper] submitScore:[GlobalDataManager numberOfAllCoinsWithDict] category:@"com.JetPack.TotalCoins"];
        
        CCScene* scene = [[CCDirector sharedDirector] runningScene];
        MoreCoins* layer = (MoreCoins*)[scene getChildByTag:MORE_COINS_LAYER_TAG];
        [layer updateCoins];
    }
    else if ([productIdentifier isEqualToString:@"com.JetPack.PremiumVersion"]){
        [GlobalDataManager setIsPremiumContentWithDict:YES];
        
        CCScene* scene = [[CCDirector sharedDirector] runningScene];
        Store* layer = (Store*)[scene getChildByTag:STORE_LAYER_TAG];
        [layer setAdFreeButtonEnabled: NO];
    }
}


- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end