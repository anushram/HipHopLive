//
//  RapMusicRecordViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 23/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "RapMusicRecordViewController.h"

@interface RapMusicRecordViewController ()
{
    AVAudioPlayer *audioPlayer;
    //Lyrics view
    NSArray *keysTiming;
}

@end

@implementation RapMusicRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden =false;

    [self updateUI];
    [self camerRecordVideo];
    [self setNavigationBar:@"Record"];

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
-(void)updateUI{
    
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    self.isPlaying = false;
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    
    NSError *audioError = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_musicURL error:&audioError];
    audioPlayer.delegate = self;
    audioPlayer.volume = 0.5;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioPlayer prepareToPlay];
    
    //    [self.lyricPlayer prepareToPlay];
    //    [self.lyricPlayer start];
    //    [self.lyricPlayer pause];
    
    
    [self.slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged];
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
-(void)startRecord{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueRapMusicToRecord" sender:nil];
    });
}
//Lycrics view
- (void)stopAll {
    //1.
    //    [_sliderTimer invalidate];
    //    [audioPlayer stop];
    //    [self.lyricPlayer stop];
    
    [_sliderTimer invalidate];
    [audioPlayer stop];
    [self.lyricPlayer stop];
    //    [self updateUI];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //1.
    [audioPlayer prepareToPlay];
    [self.lyricPlayer prepareToPlay];
    //
    //    [self setTitle:self.lyric.title];
}
- (void)viewDidDisappear:(BOOL)animated {
    [self stopAll];
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
            [_pickerController stopVideoCapture];
            [self.lyricPlayer pause];
            self.isPlaying = !self.isPlaying;
        }
        else
        {
            [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PauseImg"] forState:UIControlStateNormal];
            _playPause_Btn.hidden = true;
            // Music is currenty paused/stopped
            [self.lyricPlayer resume];
            [audioPlayer play];
            [_pickerController startVideoCapture];
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
    [_pickerController stopVideoCapture];

    [self.lyricPlayer stop];
    [self.sliderTimer invalidate];
    self.slider.value = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:audioPlayer.duration]];
    
    self.isPlaying = false;
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    
    NSError *audioError = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_musicURL error:&audioError];
    audioPlayer.delegate = self;
    audioPlayer.volume = 0.5;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioPlayer prepareToPlay];
    
    
    [self.lyricPlayer prepareToPlay];
    [self.lyricPlayer start];
    [self.lyricPlayer pause];
    
}

- (void)sliderChanged:(UISlider *)sender
{
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PauseImg"] forState:UIControlStateNormal];
    _stop_Btn.userInteractionEnabled = true;
    _stop_Btn.alpha = 1;
    // skips music with slider changged
    [audioPlayer pause];
    [audioPlayer setCurrentTime:self.slider.value];
    [audioPlayer play];
    
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

// Stops the timer when audio finishes
- (void)audioPlayerDidFinishPlaying : (AVAudioPlayer *)player successfully:(BOOL)flag
{
    // Music completed
    if (flag)
    {
        [self.sliderTimer invalidate];
        self.slider.value = 0;
        self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:audioPlayer.duration]];
        self.isPlaying = false;
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
        _stop_Btn.userInteractionEnabled = false;
        _stop_Btn.alpha = 0.5;
        
        [_pickerController stopVideoCapture];

        [self.lyricPlayer stop];
        [self.lyricPlayer prepareToPlay];
        [self.lyricPlayer start];
        [self.lyricPlayer pause];
        
        _playPause_Btn.hidden = false;

        
    }
}
- (IBAction)start_Action:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueRapMusicToRecord" sender:nil];
    });
    
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.sliderTimer invalidate];
    
}


//MARK: video and audio record
#pragma mark - camera
-(void)camerRecordVideo{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        _pickerController.delegate = self;
        
        _pickerController.view.frame=CGRectMake(0,0,self.cameraView.frame.size.width,self.cameraView.frame.size.height);
        _pickerController.allowsEditing = YES;
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        _pickerController.showsCameraControls =NO;
        _pickerController.toolbarHidden = YES;
        _pickerController.extendedLayoutIncludesOpaqueBars = YES;
        _pickerController.wantsFullScreenLayout = YES;

        [self.cameraView addSubview:_pickerController.view];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    
    _mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    URL_str = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    _moviePath =(NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
    NSURL *url = [NSURL fileURLWithPath:_moviePath];
    NSLog(@"urlstr==%@",url);
    [self extract:url];
    // [self mergeAudio:_songURL withVideo:url andSaveToPathUrl:@""];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [audioPlayer stop];
    [self.lyricPlayer stop];
    
}

#pragma mark- merger video and audio

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
            [self mergeTwoAudio:self->_musicURL audio:url1];

            
        }
    }];
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

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
    
    AVAssetExportSession*   exportSesh = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    
    exportSesh.outputFileType = AVFileTypeMPEG4;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"merge%-dtemp.mp4",arc4random() % 10000]];
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
            
            NSURL *urlVideo = [NSURL fileURLWithPath:self->_moviePath];
            [self mergeAudio:url withVideo:urlVideo andSaveToPathUrl:@""];
            
        }
    }];
    
    
    
}

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
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    AVAssetTrack *currentAssetTrack1 = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack setPreferredTransform:currentAssetTrack1.preferredTransform];
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:currentAssetTrack1];
    
    
    CGSize videoSize;
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL  isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = currentAssetTrack1.preferredTransform;
    
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
    
    CGFloat FirstAssetScaleToFitRatio = 376.0 / currentAssetTrack1.naturalSize.width;
    if(isVideoAssetPortrait_)
    {
        //376,266
        videoSize=CGSizeMake(350,480);
        FirstAssetScaleToFitRatio = 376.0/(currentAssetTrack1.naturalSize.height);
        CGFloat FirstAssetScaleToFitRatio1 = 376.0/(currentAssetTrack1.naturalSize.height);
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [SecondlayerInstruction setTransform:CGAffineTransformConcat(currentAssetTrack1.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }
    else
    {
        videoSize=CGSizeMake(currentAssetTrack1.naturalSize.width,currentAssetTrack1.naturalSize.height);
    }
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    //CGSize(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.width)
    MainCompositionInst.renderSize = CGSizeMake(640, 480);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo%-dtemp.mp4",arc4random() % 10000]];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeWithVideo.mp4"]];

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
//         dispatch_async(dispatch_get_main_queue(), ^{
         
         [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully recorded, You Want to Play and Upload ?" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {
             
             if ([action.title isEqualToString:@"Yes"]){
                 self->_video_url =  _assetExport.outputURL;
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self performSegueWithIdentifier:@"SegueRapMusicToVideo" sender:nil];
                 });
             }else if ([action.title isEqualToString:@"No"]){
                 
             }
             
         }];
         

//         });
         
     }];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueRapMusicToVideo"]) {
        RapVideoPlayerViewController *rapVC  = segue.destinationViewController;
        rapVC.getVideoURL = _video_url;
        rapVC.songTitle = self.lyric.title;
        rapVC.rapValue = _rapValue;
        rapVC.music_type = _music_type;

    }
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


@end
