//
//  MusicDuetFeed.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 24/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MusicDuetFeed
@end
@interface MusicDuetFeed : JSONModel
@property (nonatomic) NSString* CategoryName;
@property (nonatomic) NSInteger category_id;
@property (nonatomic) NSString* created_at;
@property (nonatomic) NSInteger duetdislikecount;
@property (nonatomic) NSInteger duetlikecount;
@property (nonatomic) NSInteger duetlovecount;
@property (nonatomic) NSInteger duetsmilecount;
@property (nonatomic) NSInteger duetviewcount;
@property (nonatomic) int from_user_id;
@property (nonatomic) int id;
@property (nonatomic) NSString* musicDuetlikestatus;
@property (nonatomic) NSString* musicimage_filename;
@property (nonatomic) NSString* music_duet_image;
@property (nonatomic) NSString* music_duet_path;
@property (nonatomic) NSString* music_file;
@property (nonatomic) NSString* music_filename;
@property (nonatomic) NSInteger music_id;
@property (nonatomic) NSString* music_lyrics;
@property (nonatomic) NSString* music_lyrics_filename;
@property (nonatomic) int music_solo_id;
@property (nonatomic) NSString* record_filename;
@property (nonatomic) NSString* status;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* updated_at;
@property (nonatomic) NSString* username;
@property (nonatomic) NSInteger user_id;

@end

NS_ASSUME_NONNULL_END
