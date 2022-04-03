//
//  FollowersFollowingViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "FollowersFollowingViewController.h"

@interface FollowersFollowingViewController ()

@end

@implementation FollowersFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self->_selectionType isEqualToString:@"viewlist"]) {
        [self setNavigationBar:@"Viewed Users"];
        [self viewUserList];
    }else if ([self->_selectionType isEqualToString:@"blockuser"]){
        [self setNavigationBar:@"Blocked Users"];
        [self blockList];
    }else if ([self->_selectionType isEqualToString:@"followers"]) {
        [self setNavigationBar:@"Followers List"];
        [self getList];
    }else{
        [self setNavigationBar:@"Following List"];
        [self getList];
    }
}

- (void)viewUserList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        //http://hiphoplive.sitecare.org/api/v1/viewerslist
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/viewerslist",Base_URL]];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        if ([self->_valueType isEqualToString:@"solo"]) {
            
            [paramDic setObject:[NSNumber numberWithInt:self->_soloselectedValue.id] forKey:@"music_solo_id"];
        }else{
            [paramDic setObject:[NSNumber numberWithInt:self->_duetselectedValue.id] forKey:@"music_solo_id"];
        }
        [paramDic setObject:self->_valueType forKey:@"music_type"];

        
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
                        NSLog(@"viewerslist response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            ViewUserResponse *object = [[ViewUserResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"viewerslist Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                self->_arrayList = [object.Musicview mutableCopy];
                                
                                if (self->_arrayList.count == 0) {
                                    self->_noData_Lbl.hidden = NO;
                                }else{
                                    self->_noData_Lbl.hidden = YES;
                                }
                                
                                [self->_tableview reloadData];
                                
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

- (void)getList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        NSURL *url;
        if ([self->_selectionType isEqualToString:@"followers"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/followerslist",Base_URL]];

        }else{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/followlist",Base_URL]];
        }
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:self->_userID] forKey:@"id"];
        
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
                        NSLog(@"follow response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            FollowResponse *object = [[FollowResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"userdetails Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                if ([self->_selectionType isEqualToString:@"followers"]) {
                                    self->_arrayList = [object.followers mutableCopy];
                                }else{
                                    self->_arrayList = [object.followingUsers mutableCopy];
                                }
                                
                                if (self->_arrayList.count == 0) {
                                    self->_noData_Lbl.hidden = NO;
                                }else{
                                    self->_noData_Lbl.hidden = YES;
                                }
                                
                                [self->_tableview reloadData];
                                
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
- (void)blockList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@/blockeduserslist",Base_URL]];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:self->_userID] forKey:@"id"];
        
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
                        NSLog(@"blockeduserslist response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            FollowResponse *object = [[FollowResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"blockeduserslist Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                 if ([self->_selectionType isEqualToString:@"blockuser"]){
                                     self->_arrayList = [object.blockedUsers mutableCopy];
                                 }else if ([self->_selectionType isEqualToString:@"followers"]) {
                                    self->_arrayList = [object.followers mutableCopy];
                                }else{
                                    self->_arrayList = [object.followingUsers mutableCopy];
                                }
                                
                                if (self->_arrayList.count == 0) {
                                    self->_noData_Lbl.hidden = NO;
                                }else{
                                    self->_noData_Lbl.hidden = YES;
                                }
                                
                                [self->_tableview reloadData];
                                
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

//# MARK: uitableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"followCell";
    
    FollowersTableViewCell *cell = (FollowersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowersTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([self->_selectionType isEqualToString:@"viewlist"]) {
        ViewUserDetail *value = [self.arrayList objectAtIndex:indexPath.row];
        
        cell.follow_Btn.hidden = true;
        
        if (value.user_name == nil) {
            cell.user_name_Lbl.text = @"";
        }else{
            cell.user_name_Lbl.text = value.user_name;
        }
        cell.name_Lbl.text = value.name;
        
        if (value.profileimage == nil) {
            value.profileimage =@"";
        }
        
        [cell.profile_pic sd_setImageWithURL:[NSURL URLWithString:value.profileimage] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
        
        [UIImageView setCornerRadius:cell.profile_pic radius:cell.profile_pic.frame.size.height/2];
        cell.profile_pic.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
    FollowDetails *value = [self.arrayList objectAtIndex:indexPath.row];
    if ([self->_selectionType isEqualToString:@"blockuser"]){
        if ([value.block_status isEqualToString:@"unblock"]) {
            [cell.follow_Btn setTitle:@"Block" forState:UIControlStateNormal];
        }else{
            [cell.follow_Btn setTitle:@"Unblock" forState:UIControlStateNormal];
        }
    }else{
        if ([value.follow_status isEqualToString:@"unfollow"]) {
            [cell.follow_Btn setTitle:@"Follow" forState:UIControlStateNormal];
        }else{
            [cell.follow_Btn setTitle:@"UnFollow" forState:UIControlStateNormal];
        }
    }
    
    
    if (value.user_name == nil) {
        cell.user_name_Lbl.text = @"";
    }else{
        cell.user_name_Lbl.text = value.user_name;
    }
    cell.name_Lbl.text = value.name;
    cell.follow_Btn.tag = indexPath.row;
    [cell.follow_Btn addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
    if (value.id == [Singletons sharedManager].userDetail.id) {
        cell.follow_Btn.hidden = YES;
    }else{
        cell.follow_Btn.hidden = NO;
    }
    
    [UIButton setCornerRadius:cell.follow_Btn radius:10];
    [cell.profile_pic sd_setImageWithURL:[NSURL URLWithString:value.profileimage] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
    
    [UIImageView setCornerRadius:cell.profile_pic radius:cell.profile_pic.frame.size.height/2];
    cell.profile_pic.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_selectionType isEqualToString:@"viewlist"]) {
        ViewUserDetail *value = [self.arrayList objectAtIndex:indexPath.row];
        _send_userID = value.view_user_id;

        [self performSegueWithIdentifier:@"SegueFollowToUserProfileView" sender:nil];

    }else if ([_selectionType isEqualToString:@"blockuser"]){
        FollowDetails *value = [self.arrayList objectAtIndex:indexPath.row];
        _send_userID = value.id;

        [self performSegueWithIdentifier:@"SegueFollowToUserProfileView" sender:nil];

    }else{
        FollowDetails *value = [self.arrayList objectAtIndex:indexPath.row];
        _send_userID = value.id;

        [self performSegueWithIdentifier:@"SegueFollowToUserProfileView" sender:nil];
    }
}
-(void)followButtonPressed:(UIButton*)button{
    
    FollowDetails *value = [self.arrayList objectAtIndex:button.tag];

    if ([self->_selectionType isEqualToString:@"blockuser"]){
        [self blockAndUnblock:@"unblock" userID:value.id];
    }else{
        NSString *follow_status ;
        if ([value.follow_status isEqualToString:@"unfollow"]) {
            follow_status = @"follow";
        }else{
            follow_status = @"unfollow";
        }
        [self followAndUnfollow:follow_status userID:value.id];
    }

    
}

- (void)followAndUnfollow:(NSString*)follow_status userID:(NSInteger)userid{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userfollow",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:userid] forKey:@"follow_user_id"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:follow_status forKey:@"follow_status"];
        
        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                        NSLog(@"userfollow response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){

                            [self getList];
                            
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
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)blockAndUnblock:(NSString*)follow_status userID:(NSInteger)userid{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userblock",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:userid] forKey:@"block_user_id"];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:follow_status forKey:@"block_status"];
        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                        NSLog(@"userblock response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            [self blockList];
                            
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
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UserDetails *value = [self.userList_Arr objectAtIndex:indexPath.row];
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
//
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueFollowToUserProfileView"]) {
        
        UserProfileView *Vc = segue.destinationViewController;
        Vc.userID = _send_userID;
        
    }
}


@end
