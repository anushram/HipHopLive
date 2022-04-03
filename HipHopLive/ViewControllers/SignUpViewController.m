//
//  SignUpViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    BOOL keyboardIsShown;
    int kTabBarHeight;
    UITapGestureRecognizer *tap;
    NSInteger countryID;
    NSInteger state_ID;

}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_stateVisible_Btn setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
    [_stateVisible_Btn setImage:[UIImage imageNamed:@"up-arrow"] forState:UIControlStateSelected];
    [_countryVisible_Btn setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
    [_countryVisible_Btn setImage:[UIImage imageNamed:@"up-arrow"] forState:UIControlStateSelected];
    
    [_passwordVisible_Btn setImage:[UIImage imageNamed:@"password-show"] forState:UIControlStateNormal];
    [_passwordVisible_Btn setImage:[UIImage imageNamed:@"password-hide"] forState:UIControlStateSelected];
    
    kTabBarHeight = 0;
    [self UIUpdate];
    [self setNavigationBar:@""];
    [self setTextFieldPlaceHolderColor];
    
//    // register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:self.view.window];
//    // register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:self.view.window];
//    keyboardIsShown = NO;
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
//    CGSize scrollContentSize = CGSizeMake(320, 345);
//    _scrollView.contentSize = scrollContentSize;

    
    stateArr = [[NSMutableArray<StateDetail> alloc]init];
    countryArr = [[NSMutableArray<CountryDetail> alloc]init];
    [_stateTableView reloadData];
    [_countryTableView reloadData];
    _countryTableView.hidden = true;
    _stateTableView.hidden = true;
    countryID = -1;
    
    //Adding tap gesture
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];

    //tableview corner radius
//    CAShapeLayer * maskLayer = [CAShapeLayer layer];
//    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: _stateTableView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
//
//    _stateTableView.layer.mask = maskLayer;
    
//    CAShapeLayer * maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.path = [UIBezierPath bezierPathWithRoundedRect: _countryTableView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
//
//    _countryTableView.layer.mask = maskLayer2;
    
    _stateTableView.layer.cornerRadius = 10;
    _countryTableView.layer.cornerRadius = 10;

}

- (void)UIUpdate{
    [UIButton setCornerRadius:_signUpButton radius:20];
    _passwordVisible_Btn.selected = false;
}

- (void)setTextFieldPlaceHolderColor{
    [UIColor setBottomLineForTextField:_firstName setColor:[UIColor colorWithRed:105/255.0 green:132/255.0 blue:208/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_lastName setColor:[UIColor colorWithRed:105/255.0 green:132/255.0 blue:208/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_city setColor:[UIColor colorWithRed:109/255.0 green:105/255.0 blue:203/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_state setColor:[UIColor colorWithRed:116/255.0 green:96/255.0 blue:203/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_country setColor:[UIColor colorWithRed:133/255.0 green:97/255.0 blue:206/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_emailAddress setColor:[UIColor colorWithRed:137/255.0 green:90/255.0 blue:205/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_password setColor:[UIColor colorWithRed:137/255.0 green:90/255.0 blue:205/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIColor setBottomLineForTextField:_phoneNo setColor:[UIColor colorWithRed:137/255.0 green:90/255.0 blue:205/255.0 alpha:1.0].CGColor borderWidth:2];

    
    //add Done button
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(phoneNumberDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    _phoneNo.inputAccessoryView = keyboardToolbar;
}
//MARK: Keyboard delegate
-(void)phoneNumberDoneButtonPressed
{
//    if ([_phoneNo.text isEqualToString:@""]) {
//        [_phoneNo resignFirstResponder];
//    }else{
//        [_phoneNo resignFirstResponder];
//        [_emailAddress becomeFirstResponder];
//    }
    
    [_emailAddress becomeFirstResponder];

}
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"keyboardHideHeight=%f",keyboardSize.height);
    
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
    NSLog(@"keyboardShowHeight=%f",keyboardSize.height);

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

//MARK: textField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    

    if (textField == _state){
        
        [_firstName resignFirstResponder];
        [_lastName resignFirstResponder];
        [_city resignFirstResponder];
        [_phoneNo resignFirstResponder];
        [_emailAddress resignFirstResponder];
        [_password resignFirstResponder];
        
        if (countryID == -1) {
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"please choose your country first in the field below"];
        }else{
            [self getStateList];
            self->_countryVisible_Btn.selected = false;
            self->_stateTableView.hidden = false;
            self->_countryTableView.hidden = true;
            
//            CGFloat tableViewHeight = CGRectGetHeight(self.stateTableView.frame);
//            [UIView animateWithDuration:0.6
//                             animations:^{
//                                 // set the transform to animate to
//                                 self->_countryVisible_Btn.selected = false;
//                                 self->_stateTableView.hidden = false;
//                                 self->_countryTableView.hidden = true;
//                                 self.stateTableView.layer.transform = CATransform3DMakeTranslation(0, tableViewHeight, 0);
//
//                             } completion:^(BOOL finished) {
//                                 // when animation is finished, reset the transform
//                                 // if you also want to hide the tableView, here
//                                 // would be a good way to put it
//
//                                 self.stateTableView.layer.transform = CATransform3DIdentity;
//                                 self->_stateVisible_Btn.selected = true;
//
//                             }];
            
//            [_scrollView addGestureRecognizer:tap];
        }
        
        return false;
    }else if (textField == _country){
        [_firstName resignFirstResponder];
        [_lastName resignFirstResponder];
        [_city resignFirstResponder];
        [_phoneNo resignFirstResponder];
        [_emailAddress resignFirstResponder];
        [_password resignFirstResponder];
        
        self->countryArr = [[Singletons sharedManager].countryList mutableCopy];
//        [self getCountryList];
        [self->_countryTableView reloadData];

//        [_scrollView addGestureRecognizer:tap];
        
        self->_stateVisible_Btn.selected = false;
        self->_countryTableView.hidden = false;
        self->_stateTableView.hidden = true;

//        CGFloat tableViewHeight = CGRectGetHeight(self.countryTableView.frame);
//        [UIView animateWithDuration:0.6
//                         animations:^{
//                             // set the transform to animate to
//                             self->_stateVisible_Btn.selected = false;
//                             self->_countryTableView.hidden = false;
//                             self->_stateTableView.hidden = true;
//                             self.countryTableView.layer.transform = CATransform3DMakeTranslation(0, tableViewHeight, 0);
//                         } completion:^(BOOL finished) {
//                             // when animation is finished, reset the transform
//                             // if you also want to hide the tableView, here
//                             // would be a good way to put it
//                             self.countryTableView.layer.transform = CATransform3DIdentity;
//                             self->_countryVisible_Btn.selected = true;
//
//                         }];

        return false;
    }
//    else{
//        _stateVisible_Btn.selected = false;
//        _countryVisible_Btn.selected = false;
//
//        _countryTableView.hidden = true;
//        _stateTableView.hidden = true;
//    }
    else if (textField == _firstName){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == _lastName){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == _city){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == _phoneNo){
        [self.scrollView setContentOffset:CGPointMake(0, _firstName.frame.origin.y) animated:YES];
    }else if (textField == _emailAddress){
        [self.scrollView setContentOffset:CGPointMake(0, _lastName.frame.origin.y) animated:YES];
    }else if (textField == _password){
        [self.scrollView setContentOffset:CGPointMake(0, _city.frame.origin.y) animated:YES];
    }

    _stateVisible_Btn.selected = false;
    _countryVisible_Btn.selected = false;

    _countryTableView.hidden = true;
    _stateTableView.hidden = true;
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

        if (textField == _firstName){
            if ([textField.text  isEqual: @""]){
                [textField resignFirstResponder];
            }else{
                [_lastName becomeFirstResponder];
            }
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

        }else if (textField == _lastName){
            if ([textField.text  isEqual: @""]){
                [textField resignFirstResponder];
            }else{
                [_city becomeFirstResponder];
            }
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

        }else if (textField == _city){

            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [_firstName resignFirstResponder];
            [_lastName resignFirstResponder];
            [_city resignFirstResponder];
            [_phoneNo resignFirstResponder];
            [_emailAddress resignFirstResponder];
            [_password resignFirstResponder];
            
            self->countryArr = [[Singletons sharedManager].countryList mutableCopy];
            [self->_countryTableView reloadData];
            
            self->_stateVisible_Btn.selected = false;
            self->_countryTableView.hidden = false;
            self->_stateTableView.hidden = true;

        }else if (textField == _emailAddress){
            if ([textField.text  isEqual: @""]){
                [textField resignFirstResponder];
            }else{
                [_password becomeFirstResponder];
            }
            [self.scrollView setContentOffset:CGPointMake(0, _city.frame.origin.y) animated:YES];
        }else if (textField == _password){
                [_password resignFirstResponder];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
    
    return true;
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


//MARK: tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _stateTableView){
        return self->stateArr.count;
    }else{
        return self->countryArr.count;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = nil;
    
    if (tableView == _stateTableView){
       cellId = @"stateCell";
    }else{
       cellId = @"countryCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    if (tableView == _stateTableView){
        StateDetail *value = [self->stateArr objectAtIndex:indexPath.row];
        cell.textLabel.text = value.name;
    }else{
        CountryDetail *value = [self->countryArr objectAtIndex:indexPath.row];
        cell.textLabel.text = value.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _stateTableView){
        
        StateDetail *value = [self->stateArr objectAtIndex:indexPath.row];
        _state.text = value.name;
        state_ID = value.stateID;
        _stateTableView.hidden = true;
        _stateVisible_Btn.selected = false;
        
        [_phoneNo becomeFirstResponder];

    }else{

        CountryDetail *value = [self->countryArr objectAtIndex:indexPath.row];
        _country.text = value.name;
        countryID = value.countryID;
        _countryTableView.hidden = true;
        [self getStateList];
        _stateTableView.hidden = false;

//        [_state becomeFirstResponder];
        
        _countryVisible_Btn.selected = false;
        
    }
    [self dismissView];
}

- (void) dismissView {
    _countryTableView.hidden = true;
    _stateTableView.hidden = true;
    [_scrollView removeGestureRecognizer:tap];
}

- (IBAction)signup_Action:(id)sender {
    
    if ([_firstName.text isEqualToString:@""]){
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the First Name"];
    }else{
        if ([_lastName.text isEqualToString:@""]){
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Last Name"];
        }else{
            if ([_city.text isEqualToString:@""]){
                [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the City"];
            }else{
                if ([_state.text isEqualToString:@""]) {
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Choose the State"];
                }else{
                    if ([_country.text isEqualToString:@""]){
                        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Choose the Countrye"];
                    }else{
                        if ([_phoneNo.text isEqualToString:@""]){
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Phone Number"];
                        }else{
                            if ([_emailAddress.text isEqualToString:@""]) {
                                [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Email Address"];
                            }else{
                                if (![self validateEmailWithString:_emailAddress.text]){
                                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Valid EmailAddress"];
                                }else{
                                    if ([_password.text isEqualToString:@""]){
                                        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Password"];
                                    }else{
                                        [self signUpValidation];
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}

- (void)signUpValidation{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/register",Base_URL]];
        
        //        NSString *post = nil;
        
//        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:yourDictionary options:0 error:&err];

        // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
//        NSString *stateString = [NSString stringWithFormat:@"%ld",(long)self->state_ID];
//        NSString *countryString = [NSString stringWithFormat:@"%ld",(long)self->countryID];
//        NSDictionary *request = [[NSDictionary alloc]initWithObjectsAndKeys:@{
//                                                                             @"firstname" : self->_firstName.text,
//                                                                             @"lastname" : self->_lastName.text,
//                                                                             @"email" : self->_emailAddress.text,
//                                                                             @"password" : self->_password.text,
//                                                                            @"deviceType" : deviceType,
//                                                                            @"deviceToken" : @"",
//                                                                             @"city" : self->_city.text,
//                                                                             @"state" : stateString,
//                                                                             @"country" : countryString
//                                                                             }, nil];
//        NSString *post =[NSString stringWithFormat:@"%@", request];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //old
//        NSString *post =[[NSString alloc] initWithFormat:@"firstname=%@&lastname=%@&phone=%@&email=%@&password=%@&deviceType=%@&deviceToken=%@&city=%@&state=%ld&country=%ld",self->_firstName.text,self->_lastName.text,self->_phoneNo.text,self->_emailAddress.text,self->_password.text,deviceType,@"",self->_city.text,(long)self->state_ID,(long)self->countryID];
//        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:self->_firstName.text forKey:@"firstname"];
        [paramDic setObject:self->_lastName.text forKey:@"lastname"];
        [paramDic setObject:self->_phoneNo.text forKey:@"phone"];
        [paramDic setObject:self->_emailAddress.text forKey:@"email"];
        [paramDic setObject:self->_password.text forKey:@"password"];
        [paramDic setObject:deviceType forKey:@"deviceType"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"fcmtoken"] forKey:@"deviceToken"];
        [paramDic setObject:self->_city.text forKey:@"city"];
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self->state_ID] forKey:@"state"];
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self->countryID] forKey:@"country"];

        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                            JSONModelError *jsonModelError = nil;
                            LoginResponse *object = [[LoginResponse alloc]initWithData:data error:&jsonModelError];
//                            if (object == nil) {
//                                [self showNoHandlerAlertWithTitle:@"SignUpResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
//                            }else{
                            [Singletons sharedManager].userDetail  = object.userDetail;
                            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"isLogin"];
                            [[NSUserDefaults standardUserDefaults]setObject:object.token forKey:@"token"];
                            [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully Registered" buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                
                                if ([action.title isEqualToString:@"Ok"]){
                                   
//                                    [UIView transitionWithView:self.view
//                                                      duration:0.5
//                                                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                                                    animations:^{
//                                                        TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
//                                                        //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
//                                                        self.view.window.rootViewController = tabBarController;
//                                                         }
//                                                    completion:nil];
                                    
                                    [self performSegueWithIdentifier:@"segueSignUpToProfileUpload" sender:nil];
                                    
                                }
                        
                            }];
                                
//                          }
                        }else{
                            NSDictionary *errorDic = [returnedDict objectForKey:@"error"];
                            
                            [self showNoHandlerAlertWithTitle:@"Sign Up failed 👎" andMessage:[[errorDic objectForKey:[[errorDic allKeys] objectAtIndex:0]] objectAtIndex:0]];
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
-(void)getStateList{
    
    if (countryID == -1){
        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"please choose your country first in the field below"];
    }else{
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            
            if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
                [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
                return ;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getstate?CountryId=%ld",Base_URL,(long)self->countryID]];
            
            //        NSString *post = nil;
            
            // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            
            [ApiManager callAPI:url parameters:nil method:@"GET" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if (error != nil) {
                    [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
                }else{
                    if (statusCode == 200) {
                        // Check if any data returned.
                        
                        if (data != nil) {
                            
                            // Convert the returned data into a dictionary.
                            
//                            NSError *error;
                            
                            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"response = %@",str);
                            
//                            NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                            JSONModelError *jsonModelError = nil;
                            StateResponse *object = [[StateResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"StateResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                            self->stateArr = [object.statesRes mutableCopy];
                            [self->_stateTableView reloadData];
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
    
    
}

-(void)getCountryList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcountry",Base_URL]];
        
        //        NSString *post = nil;
        
        // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        [ApiManager callAPI:url parameters:nil method:@"GET" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        
//                        NSError *error;
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"response = %@",str);
                        
//                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        JSONModelError *jsonModelError = nil;
                        CountryResponse *object = [[CountryResponse alloc]initWithData:data error:&jsonModelError];
                        
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"CountryResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{

                        self->countryArr = [object.countriesRes mutableCopy];
                        [self->_countryTableView reloadData];
//                        CountryDetail *de = [object.countriesRes objectAtIndex:0];
//                        NSLog(@"name=%@",de.name);
//                        NSLog(@"name=%d",de.countryID);
//                        NSLog(@"name=%@",de.sortname);
//                        NSLog(@"name=%@",de.phonecode);
                        
//                        NSMutableArray <StateDetail *> *str1 = object.statesRes;
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
- (IBAction)siginAction:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)stateVisibleAction:(id)sender {
    if (_stateVisible_Btn.selected){
        _stateVisible_Btn.selected = false;
        _countryTableView.hidden = true;
        _stateTableView.hidden = true;
    }else{
        [_firstName resignFirstResponder];
        [_lastName resignFirstResponder];
        [_city resignFirstResponder];
        [_phoneNo resignFirstResponder];
        [_emailAddress resignFirstResponder];
        [_password resignFirstResponder];
        
        if (countryID == -1) {
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"please choose your country first in the field below"];
        }else{
            
            [self getStateList];
            
            self->_countryVisible_Btn.selected = false;
            self->_stateTableView.hidden = false;
            self->_countryTableView.hidden = true;
            self->_stateVisible_Btn.selected = true;

            
//            CGFloat tableViewHeight = CGRectGetHeight(self.stateTableView.frame);
//            [UIView animateWithDuration:0.6
//                             animations:^{
//                                 // set the transform to animate to
//                                 self->_countryVisible_Btn.selected = false;
//                                 self->_stateTableView.hidden = false;
//                                 self->_countryTableView.hidden = true;
//                                 self.stateTableView.layer.transform = CATransform3DMakeTranslation(0, tableViewHeight, 0);
//
//                             } completion:^(BOOL finished) {
//                                 // when animation is finished, reset the transform
//                                 // if you also want to hide the tableView, here
//                                 // would be a good way to put it
//
//                                 self.stateTableView.layer.transform = CATransform3DIdentity;
//                                 self->_stateVisible_Btn.selected = true;
//
//                             }];
            
            
            //            [_scrollView addGestureRecognizer:tap];
        }

    }
}
- (IBAction)countryVisibleAction:(id)sender {
    if (_countryVisible_Btn.selected){
        _countryVisible_Btn.selected = false;
        _countryTableView.hidden = true;
        _stateTableView.hidden = true;
    }else{
        [_firstName resignFirstResponder];
        [_lastName resignFirstResponder];
        [_city resignFirstResponder];
        [_phoneNo resignFirstResponder];
        [_emailAddress resignFirstResponder];
        [_password resignFirstResponder];
        
        self->countryArr = [[Singletons sharedManager].countryList mutableCopy];
        //        [self getCountryList];
        [self->_countryTableView reloadData];
        
        //        [_scrollView addGestureRecognizer:tap];
        
        self->_stateVisible_Btn.selected = false;
        self->_countryTableView.hidden = false;
        self->_stateTableView.hidden = true;
        self->_countryVisible_Btn.selected = true;

        
//        CGFloat tableViewHeight = CGRectGetHeight(self.countryTableView.frame);
//
//        [UIView animateWithDuration:0.6
//                         animations:^{
//                             // set the transform to animate to
//                             self->_stateVisible_Btn.selected = false;
//                             self->_countryTableView.hidden = false;
//                             self->_stateTableView.hidden = true;
//                             self.countryTableView.layer.transform = CATransform3DMakeTranslation(0, tableViewHeight, 0);
//
//                         } completion:^(BOOL finished) {
//                             // when animation is finished, reset the transform
//                             // if you also want to hide the tableView, here
//                             // would be a good way to put it
//
//                             self.countryTableView.layer.transform = CATransform3DIdentity;
//                             self->_countryVisible_Btn.selected = true;
//
//                         }];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [self dismissView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSignUpToProfileUpload"]) {
        //        UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
        //        RapMusicViewController *rapVC = (RapMusicViewController *)dest.topViewController;
        
        ProfileUploadViewController *rapVC = segue.destinationViewController;
        rapVC.isSignUp = true;
    }
}


@end
