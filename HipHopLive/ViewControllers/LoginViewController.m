//
//  LoginViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    BOOL keyboardIsShown;
    int kTabBarHeight;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_passwordVisible_Btn setImage:[UIImage imageNamed:@"password-show"] forState:UIControlStateNormal];
    [_passwordVisible_Btn setImage:[UIImage imageNamed:@"password-hide"] forState:UIControlStateSelected];
    
    [self UIUpdate];
    [self setNavigationBar:@""];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    _scrollView.contentSize = scrollContentSize;

}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)UIUpdate{
    _passwordVisible_Btn.selected = false;
    //    [UIColor setBottomLineForTextField:_password setColor:[UIColor colorWithRed:145/255.0 green:155/255.0 blue:191/255.0 alpha:1.0].CGColor borderWidth:2];

    [UIColor setBottomLineForTextField:_email setColor:[UIColor colorWithRed:119/255.0 green:110/255.0 blue:205/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_password setColor:[UIColor colorWithRed:131/255.0 green:101/255.0 blue:205/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIButton setCornerRadius:_siginButton radius:20];
}

- (IBAction)passwordVisible:(id)sender {
    if (_passwordVisible_Btn.selected){
        _password.secureTextEntry = true;
        _passwordVisible_Btn.selected = false;
    }else{
        _password.secureTextEntry = false;
        _passwordVisible_Btn.selected = true;
    }
}
- (IBAction)signin_Action:(id)sender {
    if ([_email.text isEqualToString:@""]) {
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter The Email Address"];
    }else{
        if (![self validateEmailWithString:_email.text]){
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter The Valid Email Address"];
        }else{
            if ([_password.text isEqualToString:@""]){
                [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter The Password"];
            }else{
                [self signInValidation];
            }
        }
    }
}

- (void)signInValidation{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/login",Base_URL]];
        //old
//        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&deviceType=%@&deviceToken=%@",self->_email.text,self->_password.text,deviceType,@""];
//        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:self->_email.text forKey:@"email"];
        [paramDic setObject:self->_password.text forKey:@"password"];
        [paramDic setObject:deviceType forKey:@"deviceType"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"fcmtoken"] forKey:@"deviceToken"];


        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//            [UIView transitionWithView:self.view
//                              duration:0.2
//                               options:UIViewAnimationOptionShowHideTransitionViews
//                            animations:^{
//                                TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
//                                //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
//                                self.view.window.rootViewController = tabBarController;
//                            }
//                            completion:nil];
//            });

            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"login response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            LoginResponse *object = [[LoginResponse alloc]initWithData:data error:&jsonModelError];
//                            LoginResponse *object2 = [[LoginResponse alloc]initWithDictionary:returnedDict error:&jsonModelError];
                            
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"LoginResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{

                            NSLog(@"Parseerror= %@",[jsonModelError localizedDescription]);
                            [Singletons sharedManager].userDetail  = object.userDetail;
                            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isLogin"];
                            [[NSUserDefaults standardUserDefaults]setObject:object.token forKey:@"token"];
                            [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully Login" buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                
                                if ([action.title isEqualToString:@"Ok"]){
                                    dispatch_async(dispatch_get_main_queue(), ^{

                                    [UIView transitionWithView:self.view
                                                      duration:0.2
                                                       options:UIViewAnimationOptionShowHideTransitionViews
                                                    animations:^{
                                                        TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
                                                        //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
                                                        self.view.window.rootViewController = tabBarController;
                                                    }
                                                    completion:nil];
                                    });
                                }
                                
                            }];
                                
                            }
                        }else{
                            
                            [self showNoHandlerAlertWithTitle:@"Login failed 👎" andMessage:[returnedDict objectForKey:@"message"]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
