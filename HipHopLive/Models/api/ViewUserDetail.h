//
//  ViewUserDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/04/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ViewUserDetail
    
@end

@interface ViewUserDetail : JSONModel
@property (nonatomic) int view_user_id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString<Optional> *profileimage;
@property (nonatomic) NSString *user_name;
@end

NS_ASSUME_NONNULL_END
