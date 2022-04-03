//
//  ChannelDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 27/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ChannelDetail
@end
@interface ChannelDetail : JSONModel
@property (nonatomic) NSString* CategoryName;
@property (nonatomic) NSInteger category_id;
@property (nonatomic) NSString* created_at;
@property (nonatomic) int id;
@property (nonatomic) NSString* lyrics_file;
@property (nonatomic) NSString* musicimage_filename;
@property (nonatomic) NSString* music_file;
@property (nonatomic) NSString* music_filename;
@property (nonatomic) NSInteger music_id;
//@property (nonatomic) NSString* music_image;
@property (nonatomic) NSString* music_lyrics;
@property (nonatomic) NSString* music_profile;
@property (nonatomic) NSString* music_solo_image;
@property (nonatomic) NSString* music_solo_path;
@property (nonatomic) NSString* record_filename;
@property (nonatomic) NSInteger solodislikecount;
@property (nonatomic) NSInteger sololikecount;
@property (nonatomic) NSInteger sololovecount;
@property (nonatomic) NSInteger solosmilecount;
@property (nonatomic) NSInteger soloviewcount;
@property (nonatomic) NSString* status;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* updated_at;
@property (nonatomic) NSString* username;
@property (nonatomic) NSInteger user_id;


@end

NS_ASSUME_NONNULL_END
