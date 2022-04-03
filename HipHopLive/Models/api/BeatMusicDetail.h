//
//  BeatMusicDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BeatMusicDetail
@end
@interface BeatMusicDetail : JSONModel
@property (nonatomic) NSString* CategoryName;
@property (nonatomic) NSInteger category_id;
@property (nonatomic) NSString* created_at;
@property (nonatomic) int id;
@property (nonatomic) NSInteger likecount;
@property (nonatomic) NSInteger dislikecount;
@property (nonatomic) NSInteger smilecount;
@property (nonatomic) NSInteger lovecount;
@property (nonatomic) NSInteger viewcount;
@property (nonatomic) NSString* lyric_content;
@property (nonatomic) NSString* music_file;
@property (nonatomic) NSString* music_lyricist;
@property (nonatomic) NSString* music_lyrics;
@property (nonatomic) NSString* music_singer;
@property (nonatomic) NSString* music_type;
@property (nonatomic) NSString* status;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* updated_at;
@property (nonatomic) NSString* music_filename;
@property (nonatomic) NSString* music_lyrics_filename;
@property (nonatomic) NSString* music_image;
@property (nonatomic) NSString* music_profile;
@property (nonatomic) NSString* likestatus;



@end

NS_ASSUME_NONNULL_END
