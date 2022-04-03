//
//  SoloMusicRecordViewController.h
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

#import "MusicDuetFeed.h"


NS_ASSUME_NONNULL_BEGIN
@class AVAsset;
@class VTXLyric;
@interface SoloMusicRecordViewController : UIViewController<AVAudioPlayerDelegate,VTXLyricPlayerViewDataSource,VTXLyricPlayerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
}
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSTimer *sliderTimer;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPause_Btn;
@property (weak, nonatomic) IBOutlet UIButton *stop_Btn;

@property (strong, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) IBOutlet UIView *videoPlayView;

//video capture
@property (strong, nonatomic) UIImagePickerController *pickerController;
//@property (strong, nonatomic) MPMoviePlayerViewController *theMovie;

//move nextVC items
@property (nonatomic) MusicSoloFeed *soloselectedValue;
@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
@property (strong,nonatomic) NSString *selectionType;
@property(strong, nonatomic) NSString *solo_voice_part;

//invitedmove
@property (strong, nonatomic) InvitesSoloDetail *invitesselectedValue;
//Lyrics view
@property (strong, nonatomic) VTXLyric *lyric;

@property(nonatomic,strong)NSURL *soloCutMusicURL;
@property (weak, nonatomic) IBOutlet VTXLyricPlayerView *lyricPlayer;

//
@property (strong,nonatomic) NSURL *newvideoURL;
@property (nonatomic) NSString *moviePath;
@property (nonatomic) NSString *mediaType;

@property (strong,nonatomic) NSURL *duetFinallvideoURL;
@property (nonatomic) UIImage *thumbnailImage;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImg;



@end

NS_ASSUME_NONNULL_END
