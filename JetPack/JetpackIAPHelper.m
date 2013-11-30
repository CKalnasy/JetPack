//
//  JetpackIAPHelper.m
//  JetPack
//
//  Created by Colin Kalnasy on 11/24/13.
//  Copyright (c) 2013 Colin Kalnasy. All rights reserved.
//

#import "JetpackIAPHelper.h"

@implementation JetpackIAPHelper


+ (JetpackIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static JetpackIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"1000_coins",
                                      @"5000_coins",
                                      @"10000_coins",
                                      @"premium_version",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
