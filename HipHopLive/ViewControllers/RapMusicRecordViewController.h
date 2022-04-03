//
//  RapMusicRecordViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 23/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

//AVAudio Framworks
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

//Lyrics view
#import "VTXLyricPlayerView.h"
#import "VTXKaraokeLyricView.h"
#import "VTXLyric.h"

#import "BeatMusicDetail.h"


NS_ASSUME_NONNULL_BEGIN
@class AVAsset;
@class VTXLyric;
@interface RapMusicRecordViewController : UIViewController<AVAudioPlayerDelegate,VTXLyricPlayerViewDataSource,VTXLyricPlayerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSTimer *sliderTimer;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPause_Btn;
@property (weak, nonatomic) IBOutlet UIButton *stop_Btn;

@property (strong, nonatomic) IBOutlet UIView *cameraView;

//Lyrics view
@property (strong, nonatomic) VTXLyric *lyric;
@property(nonatomic,strong)NSURL *musicURL;
@property (weak, nonatomic) IBOutlet VTXLyricPlayerView *lyricPlayer;

//video and audio record
@property (strong, nonatomic) UIImagePickerController *pickerController;
@property (nonatomic) NSString *moviePath;
@property (nonatomic) NSString *mediaType;
@property(strong, nonatomic) NSString *music_type;

//receiver audio
@property (strong, nonatomic) NSURL *songURL;
@property (nonatomic) NSURL *video_url;

@property (nonatomic) BeatMusicDetail *rapValue;

@end

NS_ASSUME_NONNULL_END
