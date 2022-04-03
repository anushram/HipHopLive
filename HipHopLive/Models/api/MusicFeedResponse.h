//
//  MusicFeedResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 23/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "MusicDuetFeed.h"
#import "MusicSoloFeed.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicFeedResponse : JSONModel
@property (nonatomic) NSArray <MusicSoloFeed, Optional> *musicSoloFeed;
@property (nonatomic) NSArray <MusicDuetFeed, Optional> *musicDuetFeed;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;

//notification response
@property (nonatomic) NSArray <MusicDuetFeed, Optional> *acceptedduet;

@end

NS_ASSUME_NONNULL_END
