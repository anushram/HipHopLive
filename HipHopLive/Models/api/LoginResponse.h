//
//  LoginResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginResponse : JSONModel
@property (nonatomic) NSString *response;
@property (nonatomic) NSString <Optional> *token;
@property (nonatomic) UserDetails *userDetail;

@end

NS_ASSUME_NONNULL_END
