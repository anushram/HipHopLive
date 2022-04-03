//
//  BeatMusicLikeResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 07/12/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "BeatMusicDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeatMusicLikeResponse : JSONModel
@property (nonatomic) BeatMusicDetail *MusicLike;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
