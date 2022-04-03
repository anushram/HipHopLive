//
//  NewFeedCVC.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/02/22.
//  Copyright © 2022 Securenext. All rights reserved.
//

#import "NewFeedCVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation NewFeedCVC
@synthesize urlStr = _urlStr, playVideoRef = _playVideoRef, playerViewController = _playerViewController;
- (id)init {
        self = [super init];
        if (self) {
        }
        return self;
    }

- (void)awakeFromNib {
    [super awakeFromNib];
        /* code to re-execute */
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    AVPlayerItem* playerItem;
////    if ([data isKindOfClass: [MusicDuetFeed class]]) {
////        MusicDuetFeed *duet = (MusicDuetFeed *)data;
////        NSURL *url = [NSURL URLWithString:duet.record_filename];
////        playerItem = [AVPlayerItem playerItemWithURL: url];
////    }else{
////        MusicSoloFeed *single = (MusicSoloFeed *)data;
////        NSURL *url = [NSURL URLWithString:single.record_filename];
////        playerItem = [AVPlayerItem playerItemWithURL: url];
////    }
//
//        NSURL *url = [NSURL URLWithString:self.urlStr];
//        playerItem = [AVPlayerItem playerItemWithURL: url];
//
//    AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//        self.playVideoRef = playVideo;
//        self.playerViewController = [[AVPlayerViewController alloc] init];
//        self.playerViewController.player = playVideo;
//        self.playerViewController.player.volume = 0.5;
//        self.playerViewController.showsPlaybackControls = NO;
//        self.playerViewController.videoGravity = AVLayerVideoGravityResize;
//        CGPoint center = self.center;
//        self.playerViewController.view.frame=CGRectMake(center.x,center.y,self.bounds.size.width,self.bounds.size.height);
//        self.playerViewController.view.center = center;
//    [self addSubview:self.playerViewController.view];
//    [playVideo play];
//
//    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
//    });

    }

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self.playVideoRef seekToTime: kCMTimeZero];
    [self.playVideoRef play];
}

-(void)setCollectionData: (id)data{
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
//    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//
//    // Within the group enumeration block, filter to enumerate just videos.
//    [group setAssetsFilter:[ALAssetsFilter allVideos]];
//
//    // For this example, we're only interested in the first item.
//    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0]
//                            options:0
//                         usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
//
//                             // The end of the enumeration is signaled by asset == nil.
//                             if (alAsset) {
//                                 ALAssetRepresentation *representation = [alAsset defaultRepresentation];
//                                 NSURL *url = [representation url];
//                                 AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
//                                 NSLog(@"seconds = %f", CMTimeGetSeconds(avAsset.duration));
//                                 // Do something interesting with the AV asset.
//                                 CMTimeMakeWithSeconds(CMTimeGetSeconds(avAsset.duration)/2.0, 600);
//                             }
//                         }];
//                     }
//                     failureBlock: ^(NSError *error) {
//                         // Typically you should handle an error more gracefully than this.
//                         NSLog(@"No groups");
//                     }];
     

    
    NSURL *url;
        if ([data isKindOfClass: [MusicDuetFeed class]]) {
            MusicDuetFeed *duet = (MusicDuetFeed *)data;
            url = [NSURL URLWithString:duet.record_filename];
        }else{
            MusicSoloFeed *single = (MusicSoloFeed *)data;
            url = [NSURL URLWithString:single.record_filename];
        }
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    AVURLAsset *anAssetToUseInAComposition = [[AVURLAsset alloc] initWithURL:url options:options];
    NSLog(@"%lld",anAssetToUseInAComposition.duration.value);
    NSLog(@"seconds = %f", CMTimeGetSeconds(anAssetToUseInAComposition.duration));
    
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

    //Audio and Video Tracks
    AVAssetTrack *firstVideoAssetTrack = [[anAssetToUseInAComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVAssetTrack *firstAudioAssetTrack = [[anAssetToUseInAComposition tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    //Composition Track
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration) ofTrack:firstVideoAssetTrack atTime:kCMTimeZero error:nil];
    
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration) ofTrack:firstAudioAssetTrack atTime:kCMTimeZero error:nil];
    
    //Instruction
    
    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration);
    
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    
    CGAffineTransform firstTransform = firstVideoAssetTrack.preferredTransform;
    
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(4, 1));
    
    [firstVideoLayerInstruction setTransform:firstTransform atTime:firstVideoAssetTrack.timeRange.duration];
    
    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    
    //Layer Instruction
    
    CALayer *backgroundLayer = [[CALayer alloc] init];
    backgroundLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width, firstVideoAssetTrack.naturalSize.height);
    backgroundLayer.backgroundColor = [UIColor systemRedColor].CGColor;
    
    CALayer *videoLayer = [[CALayer alloc] init];
    videoLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width - 40, firstVideoAssetTrack.naturalSize.height - 40);
    
    CALayer *overlayLayer = [[CALayer alloc] init];
    overlayLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width, firstVideoAssetTrack.naturalSize.height);
    
    CALayer *outputLayer = [[CALayer alloc] init];
    outputLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width, firstVideoAssetTrack.naturalSize.height);
    
    [outputLayer addSublayer: backgroundLayer];
    [outputLayer addSublayer: videoLayer];
    [outputLayer addSublayer: overlayLayer];
    
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction];
    
    mutableVideoComposition.renderSize = firstVideoAssetTrack.naturalSize;
    // Set the frame duration to an appropriate value (i.e. 30 frames per second for video).
    mutableVideoComposition.frameDuration = CMTimeMake(1,30);

    mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                        videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:outputLayer];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetHighestQuality];
    
    //Create Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"overlapVideo%u.mov",arc4random() % 10000]];
    //new
    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"overlapVideo.mov"]];

    [[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"duetSingle"];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    
    NSURL *urlBase = [NSURL fileURLWithPath:myPathDocs];
    
    exporter.videoComposition = mutableVideoComposition;
    
    exporter.outputURL=urlBase;
    
    
    
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL: exporter.outputURL];
             self.playerViewController = [[AVPlayerViewController alloc] init];
             AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
             self.playerViewController.player = playVideo;
             self.playerViewController.player.volume = 0.5;
             self.playerViewController.showsPlaybackControls = NO;
             self.playerViewController.videoGravity = AVLayerVideoGravityResize;
             CGPoint center = self.center;
             self.playerViewController.view.frame=CGRectMake(center.x,center.y,300,300);
             self.playerViewController.view.center = center;
             [self.contentView addSubview:self.playerViewController.view];
             [playVideo play];
         });
     }];

}

-(void)stopVideo: (id)data{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.playVideoRef pause];
    });
}

-(void)resumeVideo: (id)data{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.playVideoRef play];
    });
}


@end
