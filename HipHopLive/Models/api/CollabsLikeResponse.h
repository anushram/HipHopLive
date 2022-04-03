//
//  CollabsLikeResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 25/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "MusicDuetFeed.h"
#import "MusicSoloFeed.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollabsLikeResponse : JSONModel
@property (nonatomic) MusicSoloFeed<Optional>  *MusicSoloLike;
@property (nonatomic) MusicDuetFeed<Optional>  *MusicDuetLike;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
