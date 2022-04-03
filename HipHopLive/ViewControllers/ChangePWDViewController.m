//
//  ChangePWDViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 06/12/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ChangePWDViewController.h"

@interface ChangePWDViewController ()

@end

@implementation ChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar:@"Change Password"];

}
- (IBAction)submitAction:(id)sender {
    if ([_oldPwd_Txt.text isEqualToString:@""]) {
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter The old Password"];
    }else{
        if ([_changePassword.text isEqualToString:@""]) {
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter The New Password"];
        }else{
            [self passwordValidation];
        }
    }
}

- (void)passwordValidation{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/changepassword",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&deviceType=%@&deviceToken=%@",self->_email.text,self->_password.text,deviceType,@""];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:self->_oldPwd_Txt.text forKey:@"oldpassword"];
        [paramDic setObject:self->_changePassword.text forKey:@"newpassword"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];

        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        
                        // NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"changepassword response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                                
                                [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully Changed Your Password" buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                    
                                    if ([action.title isEqualToString:@"Ok"]){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[self navigationController] popViewControllerAnimated:YES];
                                        });
                                    }
                                    
                                }];
                                
                        }else if ([[returnedDict objectForKey:@"response"] isEqualToString:@"failed"]){
                        
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[returnedDict objectForKey:@"message"]];

                        }else{
                            NSDictionary *errorDic = [returnedDict objectForKey:@"error"];
                            
                            [self showNoHandlerAlertWithTitle:@"failed 👎" andMessage:[[errorDic objectForKey:[[errorDic allKeys] objectAtIndex:0]] objectAtIndex:0]];
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
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
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
