//
//  StateResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "StateDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface StateResponse : JSONModel
@property (nonatomic) NSArray <StateDetail, Optional> *statesRes;

@end

NS_ASSUME_NONNULL_END
