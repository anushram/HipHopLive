//
//  FollowResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "FollowDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface FollowResponse : JSONModel
@property (nonatomic) NSArray <FollowDetails, Optional> *followers;
@property (nonatomic) NSArray <FollowDetails, Optional> *followingUsers;
@property (nonatomic) NSArray <FollowDetails, Optional> *blockedUsers;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
