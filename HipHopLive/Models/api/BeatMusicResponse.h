//
//  BeatMusicResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "BeatMusicDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeatMusicResponse : JSONModel
@property (nonatomic) NSArray <BeatMusicDetail, Optional> *musiclist;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;



@end

NS_ASSUME_NONNULL_END
