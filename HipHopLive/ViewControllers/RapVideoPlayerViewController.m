//
//  RapVideoPlayerViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "RapVideoPlayerViewController.h"
#import <AVKit/AVKit.h>


@interface RapVideoPlayerViewController ()
{
    AVPlayerViewController *playerViewController;
    NSString *thumbnailbase64String;
    
    //send data
    NSString *music_solo_id;
    NSString *music_id;
}
@end

@implementation RapVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar:_songTitle];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:_getVideoURL];
    AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = playVideo;
    playerViewController.player.volume = 0.5;
    // playerViewController.view.frame = self.videoview.bounds;
    
    //////thumbnailbase64String
    AVAsset *asset = [AVAsset assetWithURL:_getVideoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
     UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imageRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationRight];
    
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
            
            [self uploadAction];

        }else if ([action.title isEqualToString:@"No"]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
    
}

- (void)uploadAction {

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));

            if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
                [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
                return ;
            }

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/soloinsert",Base_URL]];

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = false;

        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:self->_getVideoURL];
        if(data == nil && error!=nil) {
            //Print error description
        }
        
            //new
//        NSData *imageData = [NSData dataWithContentsOfFile:str];
            NSString *base64String = [data base64EncodedStringWithOptions:0];
            //            NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
            [paramDic setObject:base64String forKey:@"music_solo_file"];
            [paramDic setObject:self->thumbnailbase64String forKey:@"music_solo_image"];
            [paramDic setObject:[NSNumber numberWithInt:self->_rapValue.id] forKey:@"music_id"];
            [paramDic setObject:[NSNumber numberWithInteger:self->_rapValue.category_id] forKey:@"category_id"];
            [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
            [paramDic setObject:self->_music_type forKey:@"solo_voice_part"];

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
                            NSLog(@"RapVideo response = %@",str);

                            NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                            if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]) {
                                [self showAlertWithTitle:@"Wow 👍" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {

                                    if ([action.title isEqualToString:@"Ok"]){
//                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        [self showAlertWithTitle:@"You Want to invite HipHopLive Users ?" andMessage:@"" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {
                                            
                                            if ([action.title isEqualToString:@"No"]){
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }else{
                                                NSDictionary *dic = [returnedDict objectForKey:@"Music"];
                                                self->music_id = [dic objectForKey:@"music_id"];
                                                self->music_solo_id = [dic objectForKey:@"id"];

                                                [self performSegueWithIdentifier:@"SegueRapVideoToUserInvite" sender:nil];
                                                
                                            }
                                            
                                        }];
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
- (void)multipartupload {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        
        
        NSLog(@"POSTING");
        NSData *data = [NSData dataWithContentsOfURL:self->_getVideoURL];

        // Generate the postdata:
        NSData *postData = [self generatePostDataForData: data];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        // Setup the request:
        NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/soloinsert",Base_URL]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 30];
        [uploadRequest setHTTPMethod:@"POST"];
        [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
        [uploadRequest setHTTPBody:postData];
        
        [uploadRequest setValue:self->thumbnailbase64String forKey:@"music_solo_image"];
        [uploadRequest setValue:[NSNumber numberWithInt:self->_rapValue.id] forKey:@"music_id"];
        [uploadRequest setValue:[NSNumber numberWithInteger:self->_rapValue.category_id] forKey:@"category_id"];
        [uploadRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        
        // Execute the reqest:
        NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
        if (conn)
        {
            // Connection succeeded (even if a 404 or other non-200 range was returned).
            NSLog(@"sucess");
            
//            [self showAlertWithTitle:@"Wow 👍" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
//
//                if ([action.title isEqualToString:@"Ok"]){
//                    //                                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    [self showAlertWithTitle:@"You Want to invite HipHopLive Users ?" andMessage:@"" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {
//
//                        if ([action.title isEqualToString:@"No"]){
//                            [self.navigationController popToRootViewControllerAnimated:YES];
//                        }else{
//                            NSDictionary *dic = [returnedDict objectForKey:@"Music"];
//                            self->music_id = [dic objectForKey:@"music_id"];
//                            self->music_solo_id = [dic objectForKey:@"id"];
//
//                            [self performSegueWithIdentifier:@"SegueRapVideoToUserInvite" sender:nil];
//
//                        }
//
//                    }];
//                }
//
//            }];
        }
        else
        {
            // Connection failed (cannot reach server).
            NSLog(@"fail");
//            [self showNoHandlerAlertWithTitle:@"Upload failed 👎" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];

        }
        
        
        
        
        
//
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/soloinsert",Base_URL]];
//
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.tabBarController.tabBar.userInteractionEnabled = false;
//
//        NSError *error = nil;
//        NSData *data = [NSData dataWithContentsOfURL:self->_getVideoURL];
//        if(data == nil && error!=nil) {
//            //Print error description
//        }
//
//        //new
//        //        NSData *imageData = [NSData dataWithContentsOfFile:str];
//        NSString *base64String = [data base64EncodedStringWithOptions:0];
//        //            NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
//        [paramDic setObject:base64String forKey:@"music_solo_file"];
//        [paramDic setObject:self->thumbnailbase64String forKey:@"music_solo_image"];
//        [paramDic setObject:[NSNumber numberWithInt:self->_rapValue.id] forKey:@"music_id"];
//        [paramDic setObject:[NSNumber numberWithInteger:self->_rapValue.category_id] forKey:@"category_id"];
//        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
//
//
//        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = true;
//
//            if (error != nil) {
//                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
//            }else{
//                if (statusCode == 200) {
//                    // Check if any data returned.
//
//                    if (data != nil) {
//
//                        // Convert the returned data into a dictionary.
//                        //                            NSError *error;
//
//                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                        NSLog(@"RapVideo response = %@",str);
//
//                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
//                            [self showAlertWithTitle:@"Wow 👍" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
//
//                                if ([action.title isEqualToString:@"Ok"]){
//                                    //                                        [self.navigationController popToRootViewControllerAnimated:YES];
//                                    [self showAlertWithTitle:@"You Want to invite HipHopLive Users ?" andMessage:@"" buttonTitles:@[@"Yes",@"No"] andHandler:^(UIAlertAction * _Nonnull action) {
//
//                                        if ([action.title isEqualToString:@"No"]){
//                                            [self.navigationController popToRootViewControllerAnimated:YES];
//                                        }else{
//                                            NSDictionary *dic = [returnedDict objectForKey:@"Music"];
//                                            self->music_id = [dic objectForKey:@"music_id"];
//                                            self->music_solo_id = [dic objectForKey:@"id"];
//
//                                            [self performSegueWithIdentifier:@"SegueRapVideoToUserInvite" sender:nil];
//
//                                        }
//
//                                    }];
//                                }
//
//                            }];
//                        }else{
//                            [self showNoHandlerAlertWithTitle:@"Upload failed 👎" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
//                        }
//
//
//                    }else{
//                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
//
//                    }
//                }else{
//                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                    [self showNoHandlerAlertWithTitle:@"Upload failed 👎" andMessage:str];
//
//                }
//            }
//
//        } withError:^(NSError * _Nonnull error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = true;
//
//            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
//
//        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (NSData *)generatePostDataForData:(NSData *)uploadData
{
    // Generate the post header:
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"somefile\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueRapVideoToUserInvite"]) {
        UserInviteViewController *inviteVC  = segue.destinationViewController;
        inviteVC.music_id = music_id;
        inviteVC.music_solo_id = music_solo_id;
        
    }
}


@end
