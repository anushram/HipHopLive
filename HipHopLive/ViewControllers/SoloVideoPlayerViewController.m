//
//  SoloVideoPlayerViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "SoloVideoPlayerViewController.h"

@interface SoloVideoPlayerViewController ()
{
    AVPlayerViewController *playerViewController;
    NSString *thumbnailbase64String;
}
@end

@implementation SoloVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar:_songTitle];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = playVideo;
    playerViewController.player.volume = 0.5;
    // playerViewController.view.frame = self.videoview.bounds;
    
    //////thumbnailbase64String
    AVAsset *asset = [AVAsset assetWithURL:_videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    //    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imageRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    [self.thumImg setImage:thumbnail];
    
    NSData *imageData = UIImageJPEGRepresentation(thumbnail, 1);
    thumbnailbase64String = [imageData base64EncodedStringWithOptions:0];
    
    ///////thumbnailbase64String
    
    playerViewController.view.frame=CGRectMake(0,0,self.videoview.frame.size.width,self.videoview.frame.size.height);
    [self.videoview addSubview:playerViewController.view];
    [playVideo play];
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    
    [self showAlertWithTitle:@"" andMessage:@"You Want to Upload ?" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {
        
        if ([action.title isEqualToString:@"Yes"]){
            
            if ([self->_selectionType isEqualToString:@"notification"]) {
                [self acceptinvites];
            }else{
                [self uploadAction];
            }
            
        }else if ([action.title isEqualToString:@"No"]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
    
}

- (void)acceptinvites {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/acceptinvites",Base_URL]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:self->_videoURL];
        if(data == nil && error!=nil) {
            //Print error description
        }
        
        //new
        //        NSData *imageData = [NSData dataWithContentsOfFile:str];
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        //            NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:self->_invitesselectedValue.id] forKey:@"invite_id"];
        
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        
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
                        //                            NSError *error;
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"acceptinvites response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            [self uploadAction];

                        }else{
                            [self showNoHandlerAlertWithTitle:@"acceptinvites failed 👎" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                        }
                        
                    }else{
                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"acceptinvites failed 👎" andMessage:str];
                    
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

- (void)uploadAction {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/duetinsert",Base_URL]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:self->_videoURL];
        if(data == nil && error!=nil) {
            //Print error description
        }
        
        //new
        //        NSData *imageData = [NSData dataWithContentsOfFile:str];
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        //            NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:base64String forKey:@"music_duet_file"];
        [paramDic setObject:self->thumbnailbase64String forKey:@"music_duet_image"];
        if ([self->_selectionType isEqualToString:@"notification"]) {
            [paramDic setObject:[NSNumber numberWithInteger:self->_invitesselectedValue.music_soloid] forKey:@"music_solo_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_invitesselectedValue.music_id] forKey:@"music_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_invitesselectedValue.category_id] forKey:@"category_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_invitesselectedValue.user_id] forKey:@"from_user_id"];
        }else{
            [paramDic setObject:[NSNumber numberWithInt:self->_soloselectedValue.id] forKey:@"music_solo_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_soloselectedValue.music_id] forKey:@"music_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_soloselectedValue.category_id] forKey:@"category_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_soloselectedValue.user_id] forKey:@"from_user_id"];
        }
        
        [paramDic setObject:self->_solo_voice_part forKey:@"duet_voice_part"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        
        
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
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"duetinsert response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            [self showAlertWithTitle:@"Wow 👍" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                
                                if ([action.title isEqualToString:@"Ok"]){
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                    
//                                    if ([self->_selectionType isEqualToString:@"notification"]) {
//                                        [self.navigationController popViewControllerAnimated:YES];
//                                    }else{
//                                    }
                                }
                                
                            }];
                        }else{
                            [self showNoHandlerAlertWithTitle:@"Upload failed 👎" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                        }
                        
                        
                    }else{
                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Upload failed 👎" andMessage:str];
                    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
