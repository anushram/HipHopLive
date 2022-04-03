//
//  RapMusicViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "RapMusicViewController.h"

@interface RapMusicViewController ()
{
    AVAudioPlayer *audioPlayer;
    //Lyrics view
    NSArray *keysTiming;

}
@end

@implementation RapMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}
-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden =true;
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
    _title_Lbl.text = self.lyric.title;
    
    [self setNavigationBar:self.lyric.title];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(self.view.frame.size.width - 0, 0, 40, 32);
    [backBtn setTitle:@"Start" forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backButton;
    
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
    
    if ([_rapValue.music_type isEqualToString:@"solo"]) {
        [self showAlertWithTitle:@"Which part would you like to sign ?" andMessage:@"" buttonTitles:@[@"Solo",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"Solo"]){
                self->_music_type = @"solo";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"SegueRapMusicToRecord" sender:nil];
                });
            }else{
                
            }
        }];
    }else{
        [self showAlertWithTitle:@"Which part would you like to sign ?" andMessage:@"" buttonTitles:@[@"Male",@"Female",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"Male"]){
                self->_music_type = @"male";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"SegueRapMusicToRecord" sender:nil];
                });
            }else if ([action.title isEqualToString:@"Female"]){
                self->_music_type = @"female";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"SegueRapMusicToRecord" sender:nil];
                });
            }else{
                
            }
        }];
    }
    
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
    
    if (self.isPlaying)
    {
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PlayImg"] forState:UIControlStateNormal];
        // Music is currently playing
        [audioPlayer pause];
        [self.lyricPlayer pause];
        self.isPlaying = !self.isPlaying;
    }
    else
    {
        [_playPause_Btn setBackgroundImage:[UIImage imageNamed:@"PauseImg"] forState:UIControlStateNormal];
        // Music is currenty paused/stopped
        [self.lyricPlayer resume];
        [audioPlayer play];
        self.isPlaying = !self.isPlaying;
        self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        _stop_Btn.userInteractionEnabled = true;
        _stop_Btn.alpha = 1;
    }
}
- (IBAction)stop_Action:(id)sender {
    //1.
    [audioPlayer stop];
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
        
        [self.lyricPlayer stop];
        [self.lyricPlayer prepareToPlay];
        [self.lyricPlayer start];
        [self.lyricPlayer pause];

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

-(void)viewWillDisappear:(BOOL)animated {
    [self.sliderTimer invalidate];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueRapMusicToRecord"]) {
        RapMusicViewController *rapVC  = segue.destinationViewController;
        rapVC.musicURL = _musicURL;
        rapVC.lyric = _lyric;
        rapVC.rapValue = _rapValue;
        rapVC.music_type = _music_type;
    }
    
}


@end
