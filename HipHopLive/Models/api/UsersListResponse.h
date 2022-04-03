//
//  UsersListResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 04/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "UserDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsersListResponse : JSONModel
@property (nonatomic) NSArray <UserDetails, Optional> *userdetails;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;

@end

NS_ASSUME_NONNULL_END
