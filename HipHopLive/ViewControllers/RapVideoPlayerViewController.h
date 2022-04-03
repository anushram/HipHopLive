//
//  RapVideoPlayerViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>


NS_ASSUME_NONNULL_BEGIN

@interface RapVideoPlayerViewController : UIViewController
@property (nonatomic,strong) IBOutlet UIView *videoview;
@property (nonatomic) NSURL *getVideoURL;
@property (nonatomic, strong) NSString *songTitle;
@property(strong, nonatomic) NSString *music_type;

@property (nonatomic) BeatMusicDetail *rapValue;

@property (weak, nonatomic) IBOutlet UIImageView *thumImg;
@end

NS_ASSUME_NONNULL_END
