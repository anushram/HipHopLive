//
//  ProfileUploadViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 16/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ProfileUploadViewController.h"

@interface ProfileUploadViewController ()
{
    BOOL isSelectedProfileImg;
}
@end

@implementation ProfileUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.title = @"Profile Picture Upload";
    
    if (_isSignUp){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
        self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
        self.navigationController.navigationBar.translucent = YES;
        self.navigationItem.title = @"Profile Picture Upload";
        
        
        //backImg
        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *backBtnImage = [UIImage imageNamed:@"backImg"];
        //    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
//        [backBtn setImage:backBtnImage forState:UIControlStateNormal];
        [skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
        [skipBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
        skipBtn.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:skipBtn] ;
        self.navigationItem.rightBarButtonItem = backButton;
        self.navigationItem.hidesBackButton = YES;
        
    }else{
        [self setNavigationBar:@"Profile Picture Upload"];
    }
    
    
    [UIImageView setCornerRadius:_profileImg radius:_profileImg.frame.size.height/2];
    NSLog(@"%@",[Singletons sharedManager].userDetail.imagename);
    if ([Singletons sharedManager].userDetail.imagename != nil){
        [_profileImg sd_setImageWithURL:[NSURL URLWithString:[Singletons sharedManager].userDetail.imagename] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
    }else{
        [_profileImg setImage:[UIImage imageNamed:@"profilePlaceholder"]];
    }
    _profileImg.contentMode = UIViewContentModeScaleAspectFill;
    [UIButton setCornerRadius:_uploadButton radius:20];
    
    isSelectedProfileImg = false;
}

-(void)skip{
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
                        //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
                        self.view.window.rootViewController = tabBarController;
                    }
                    completion:nil];
}
- (IBAction)profileImgAction:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:@"Please choose a source type" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    if (isSelectedProfileImg){
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self->_profileImg setImage:[UIImage imageNamed:@"profilePlaceholder"]];
            self->isSelectedProfileImg = false;
            // Distructive button tapped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    isSelectedProfileImg = true;
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _profileImg.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadAction:(id)sender {
    if (isSelectedProfileImg){
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            
            if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
                [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
                return ;
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/me/avatar",Base_URL]];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = false;

            //new 
            NSData *imageData = UIImageJPEGRepresentation(self->_profileImg.image, 1);
            NSString *base64String = [imageData base64EncodedStringWithOptions:0];
//            NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
            [paramDic setObject:base64String forKey:@"image"];
            [paramDic setObject:@"JPEG" forKey:@"imgtype"];
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
                            NSLog(@"signup response = %@",str);
                            
                            NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            
                            if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                                [self showAlertWithTitle:@"Wow 👍" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                    
                                    if ([action.title isEqualToString:@"Ok"]){
                                        
                                        if (self->_isSignUp) {
                                            [UIView transitionWithView:self.view
                                                              duration:0.5
                                                               options:UIViewAnimationOptionTransitionFlipFromLeft
                                                            animations:^{
                                                                TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
                                                                //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
                                                                self.view.window.rootViewController = tabBarController;
                                                            }
                                                            completion:nil];
                                        }else{
                                            [[self navigationController] popViewControllerAnimated:YES];

                                        }
                                        
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
    }else{
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Choose the Profile Picture"];
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
