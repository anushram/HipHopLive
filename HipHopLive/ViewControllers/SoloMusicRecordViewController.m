//
//  SoloMusicRecordViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 28/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "SoloMusicRecordViewController.h"

@interface SoloMusicRecordViewController ()
{
    AVPlayerItem* playerItem;
    AVPlayer* playVideo;
    AVPlayerViewController *playerViewController;

    //Lyrics view
    NSArray *keysTiming;
    AVAudioPlayer *audioPlayer;
    
    //new
    NSURL *mergeaudioUrl;
    UIImageView *thumbnailImageView;

}
@end

@implementation SoloMusicRecordViewController
@synthesize pickerController,mediaType,videoURL,moviePath;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar:@"Record"];
//    [self extractAudiofromvideoPath:self->videoURL];
    [self updateUI];
            
}

-(void)updateUI{
    
    [self getImageFromUrl:videoURL];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //        identifyVideoStartStop=0;
        //        flashCount=0;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //[self imagePickerControllerDidStartVideoCapturing:pickerController];
        // pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        pickerController.delegate = self;
        
        pickerController.view.frame=CGRectMake(0,0,self.cameraView.frame.size.width,self.cameraView.frame.size.height);
        pickerController.allowsEditing = YES;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        pickerController.showsCameraControls =NO;
        pickerController.toolbarHidden = YES;
        pickerController.wantsFullScreenLayout = YES;
        [self.cameraView addSubview:pickerController.view];
    }
    
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    self.isPlaying = false;
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    _stop_Btn.hidden = true;
    
    NSError *audioError = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soloCutMusicURL error:&audioError];
    audioPlayer.delegate = self;
    audioPlayer.volume = 0.5;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioPlayer prepareToPlay];
    
    NSLog(@"duration=%f",audioPlayer.duration);
//    [self.slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged];
    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:audioPlayer.duration]];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = audioPlayer.duration;
    
    //Lyrics view
    self.lyricPlayer.dataSource = self;
    self.lyricPlayer.delegate = self;
    
    [self setNavigationBar:self.lyric.title];
    
    [self.lyricPlayer prepareToPlay];
    [self.lyricPlayer start];
    [self.lyricPlayer pause];
    
    // sort key from nsdictionary
    NSArray* keys = [self.lyric.content allKeys];
    keysTiming = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }];
}
//Lycrics view
- (void)stopAll {
    //1.
    //    [_sliderTimer invalidate];
    //    [audioPlayer stop];
    //    [self.lyricPlayer stop];
    
    [_sliderTimer invalidate];
    [playVideo pause];
    [self.lyricPlayer stop];
    //    [self updateUI];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //1.
    //    [audioPlayer prepareToPlay];
    [self.lyricPlayer prepareToPlay];
    //
    //    [self setTitle:self.lyric.title];
}
- (IBAction)play:(id)sender {
    
    //    if (![self areHeadphonesPluggedIn]) {
    //        [self showAlertWithTitle:@"" andMessage:@"please plugin to your headphone " buttonTitles:@[@"Ok",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {
    //
    //            if ([action.title isEqualToString:@"Ok"]){
    //
    //
    //            }else if ([action.title isEqualToString:@"Cancel"]){
    //                [self.navigationController popViewControllerAnimated:YES];
    //            }
    //
    //        }];
    //    }else{
    if (self.isPlaying)
    {
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
        // Music is currently playing
        [audioPlayer pause];
//        [playVideo pause];
        [pickerController stopVideoCapture];
        [self.lyricPlayer pause];
        self.isPlaying = !self.isPlaying;
    }
    else
    {
        [thumbnailImageView removeFromSuperview];
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PauseImg"] forState:UIControlStateNormal];
        _playPause_Btn.hidden = true;
        
//        NSString *dutestring = [[NSUserDefaults standardUserDefaults]objectForKey:@"duetSingle"];
//        NSURL *duetFileURL1 = [NSURL fileURLWithPath:dutestring];
        
        playerItem = [AVPlayerItem playerItemWithURL:videoURL];
        playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = playVideo;
        playerViewController.view.frame=CGRectMake(0,0,self.videoPlayView.frame.size.width,self.videoPlayView.frame.size.height);
        playerViewController.player.volume = 0.5;
        playerViewController.showsPlaybackControls = false;
        if (@available(iOS 11.0, *)) {
            playerViewController.exitsFullScreenWhenPlaybackEnds = true;
        } else {
            // Fallback on earlier versions
        }
        // playerViewController.view.frame = self.totalview.bounds;
        [playVideo play];
        [self.videoPlayView addSubview:playerViewController.view];
        
        // Music is currenty paused/stopped
        [self.lyricPlayer resume];
        [audioPlayer play];
        [pickerController startVideoCapture];
        self.isPlaying = !self.isPlaying;
        self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        _stop_Btn.userInteractionEnabled = true;
        _stop_Btn.alpha = 1;
    }
    //    }
    
}

- (IBAction)stop_Action:(id)sender {
    _playPause_Btn.hidden = false;
    
    //1.
    [audioPlayer stop];
    [playVideo pause];
    [pickerController stopVideoCapture];
    
    [self.lyricPlayer stop];
    [self.sliderTimer invalidate];
//    self.slider.value = 0;
//    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:audioPlayer.duration]];
    
    self.isPlaying = false;
//    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
//    _stop_Btn.userInteractionEnabled = false;
//    _stop_Btn.alpha = 0.5;
//
//    NSError *audioError = nil;
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soloCutMusicURL error:&audioError];
//    audioPlayer.delegate = self;
//    audioPlayer.volume = 0.5;
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//    [audioPlayer prepareToPlay];
//
//    [self.lyricPlayer prepareToPlay];
//    [self.lyricPlayer start];
//    [self.lyricPlayer pause];
    
}
-(void)viewWillAppear:(BOOL)animated{
    //    self.navigationController.navigationBar.hidden =true;
    if (![self areHeadphonesPluggedIn]) {
        [self showAlertWithTitle:@"" andMessage:@"please plugin to your headphone " buttonTitles:@[@"Ok",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {

            if ([action.title isEqualToString:@"Ok"]){

            }else if ([action.title isEqualToString:@"Cancel"]){
                [self.navigationController popViewControllerAnimated:YES];
            }

        }];
    }
    
}

- (void)updateTime
{
    // Updates the slider about the music time
    self.slider.value = audioPlayer.currentTime;
    
    NSString *time = [self timeFormatted:self.slider.value];
    self.timerLabel.text = time;
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d / %@", minutes, seconds ,[self durationtimeFormatted:audioPlayer.duration]];
}

- (NSString *)durationtimeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}


- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"hi");
            [pickerController stopVideoCapture];
            //[self dismissModalViewControllerAnimated:YES];
            break;
        case MPMovieFinishReasonPlaybackError:
            break;
        case MPMovieFinishReasonUserExited:
            [self dismissModalViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [pickerController stopVideoCapture];
}
-(void)imagePickerControllerDidStartVideoCapturing:(UIImagePickerController *)picker{
    CGSize screenBounds = _videoPlayView.bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    pickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    pickerController.cameraViewTransform = CGAffineTransformScale(pickerController.cameraViewTransform, scale, scale);
    
}

#pragma UIImagePickerController Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tabBarController.tabBar.userInteractionEnabled = false;
    [self.lyricPlayer stop];

    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    _newvideoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    moviePath =(NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    
    [[NSUserDefaults standardUserDefaults]setObject:moviePath forKey:@"secondvideo"];
    [self extract:url];
    
}

#pragma mark- merger video and audio

//new cut audio from new video
-(void)extract: (NSURL *)url {
    AVMutableComposition*   newAudioAsset = [AVMutableComposition composition];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"mp4"];
    //    NSURL *soundFileURL = [NSURL fileURLWithPath:path];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
    AVMutableCompositionTrack*  dstCompositionTrack;
    dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [dstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                 ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession*   exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
    
    exportSesh.outputFileType = AVFileTypeCoreAudioFormat;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo%-dtemp.caf",arc4random() % 10000]];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo.caf"]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSURL *url1 = [NSURL fileURLWithPath:myPathDocs];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"soundOneNew.mp3"];
    //[[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"AudioPath"];
    exportSesh.outputURL=url1;
    
    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus  status = exportSesh.status;
        NSLog(@"exportAsynchronouslyWithCompletionHandler: %lii\n",(long) (long)status);
        
        if(AVAssetExportSessionStatusFailed == status) {
            NSLog(@"FAILURE: %@\n", exportSesh.error);
        } else if(AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"SUCCESS!\n");
            //            [self mergeTwoAudio:self->_songURL audio:url1];
            [self mergeTwoAudio:self->_soloCutMusicURL audio:url1];
        }
    }];
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

//merge two audio old and new audio only
-(void)mergeTwoAudio: (NSURL *)mergeURL audio:(NSURL *)recordedAudio{
    //    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"duetSingle"]] options:nil];
    
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:mergeURL options:nil];
    //secondvideo
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:recordedAudio options:nil];
    CMTime duration = kCMTimeZero;
    
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our multiple videos.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Now we are creating the first AVMutableCompositionTrack containing our first video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // [firstTrack setPreferredVolume:1.0];
    
    //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Repeat the same process for the 2nd track as we did above for the first track.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //[secondTrack setPreferredVolume:0.3];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    //mutableVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition.duration);
    mutableVideoCompositionInstruction.backgroundColor = [[UIColor redColor] CGColor];
    
    //mixComposition.instructions =
    AVAssetExportSession*   exportSesh = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    
    exportSesh.outputFileType = AVFileTypeMPEG4;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"merge%-dtemp.mp4",arc4random() % 10000]];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergetemp.mp4"]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"soundOneNew.mp3"];
    //[[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"AudioPath"];
    //exportSesh.outputFileType = AVAudioSessionCategoryPlayback;
    exportSesh.outputURL=url;
    
    exportSesh.shouldOptimizeForNetworkUse = YES;
    
    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus  status = exportSesh.status;
        NSLog(@"exportAsynchronouslyWithCompletionHandler: %li\n", (long)status);
        
        if(AVAssetExportSessionStatusFailed == status) {
            NSLog(@"FAILURE: %@\n", exportSesh.error);
        } else if(AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"SUCCESS!\n");
            
//            NSURL *urlVideo = [NSURL fileURLWithPath:self->_moviePath];
//            [self mergeAudio:url withVideo:urlVideo andSaveToPathUrl:@""];
            self->mergeaudioUrl = url;
            [self transFormCorrect:nil];

        }
    }];
    
}

//old video to convert mov file
-(void)transFormCorrect:(NSURL *)url{
    
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:url options:nil];

    CMTime duration = kCMTimeZero;
    
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our multiple videos.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Repeat the same process for the 2nd track as we did above for the first track.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    AVAssetTrack *currentAssetTrack1 = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [secondTrack setPreferredTransform:currentAssetTrack1.preferredTransform];
    
    //See how we are creating AVMutableVideoCompositionInstruction object. This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects. You set the duration of the layer. You should add the length equal to the length of the longer asset in terms of duration.
    //Here we are creating AVMutableVideoCompositionLayerInstruction for our second track.see how we make use of Affinetransform to move and scale our second Track.
    AVAssetTrack *currentAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(0.9f,0.9f);
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
    
    CGFloat FirstAssetScaleToFitRatio2 = (currentAssetTrack.naturalSize.width)/(currentAssetTrack.naturalSize.height);
    //    CGFloat FirstAssetScaleToFitRatio2 = 376.0/(currentAssetTrackOne.naturalSize.height);
    
    CGAffineTransform FirstAssetScaleFactor2 = CGAffineTransformMakeScale((FirstAssetScaleToFitRatio2),(FirstAssetScaleToFitRatio2));

    [SecondlayerInstruction setTransform:CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor2) atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, secondAsset.duration);
    //
    //    //Now we add our 2 created AVMutableVideoCompositionLayerInstruction objects to our AVMutableVideoCompositionInstruction in form of an array.
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:SecondlayerInstruction,nil];
    //
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    //    //CGSize(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.width)
    MainCompositionInst.renderSize = CGSizeMake(320, 480);
    //AVMutableAudioMix *mutableAudioMix = [AVMutableAudioMix audioMix];
    
    
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
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=urlBase;
    [exporter setVideoComposition:MainCompositionInst];
   // [exporter setAudioMix:mutableAudioMix];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //[self exportDidFinish:exporter];
//             [self overlapVideos];
             [self transFormCorrectNextVideo:urlBase];
         });
     }];
    
}

//new video to convert mov file
-(void)transFormCorrectNextVideo:(NSURL *)url{
    
//    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"secondvideo"]] options:nil];
    //new
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:moviePath] options:nil];

    CMTime duration = kCMTimeZero;
    
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our multiple videos.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Repeat the same process for the 2nd track as we did above for the first track.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    AVAssetTrack *currentAssetTrack1 = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [secondTrack setPreferredTransform:currentAssetTrack1.preferredTransform];
    
    //See how we are creating AVMutableVideoCompositionInstruction object. This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects. You set the duration of the layer. You should add the length equal to the length of the longer asset in terms of duration.
    //Here we are creating AVMutableVideoCompositionLayerInstruction for our second track.see how we make use of Affinetransform to move and scale our second Track.
    AVAssetTrack *currentAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(0.9f,0.9f);
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
    
    CGFloat FirstAssetScaleToFitRatio2 = 320.0/(currentAssetTrack.naturalSize.height);
    //    CGFloat FirstAssetScaleToFitRatio2 = 376.0/(currentAssetTrackOne.naturalSize.height);
    
    CGAffineTransform FirstAssetScaleFactor2 = CGAffineTransformMakeScale((FirstAssetScaleToFitRatio2),(FirstAssetScaleToFitRatio2 + 0.5));
    //    CGFloat FirstAssetScaleToFitRatio1 = 376.0 / currentAssetTrackOne.naturalSize.width;
    //    FirstAssetScaleToFitRatio1 = currentAssetTrackOne.naturalSize.width/(currentAssetTrackOne.naturalSize.height);

    [SecondlayerInstruction setTransform:CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor2) atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, secondAsset.duration);
    //
    //    //Now we add our 2 created AVMutableVideoCompositionLayerInstruction objects to our AVMutableVideoCompositionInstruction in form of an array.
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:SecondlayerInstruction,nil];
    //
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    //    //CGSize(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.width)
    MainCompositionInst.renderSize = CGSizeMake(320, 480);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"overlapNextVideo%u.mov",arc4random() % 10000]];
    //new
    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"overlapNextVideo.mov"]];

    [[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"secondvideo"];
    _newvideoURL = [NSURL URLWithString:myPathDocs];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    
    NSURL *urlBase = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=urlBase;
    [exporter setVideoComposition:MainCompositionInst];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //[self exportDidFinish:exporter];
             [self overlapVideos];
         });
     }];
    
}

//merge two videos
- (void)overlapVideos{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.tabBarController.tabBar.userInteractionEnabled = true;
    //First load your videos using AVURLAsset. Make sure you give the correct path of your videos.
    
    //AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"VideoPath"]] options:nil];
    
    AVURLAsset * firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"duetSingle"]] options:nil];
    //secondvideo
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults]objectForKey:@"secondvideo"]] options:nil];
    
    CMTime duration = kCMTimeZero;
    
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our multiple videos.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Now we are creating the first AVMutableCompositionTrack containing our first video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *currentAssetTrack2 = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [firstTrack setPreferredTransform:currentAssetTrack2.preferredTransform];
    
    
    //Repeat the same process for the 2nd track as we did above for the first track.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    AVAssetTrack *currentAssetTrack1 = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [secondTrack setPreferredTransform:currentAssetTrack1.preferredTransform];
    
    //See how we are creating AVMutableVideoCompositionInstruction object. This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects. You set the duration of the layer. You should add the length equal to the length of the longer asset in terms of duration.
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    //MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, );

    //naveen changed secondassert duration
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
    //MainInstruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: videoDuration)
    //We will be creating 2 AVMutableVideoCompositionLayerInstruction objects. Each for our 2 AVMutableCompositionTrack. Here we are creating AVMutableVideoCompositionLayerInstruction for out first track. See how we make use of Affinetransform to move and scale our First Track. So it is displayed at the bottom of the screen in smaller size.(First track in the one that remains on top).
    //Note: You have to apply transformation to scale and move according to your video size.
    AVAssetTrack *currentAssetTrackOne = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    CGAffineTransform Scale = CGAffineTransformMakeScale(0.0f,0.0f);
    CGAffineTransform Move = CGAffineTransformMakeTranslation(320,0);
    //[FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
    CGFloat FirstAssetScaleToFitRatio2 = (currentAssetTrackOne.naturalSize.width)/(currentAssetTrackOne.naturalSize.height);
    //    CGFloat FirstAssetScaleToFitRatio2 = 376.0/(currentAssetTrackOne.naturalSize.height);
    
    CGAffineTransform FirstAssetScaleFactor2 = CGAffineTransformMakeScale((FirstAssetScaleToFitRatio2),(FirstAssetScaleToFitRatio2));
    //    CGFloat FirstAssetScaleToFitRatio1 = 376.0 / currentAssetTrackOne.naturalSize.width;

    [FirstlayerInstruction setTransform:Move atTime:kCMTimeZero];
    //[FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale, Move) atTime:kCMTimeZero];
    
    // [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
    
    //Here we are creating AVMutableVideoCompositionLayerInstruction for our second track.see how we make use of Affinetransform to move and scale our second Track.
    AVAssetTrack *currentAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(0.0f,0.0f);
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
    
    CGSize videoSize;
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL  isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = currentAssetTrack.preferredTransform;
    
    if(videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0)
    {
        videoAssetOrientation_= UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if(videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0)
    {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    
    CGFloat FirstAssetScaleToFitRatio = 320.0 / currentAssetTrack.naturalSize.width;
    if(isVideoAssetPortrait_)
    {
        //376,266
        videoSize=CGSizeMake(320,480);
        // FirstAssetScaleToFitRatio = 376.0/(currentAssetTrack.naturalSize.height);
        CGFloat FirstAssetScaleToFitRatio1 = (currentAssetTrack.naturalSize.width)/(currentAssetTrack.naturalSize.height);
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [SecondlayerInstruction setTransform:SecondMove atTime:kCMTimeZero];
        //[SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondScale, SecondMove) atTime:kCMTimeZero];
        // [SecondlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetScaleFactor, SecondMove) atTime:kCMTimeZero];
    }
    else
    {
        videoSize=CGSizeMake(currentAssetTrack.naturalSize.width,currentAssetTrack.naturalSize.height);
    }
    
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];
    //MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
    //Now we create AVMutableVideoComposition object.We can add multiple AVMutableVideoCompositionInstruction to this object.We have only one AVMutableVideoCompositionInstruction object in our example.You can use multiple AVMutableVideoCompositionInstruction objects to add multiple layers of effects such as fade and transition but make sure that time ranges of the AVMutableVideoCompositionInstruction objects dont overlap.
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    //CGSize(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.width)
    MainCompositionInst.renderSize = CGSizeMake(640, 480);
    //    MainCompositionInst.renderSize = videoSize;
    //    MainCompositionInst.renderSize = CGSizeMake(secondTrack.naturalSize.height, secondTrack.naturalSize.width);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:@"overlapVideo.mov"];

    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
//    NSString *pathName = [NSString stringWithFormat:@"overlapVideo%u.mov",arc4random()%1000];
//    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"overlapVideo.mov"];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
    [exporter setVideoComposition:MainCompositionInst];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
    {
        AVAssetExportSessionStatus  status = exporter.status;
        if(AVAssetExportSessionStatusFailed == status) {
            NSLog(@"FAILURE: %@\n", exporter.error);
            [self showNoHandlerAlertWithTitle:@"not uploaded" andMessage:@""];
        } else if(AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"SUCCESS!\n");

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self exportDidFinish:exporter];
                    });
            
        }

    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    NSURL *outputURL = session.outputURL;
    //[[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"AudioPath"];
    // NSURL *soundFileURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"AudioPath"]];
//    NSURL *soundFileURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAudio"]];
    //new
    NSURL *soundFileURL = _soloCutMusicURL;
    
    [self mergeAudio:mergeaudioUrl withVideo:outputURL andSaveToPathUrl:@""];
    
    //    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:outputURL];
    //    [self presentMoviePlayerViewControllerAnimated:theMovie];
    //    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    //
    //    [theMovie.moviePlayer play];
    //here you have the output URL of the final overlapped video. Add your desired task here.
}

#pragma mark - LyricPlayer Data Source
- (NSArray *)timesForLyricPlayerView:(VTXLyricPlayerView *)lpv {
    return keysTiming;
}

- (VTXKaraokeLyricView *)lyricPlayerView:(VTXLyricPlayerView *)lpv lyricAtIndex:(NSInteger)index {
    VTXKaraokeLyricView *lyricView = [lpv reuseLyricView];
    // Config lyric view
    
    // [lyricView setFillTextColor:[UIColor redColor]];
    lyricView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    
    NSString *key = [keysTiming objectAtIndex:index];
    lyricView.text = [self.lyric.content objectForKey:key];
    NSLog(@" lyricView.text==%@", lyricView.text);
    NSString *newstring = lyricView.text;
    NSString *firstLetter = [newstring substringFromIndex:0];
    
    //vinoth
    if ([firstLetter containsString:@"(M)"]) {
        lyricView.textColor = [UIColor colorWithRed:115/255.0f green:253/255.0f blue:255/255.0f alpha:1];
        // [lyricView anothercolor:[UIColor blueColor]];
        [lyricView setFillTextColor:[UIColor whiteColor]];
    }else  if ([firstLetter containsString:@"(F)"]) {
        lyricView.textColor = [UIColor colorWithRed:255/255.0f green:126/255.0f blue:121/255.0f alpha:1];
        [lyricView setFillTextColor:[UIColor whiteColor]];
    }else{
        lyricView.textColor = [UIColor colorWithRed:115/255.0f green:253/255.0f blue:255/255.0f alpha:1];
        [lyricView setFillTextColor:[UIColor whiteColor]];
    }
    
    NSLog(@"fistleeter==%@", firstLetter);
    
    return lyricView;
}

- (BOOL)lyricPlayerView:(VTXLyricPlayerView *)lpv allowLyricAnimationAtIndex:(NSInteger)index {
    // Allow all
    return YES;
}

#pragma mark - LyricPlayer Delegate
- (void)lyricPlayerViewDidStarted:(VTXLyricPlayerView *)lpv {
    //  [self.toogleButton setTitle:@"Pause" forState:UIControlStateNormal];
    //    self.toogleButton.tag = 1;
}

- (void)lyricPlayerViewDidStoped:(VTXLyricPlayerView *)lpv {
    //[playerTimer invalidate];
}


//finally merge two merged audio and videos
-(void)mergeAudio:(NSURL *) audioURL withVideo:(NSURL *) videoURL andSaveToPathUrl:(NSString *) savePath{
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    CMTime duration = kCMTimeZero;
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideotemp.mp4"]];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    //NSURL    *savetUrl = [NSURL fileURLWithPath:savePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    
    
    _assetExport.outputURL = url;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         NSLog(@"fileSaved !");
             
////             //new test
//             self->playerItem = [AVPlayerItem playerItemWithURL:url];
//             self->playVideo = [[AVPlayer alloc] initWithPlayerItem:self->playerItem];
//             self->playerViewController = [[AVPlayerViewController alloc] init];
//             self->playerViewController.player = self->playVideo;
//             //             self->playerViewController.view.frame=CGRectMake(0,0,self.playView.frame.size.width,self.playView.frame.size.height);
//             // self->playerViewController.player.volume = 30;
//             self->playerViewController.showsPlaybackControls = true;
//             // playerViewController.view.frame = self.totalview.bounds;
//             [self->playVideo play];
//             [self presentViewController:self->playerViewController animated:true completion:^{
//
//             }];
         
             
             //             [self.playView addSubview:self->playerViewController.view];
             
             
//main
             [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully recorded, You Want to Play and Upload ?" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {

                 if ([action.title isEqualToString:@"Yes"]){
                     self.duetFinallvideoURL = url;

                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self performSegueWithIdentifier:@"SegueSoloMusicToVideoUpload" sender:nil];
                     });
                 }else if ([action.title isEqualToString:@"No"]){

                     [self.navigationController popViewControllerAnimated:YES];
                 }

             }];
         
         
         
     }];
    
    
}

-(void)getImageFromUrl:(NSURL *)sender{
    
    NSURL *url=(NSURL*)sender;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    NSLog(@"err = %@, imageRef = %@", err, imgRef);
    _thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    _placeHolderImg.image = _thumbnailImage;

    CGImageRelease(imgRef);
    
}

////soloextractsingle audio
//-(void)extractAudiofromvideoPath: (NSURL *)audiopath{
//    
//    AVMutableComposition*   newAudioAsset = [AVMutableComposition composition];
//    // NSString *path = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"mp4"];
//    // NSURL *soundFileURL = [NSURL fileURLWithPath:audiopath];
//    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:audiopath options:nil];
//    
//    AVMutableCompositionTrack*  dstCompositionTrack;
//    dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    [dstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
//                                 ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//    
//    AVAssetExportSession*   exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
//    
//    exportSesh.outputFileType = AVFileTypeCoreAudioFormat;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
////    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo%-dtemp.caf",arc4random() % 10000]];
//    //remove random
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideotemp.caf"]];
//
//    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
//    }
//    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
//    
//    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    //    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"soundOneNew.mp3"];
//    [[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"selectedAudio"];
//    exportSesh.outputURL=url;
//    
//    _soloCutMusicURL = url;
//    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
//        AVAssetExportSessionStatus  status = exportSesh.status;
//        NSLog(@"exportAsynchronouslyWithCompletionHandler: %i\n", status);
//        
//        if(AVAssetExportSessionStatusFailed == status) {
//            NSLog(@"FAILURE: %@\n", exportSesh.error);
//        } else if(AVAssetExportSessionStatusCompleted == status) {
//            NSLog(@"SUCCESS!\n");
////            static dispatch_once_t onceToken;
////
////            dispatch_async(dispatch_get_main_queue(), ^{
//////                [self performSegueWithIdentifier:@"duetClass" sender:nil];
////
////            });
////
////            NSError *error;
//            
//
//            
//        }
//    }];
//}
-(void)viewWillDisappear:(BOOL)animated {
    [self.sliderTimer invalidate];
    [self stopAll];
    
}
//MARK: validate headphones insorted or not
- (BOOL)areHeadphonesPluggedIn {
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueSoloMusicToVideoUpload"]) {
        SoloVideoPlayerViewController *videoVC  = segue.destinationViewController;
        videoVC.videoURL = self.duetFinallvideoURL;
        videoVC.songTitle = _songTitle;
        if ([_selectionType isEqualToString:@"notification"]) {
            videoVC.invitesselectedValue = _invitesselectedValue;
        }else{
            videoVC.soloselectedValue = _soloselectedValue;
        }
        videoVC.selectionType = _selectionType;
        videoVC.solo_voice_part = _solo_voice_part;

    }
    
}

@end
