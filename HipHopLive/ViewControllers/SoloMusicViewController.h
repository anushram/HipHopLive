//
//  SoloMusicViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 28/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
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

#import "MusicSoloFeed.h"
#import "InvitesSoloDetail.h"

NS_ASSUME_NONNULL_BEGIN
@class AVAsset;
@class VTXLyric;

@interface SoloMusicViewController : UIViewController<AVAudioPlayerDelegate,VTXLyricPlayerViewDataSource,VTXLyricPlayerViewDelegate>{
    
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
//@property (strong, nonatomic) VTXLyric *lyric;
@property (weak, nonatomic) IBOutlet VTXLyricPlayerView *lyricPlayer;

//move nextVC items
@property (strong, nonatomic) MusicSoloFeed *soloselectedValue;
@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
@property (strong,nonatomic) NSString *selectionType;
@property(strong, nonatomic) NSString *solo_voice_part;



//invitedmove
@property (strong, nonatomic) InvitesSoloDetail *invitesselectedValue;

//Lycrics view
@property (strong, nonatomic) VTXLyric *lyric;


//
@property (nonatomic,strong) IBOutlet UIView *videoview;

@end

NS_ASSUME_NONNULL_END
