//
//  UserInviteResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 05/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "InvitesSoloDetail.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserInviteResponse : JSONModel
@property (nonatomic) NSArray <InvitesSoloDetail> *inviteduser;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
