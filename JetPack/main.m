//
//  main.m
//  JetPack
//
//  Created by Colin Kalnasy on 9/1/13.
//  Copyright Colin Kalnasy 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"AppController");
    [pool release];
    return retVal;
}
