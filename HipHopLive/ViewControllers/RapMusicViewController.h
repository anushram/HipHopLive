//
//  RapMusicViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BeatMusicDetail.h"


//AVAudio Framworks
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

//Lyrics view
#import "VTXLyricPlayerView.h"
#import "VTXKaraokeLyricView.h"
#import "VTXLyric.h"

NS_ASSUME_NONNULL_BEGIN
@class AVAsset;
@class VTXLyric;
@interface RapMusicViewController : UIViewController<AVAudioPlayerDelegate,VTXLyricPlayerViewDataSource,VTXLyricPlayerViewDelegate>{
    
}

@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSTimer *sliderTimer;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPause_Btn;
@property (weak, nonatomic) IBOutlet UIButton *stop_Btn;
@property (weak, nonatomic) IBOutlet UILabel *title_Lbl;

//Lyrics view
@property(nonatomic,strong)NSURL *musicURL;
@property (strong, nonatomic) VTXLyric *lyric;
@property (weak, nonatomic) IBOutlet VTXLyricPlayerView *lyricPlayer;
@property(strong, nonatomic) NSString *music_type;


@property (nonatomic) BeatMusicDetail *rapValue;

@end

NS_ASSUME_NONNULL_END
