//
//  Singletons.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "Singletons.h"

static Singletons *sharedMyManager;
@implementation Singletons

+ (Singletons*)sharedManager {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[Singletons alloc] init];
        
        sharedMyManager.navBckcolor = [UIColor colorWithRed:66.0f/255.0f
                                       green:79.0f/255.0f
                                        blue:91.0f/255.0f
                                       alpha:1.0f];
        sharedMyManager.userDetail = [[UserDetails alloc]init];
        sharedMyManager.countryList = [[NSMutableArray alloc]init];
        sharedMyManager.stateList = [[NSMutableArray alloc]init];
    });

    return sharedMyManager;
}

//- (id)init {
//    if (self = [super init]) {
//
//    }
//    return self;
//}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
