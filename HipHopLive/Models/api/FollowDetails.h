//
//  FollowDetails.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FollowDetails
@end
@interface FollowDetails : JSONModel
@property (nonatomic) int id;
@property (nonatomic) NSString<Optional> *follow_status;
@property (nonatomic) NSString<Optional> *block_status;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *profileimage;
@property (nonatomic) NSString *user_name;

@end

NS_ASSUME_NONNULL_END
