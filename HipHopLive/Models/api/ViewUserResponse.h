//
//  ViewUserResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/04/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "ViewUserDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewUserResponse : JSONModel

@property (nonatomic) NSArray <ViewUserDetail, Optional> *Musicview;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
