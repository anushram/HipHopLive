//
//  ChannelResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 27/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "ChannelDetail.h"
#import "MusicDuetFeed.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChannelResponse : JSONModel
@property (nonatomic) NSArray <ChannelDetail, Optional> *RecordedSoloList;
@property (nonatomic) NSArray <MusicDuetFeed, Optional> *RecordedDuetList;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
