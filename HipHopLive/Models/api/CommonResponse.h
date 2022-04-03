//
//  CommonResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 04/04/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonResponse : JSONModel
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
