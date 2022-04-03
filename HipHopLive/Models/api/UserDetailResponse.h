//
//  UserDetailResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 07/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailResponse : JSONModel
@property (nonatomic,strong) UserDetails *userdetail;
@property (nonatomic) NSArray <MusicSoloFeed, Optional> *sololist;
@property (nonatomic) NSArray <MusicDuetFeed, Optional> *duetlist;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *follow_status;
@property (nonatomic) NSString *block_status;

@end

NS_ASSUME_NONNULL_END
