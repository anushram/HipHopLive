//
//  StateDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol StateDetail
@end
@interface StateDetail : JSONModel
@property (assign, nonatomic) int country_id;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int stateID;

@end

NS_ASSUME_NONNULL_END
