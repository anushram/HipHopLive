//
//  SoloMusicViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 28/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "SoloMusicViewController.h"

@interface SoloMusicViewController ()
{
    AVAudioPlayer *audioPlayer;
    //Lyrics view
    NSArray *keysTiming;
    
    AVPlayerViewController *playerViewController;
    AVPlayer* playVideo;
    NSURL *soloCutMusicURL;
    
}
@end

@implementation SoloMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    if ([_selectionType isEqualToString:@"notification"]){
        if ([_invitesselectedValue.solo_voice_part isEqualToString:@"male"]) {
            _solo_voice_part = @"female";
        }else{
            _solo_voice_part = @"male";
        }
    }else{
        if ([_soloselectedValue.solo_voice_part isEqualToString:@"male"]) {
            _solo_voice_part = @"female";
        }else{
            _solo_voice_part = @"male";
        }
        [self viewEntry];
    }
}

-(void)updateUI{

    
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    self.isPlaying = false;
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    
//    NSError *audioError = nil;
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_musicURL error:&audioError];
//    audioPlayer.delegate = self;
//    audioPlayer.volume = 0.5;
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//    [audioPlayer prepareToPlay];
    
    //videoPlayer
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = playVideo;
    playerViewController.player.volume = 0.5;
    // playerViewController.view.frame = self.videoview.bounds;
    playerViewController.showsPlaybackControls = false;
    playerViewController.view.frame=CGRectMake(0,0,self.videoview.frame.size.width,self.videoview.frame.size.height);
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [self.videoview addSubview:playerViewController.view];
    
    //    [self.lyricPlayer prepareToPlay];
    //    [self.lyricPlayer start];
    //    [self.lyricPlayer pause];
    
    CMTime duration = playVideo.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    [self.slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged];
    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:seconds]];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = seconds;
    
    //Lyrics view
    self.lyricPlayer.dataSource = self;
    self.lyricPlayer.delegate = self;
    _title_Lbl.text = self.lyric.title;
    
    [self setNavigationBar:self.lyric.title];
    
    if ([_selectionType isEqualToString:@"profileview"]){
        
    }else{
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(self.view.frame.size.width - 0, 0, 40, 32);
        [backBtn setTitle:@"Join" forState:UIControlStateNormal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.rightBarButtonItem = backButton;
    }
    
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
        [self extractAudiofromvideoPath:self->_videoURL];

    });
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
    
    if (self.isPlaying)
    {
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
        // Music is currently playing
        [playVideo pause];
        [self.lyricPlayer pause];
        self.isPlaying = !self.isPlaying;
    }
    else
    {
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PauseImg"] forState:UIControlStateNormal];
        // Music is currenty paused/stopped
        [self.lyricPlayer resume];
        [playVideo play];
        self.isPlaying = !self.isPlaying;
        self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        _stop_Btn.userInteractionEnabled = true;
        _stop_Btn.alpha = 1;
    }
}
- (IBAction)stop_Action:(id)sender {
    //1.
    [playVideo pause];
    [self.lyricPlayer stop];
    [self.sliderTimer invalidate];
    self.slider.value = 0;
//    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:audioPlayer.duration]];
    
    self.isPlaying = false;
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    
    //videoPlayer
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = playVideo;
    playerViewController.player.volume = 0.5;
    // playerViewController.view.frame = self.videoview.bounds;
    playerViewController.showsPlaybackControls = false;
    playerViewController.view.frame=CGRectMake(0,0,self.videoview.frame.size.width,self.videoview.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    [self.videoview addSubview:playerViewController.view];
    
    CMTime duration = playVideo.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    [self.slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged];
    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:seconds]];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = seconds;
    
    
//    NSError *audioError = nil;
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_musicURL error:&audioError];
//    audioPlayer.delegate = self;
//    audioPlayer.volume = 0.5;
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//    [audioPlayer prepareToPlay];
    
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
    AVPlayerItem *currentItem = playVideo.currentItem;
//    CMTime duration = currentItem.duration; //total time
    CMTime currentTime = currentItem.currentTime;
    self.slider.value = CMTimeGetSeconds(currentTime);
    
    NSString *time = [self timeFormatted:self.slider.value];
    self.timerLabel.text = time;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    AVPlayerItem *currentItem = playVideo.currentItem;
    CMTime duration = currentItem.duration; //total time
//    CMTime currentTime = currentItem.currentTime;
    
    return [NSString stringWithFormat:@"%02d:%02d / %@", minutes, seconds ,[self durationtimeFormatted:CMTimeGetSeconds(duration)]];
}

- (NSString *)durationtimeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self.sliderTimer invalidate];
    self.slider.value = 0;
//    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:seconds]];
    self.isPlaying = false;
    [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
    _stop_Btn.userInteractionEnabled = false;
    _stop_Btn.alpha = 0.5;
    
    //videoPlayer
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = playVideo;
    playerViewController.player.volume = 0.5;
    // playerViewController.view.frame = self.videoview.bounds;
    playerViewController.showsPlaybackControls = false;
    playerViewController.view.frame=CGRectMake(0,0,self.videoview.frame.size.width,self.videoview.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    [self.videoview addSubview:playerViewController.view];
    
    CMTime duration = playVideo.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    [self.slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged];
    self.timerLabel.text = [NSString stringWithFormat:@"00:00 / %@" ,[self durationtimeFormatted:seconds]];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = seconds;
    
    [self.lyricPlayer stop];
    [self.lyricPlayer prepareToPlay];
    [self.lyricPlayer start];
    [self.lyricPlayer pause];
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
        
        [self.lyricPlayer stop];
        [self.lyricPlayer prepareToPlay];
        [self.lyricPlayer start];
        [self.lyricPlayer pause];
        
    }
}
- (IBAction)start_Action:(id)sender {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self extractAudiofromvideoPath:self->_videoURL];
//    });
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.sliderTimer invalidate];
    [self stopAll];

}

-(void)viewEntry{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicview",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:[NSNumber numberWithInteger:self->_soloselectedValue.music_id] forKey:@"music_id"];
        [paramDic setObject:@"solo" forKey:@"music_type"];
        [paramDic setObject:[NSNumber numberWithInt:self->_soloselectedValue.id] forKey:@"music_solo_id"];

        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            
            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        // NSError *error;
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"musicview response = %@",str);
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            
                        }else{
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                        }
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                    
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = false;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueSoloMusicToRecord"]) {
        SoloMusicRecordViewController *videoVC  = segue.destinationViewController;
        videoVC.videoURL = _videoURL;
        videoVC.songTitle = _songTitle;
        videoVC.lyric = _lyric;
        videoVC.soloCutMusicURL = soloCutMusicURL;
        if ([_selectionType isEqualToString:@"notification"]) {
            videoVC.invitesselectedValue = _invitesselectedValue;
//            videoVC.solo_voice_part = _invitesselectedV;
        }else{
            videoVC.soloselectedValue = _soloselectedValue;
//            videoVC.solo_voice_part =
        }
        videoVC.selectionType = _selectionType;
        videoVC.solo_voice_part = _solo_voice_part;
    }
    
}

//soloextractsingle audio
-(void)extractAudiofromvideoPath:(NSURL *)audiopath{
    
    AVMutableComposition*   newAudioAsset = [AVMutableComposition composition];
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"mp4"];
    // NSURL *soundFileURL = [NSURL fileURLWithPath:audiopath];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:audiopath options:nil];
    
    AVMutableCompositionTrack*  dstCompositionTrack;
    dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [dstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                 ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession*   exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
    
    exportSesh.outputFileType = AVFileTypeCoreAudioFormat;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo%-dtemp.caf",arc4random() % 10000]];
    //remove random
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideotemp.caf"]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *audioPath = [documentsDirectory stringByAppendingPathComponent:@"soundOneNew.mp3"];
    [[NSUserDefaults standardUserDefaults] setObject:myPathDocs forKey:@"selectedAudio"];
    exportSesh.outputURL=url;
    
    soloCutMusicURL = url;
    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus  status = exportSesh.status;
        NSLog(@"exportAsynchronouslyWithCompletionHandler: %li\n", (long)status);
        
        if(AVAssetExportSessionStatusFailed == status) {
            NSLog(@"FAILURE: %@\n", exportSesh.error);
        } else if(AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"SUCCESS!\n");
            //            static dispatch_once_t onceToken;
            //
            //            dispatch_async(dispatch_get_main_queue(), ^{
            ////                [self performSegueWithIdentifier:@"duetClass" sender:nil];
            //
            //            });
            //
            //            NSError *error;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                [self showAlertWithTitle:[NSString stringWithFormat:@"Remaining part %@ is there you like to sign ?",self->_solo_voice_part] andMessage:@"" buttonTitles:@[@"Ok",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {
                    if ([action.title isEqualToString:@"Ok"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"SegueSoloMusicToRecord" sender:nil];
                        });
                    }else{

                    }
                }];
                
//            [self performSegueWithIdentifier:@"SegueSoloMusicToRecord" sender:nil];

            });
            
        }
    }];
}

@end
