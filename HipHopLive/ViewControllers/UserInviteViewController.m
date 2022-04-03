//
//  UserInviteViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 01/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "UserInviteViewController.h"

@interface UserInviteViewController ()

@end

@implementation UserInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar:@"Users List"];
    _selectedUserID_Arr = [[NSMutableArray alloc]init];
    
    _invite_Btn.alpha = 0.5;
    _invite_Btn.userInteractionEnabled = NO;
    
    [self getUserList];
}


//# MARK: uitableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList_Arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdentifier = @"userListCell";

        UserListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        UserDetails *value = [self.userList_Arr objectAtIndex:indexPath.row];
    if (_selectedUserID_Arr.count> 0) {
        if ([_selectedUserID_Arr containsObject:[NSNumber numberWithInt:value.id]]) {
            [cell.check_Box setImage:[UIImage imageNamed:@"tickBox"] forState:UIControlStateNormal];
        }else{
            [cell.check_Box setImage:[UIImage imageNamed:@"emptyBox"] forState:UIControlStateNormal];
        }
    }else{
            [cell.check_Box setImage:[UIImage imageNamed:@"emptyBox"] forState:UIControlStateNormal];
    }
    
    
//        NSLog(@"username=%@",value.username);
    
        if (value.username == nil) {
            cell.userName.text = value.username;
        }else{
            cell.userName.text = value.firstname;
        }
        cell.check_Box.tag = indexPath.row;
//        [cell.check_Box addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.profile_Pic sd_setImageWithURL:[NSURL URLWithString:value.imagename] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
        [UIImageView setCornerRadius:cell.profile_Pic radius:cell.profile_Pic.frame.size.height/2];
        cell.profile_Pic.contentMode = UIViewContentModeScaleAspectFill;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDetails *value = [self.userList_Arr objectAtIndex:indexPath.row];
    if (![_selectedUserID_Arr containsObject:[NSNumber numberWithInt:value.id]]) {
        [self.selectedUserID_Arr addObject:[NSNumber numberWithInt:value.id]];
    }else{
        [self.selectedUserID_Arr removeObject:[NSNumber numberWithInt:value.id]];
    }
    if (_selectedUserID_Arr.count > 0) {
        _invite_Btn.alpha = 1;
        _invite_Btn.userInteractionEnabled = YES;
    }else{
        _invite_Btn.alpha = 0.5;
        _invite_Btn.userInteractionEnabled = NO;
    }
    [self.tableView reloadData];

}

-(void)getUserList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userlist",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
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
                        // NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"userslist response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            UsersListResponse *object = [[UsersListResponse alloc]initWithData:data error:&jsonModelError];
                            
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"userslist Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                self->_userList_Arr = [object.userdetails mutableCopy];
                                [self.tableView reloadData];
                                
                            }
                            
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

-(void)checkBoxButtonPressed:(UIButton*)button{
//    UserDetails *value = [self.userList_Arr objectAtIndex:button.tag];
//    if (![_selectedUserID_Arr containsObject:[NSNumber numberWithInt:value.id]]) {
//        [self.selectedUserID_Arr addObject:[NSNumber numberWithInt:value.id]];
//    }else{
//        [self.selectedUserID_Arr removeObject:[NSNumber numberWithInt:value.id]];
//    }
//    if (_selectedUserID_Arr.count > 0) {
//        _invite_Btn.alpha = 1;
//        _invite_Btn.userInteractionEnabled = YES;
//    }else{
//        _invite_Btn.alpha = 0.5;
//        _invite_Btn.userInteractionEnabled = NO;
//    }
//    [self.tableView reloadData];
    
}
- (IBAction)invite_Action:(id)sender {
    
    [self inviteUser];
}

-(void)inviteUser{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userinvite",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->_selectedUserID_Arr forKey:@"invited_user_id"];
        [paramDic setObject:self->_music_solo_id forKey:@"music_solo_id"];
        [paramDic setObject:self->_music_id forKey:@"music_id"];

        
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
                        NSLog(@"userinvite response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            [self showAlertWithTitle:@"" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]] buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                
                                if ([action.title isEqualToString:@"Ok"]){
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }else{
                        
                                    
                                }
                                
                            }];
                            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
