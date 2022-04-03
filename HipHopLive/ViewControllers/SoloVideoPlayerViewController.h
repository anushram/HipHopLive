//
//  SoloVideoPlayerViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MusicDuetFeed.h"


NS_ASSUME_NONNULL_BEGIN

@interface SoloVideoPlayerViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIView *videoview;
@property (weak, nonatomic) IBOutlet UIImageView *thumImg;

//move nextVC items
@property (nonatomic) MusicSoloFeed *soloselectedValue;
@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
@property (strong,nonatomic) NSString *selectionType;
@property(strong, nonatomic) NSString *solo_voice_part;


//invitedmove
@property (strong, nonatomic) InvitesSoloDetail *invitesselectedValue;



@end

NS_ASSUME_NONNULL_END
