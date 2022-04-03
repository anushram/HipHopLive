//
//  MusicSoloFeed.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MusicSoloFeed
@end
@interface MusicSoloFeed : JSONModel
@property (nonatomic) NSString* CategoryName;
@property (nonatomic) NSInteger category_id;
@property (nonatomic) NSString* created_at;
@property (nonatomic) int id;
@property (nonatomic) NSString* musicimage_filename;
@property (nonatomic) NSString* musicSololikestatus;
@property (nonatomic) NSString* music_file;
@property (nonatomic) NSString* music_filename;
@property (nonatomic) NSInteger music_id;
@property (nonatomic) NSString* music_lyrics;
@property (nonatomic) NSString* music_lyrics_filename;
@property (nonatomic) NSString* music_solo_image;
@property (nonatomic) NSString* music_solo_path;
@property (nonatomic) NSString* record_filename;
@property (nonatomic) NSInteger solodislikecount;
@property (nonatomic) NSInteger sololikecount;
@property (nonatomic) NSInteger sololovecount;
@property (nonatomic) NSInteger solosmilecount;
@property (nonatomic) NSInteger soloviewcount;
@property (nonatomic) NSString<Optional> *solo_voice_part;
@property (nonatomic) NSString* status;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* updated_at;
@property (nonatomic) NSString* username;
@property (nonatomic) NSInteger user_id;


@end

NS_ASSUME_NONNULL_END
