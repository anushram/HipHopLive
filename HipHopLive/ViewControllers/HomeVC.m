//
//  HomeVC.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/02/22.
//  Copyright © 2022 Securenext. All rights reserved.
//

#import "HomeVC.h"
#import "NewFeedCVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize musicallFeed_Arr = _musicallFeed_Arr, videoCollectionView = _videoCollectionView, playerViewController = _playerViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getCollabsList];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setCollectionData:@"http://techslides.com/demos/sample-videos/small.mp4"];
}

-(void)viewDidLayoutSubviews{
    
}

-(void)setCollectionData: (NSString *)data{
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
     

    
    NSURL *url = [NSURL URLWithString:data];
//        if ([data isKindOfClass: [MusicDuetFeed class]]) {
//            MusicDuetFeed *duet = (MusicDuetFeed *)data;
//            url = [NSURL URLWithString:duet.record_filename];
//        }else{
//            MusicSoloFeed *single = (MusicSoloFeed *)data;
//            url = [NSURL URLWithString:single.record_filename];
//        }
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
    backgroundLayer.backgroundColor = [UIColor systemBlueColor].CGColor;
    backgroundLayer.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"home-page-top-bg"] CGImage]);
    backgroundLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    CALayer *videoLayer = [[CALayer alloc] init];
    videoLayer.frame = CGRectMake(20, 20, firstVideoAssetTrack.naturalSize.width - 40, firstVideoAssetTrack.naturalSize.height - 40);
    
    CALayer *overlayLayer = [[CALayer alloc] init];
    overlayLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width, firstVideoAssetTrack.naturalSize.height);
    
    CALayer *outputLayer = [[CALayer alloc] init];
    outputLayer.frame = CGRectMake(0, 0, firstVideoAssetTrack.naturalSize.width, firstVideoAssetTrack.naturalSize.height);
    
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.frame = CGRectMake(20, 20, 50, 100);
    imageLayer.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"home-page-top-bg"] CGImage]);
    [overlayLayer addSublayer:imageLayer];
    
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
    
    //AVAssetExportPresetHighestQuality
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName: AVAssetExportPresetLowQuality];
    
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
             playVideo.automaticallyWaitsToMinimizeStalling = NO;
             self.playerViewController.showsPlaybackControls = YES;
             self.playerViewController.videoGravity = AVLayerVideoGravityResize;
             CGPoint center = self.view.center;
             self.playerViewController.view.frame=CGRectMake(center.x,center.y,300,300);
             self.playerViewController.view.center = center;
             [self.view addSubview:self.playerViewController.view];
             [playVideo play];
         });
     }];

}

-(void)getCollabsList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicfeed",Base_URL]];

        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        //[paramDic setObject:self->_searchBar.text forKey:@"search"];
        
        //        NSString *post = nil;
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
                        NSLog(@"musicfeed response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            MusicFeedResponse *object = [[MusicFeedResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"musicfeed Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                self.musicallFeed_Arr = [[NSMutableArray alloc]init];
                                [self.musicallFeed_Arr addObjectsFromArray:object.musicDuetFeed];
                                [self.musicallFeed_Arr addObjectsFromArray:object.musicSoloFeed];
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    //self->_musicDuetFeed_Arr = [object.musicDuetFeed mutableCopy];
                                    
                                    //self->_musicSoloFeed_Arr = [object.musicSoloFeed mutableCopy];
                                    [self.videoCollectionView reloadData];
                                    
                                });
                            }
                        }else{
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                        }
                        
                    }else{
                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//# MARK: uicollectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.musicallFeed_Arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"newfeed";
    NSLog(@"collection section= %ld",(long)indexPath.section);
    NewFeedCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        if ([[self.musicallFeed_Arr objectAtIndex: indexPath.row] isKindOfClass: [MusicDuetFeed class]]) {
            if (cell.urlStr == nil){
                cell.urlStr = ((MusicDuetFeed *)[self.musicallFeed_Arr objectAtIndex: indexPath.row]).record_filename;
            }
            
        }else{
            if (cell.urlStr == nil){
                cell.urlStr = ((MusicSoloFeed *)[self.musicallFeed_Arr objectAtIndex: indexPath.row]).record_filename;
            }
            
        }
    
   // [cell setCollectionData: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NewFeedCVC *cellOne = (NewFeedCVC *) cell;
    NSLog(@"did=%ld", (long)indexPath.row);
    //[cellOne.playVideoRef pause];
    //[cellOne stopVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NewFeedCVC *cellOne = (NewFeedCVC *) cell;
    NSLog(@"will=%ld", (long)indexPath.row);
   // [cellOne.playVideoRef play];
    //[cellOne resumeVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

      NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
      return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    
//    for (int i = 0; i< [self.videoCollectionView visibleCells].count; i++) {
//        if (i == 0) {
//            UICollectionViewCell *cell = [self.videoCollectionView visibleCells][i];
//            NSIndexPath *indexPath = [self.videoCollectionView indexPathForCell:cell];
//            NewFeedCVC *cellOne = (NewFeedCVC *) cell;
//            [cellOne resumeVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
//            NSLog(@"nnnnnnn%@",indexPath);
//        }else{
//            UICollectionViewCell *cell = [self.videoCollectionView visibleCells][i];
//            NSIndexPath *indexPath = [self.videoCollectionView indexPathForCell:cell];
//            NewFeedCVC *cellOne = (NewFeedCVC *) cell;
//            [cellOne stopVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
//        }
//    }
    
    for (UICollectionViewCell *cell in [self.videoCollectionView visibleCells]) {
        
        NSIndexPath *indexPath = [self.videoCollectionView indexPathForCell:cell];
        NewFeedCVC *cellOne = (NewFeedCVC *) cell;
        [cellOne stopVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
    }
    
    //let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    CGRect visibleRect = CGRectMake(self.videoCollectionView.contentOffset.x, self.videoCollectionView.contentOffset.y, self.videoCollectionView.bounds.size.width, self.videoCollectionView.bounds.size.height);
    
    //let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    
    CGPoint visiblePoint = CGPointMake(visibleRect.origin.x, visibleRect.origin.y);
    NSIndexPath *indexPathOne = [self.videoCollectionView indexPathForItemAtPoint: visiblePoint];
    UICollectionViewCell *cell = [self.videoCollectionView cellForItemAtIndexPath:indexPathOne];
    NewFeedCVC *cellOne = (NewFeedCVC *) cell;
    [cellOne resumeVideo: [self.musicallFeed_Arr objectAtIndex: indexPathOne.row]];
    NSLog(@"nut%ld",(long)indexPathOne.row);
    
    [self.videoCollectionView scrollRectToVisible:cellOne.frame animated:true];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.videoCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.videoCollectionView indexPathForCell:cell];
        NewFeedCVC *cellOne = (NewFeedCVC *) cell;
        [cellOne stopVideo: [self.musicallFeed_Arr objectAtIndex: indexPath.row]];
        NSLog(@"nnnnnnn%@",indexPath);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
