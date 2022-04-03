//
//  Singletons.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"
NS_ASSUME_NONNULL_BEGIN

@interface Singletons : NSObject
+ (Singletons*)sharedManager;
@property (nonatomic,strong) UserDetails *userDetail;
@property (nonatomic,strong) UIColor *navBckcolor;
@property (nonatomic,strong) NSMutableArray *countryList;
@property (nonatomic,strong) NSMutableArray *stateList;

@end

NS_ASSUME_NONNULL_END
