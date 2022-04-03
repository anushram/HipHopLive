//
//  NotificationsViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
{
    NSInteger sendUser_ID;
    MBProgressHUD *hud;
    
    //multiple download
    NSURLSession *notifysessionFirst;
    NSURLSession *notifysessionSecond;
    
}
@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    _buttonTitleArry = [[NSArray alloc]initWithObjects:@"Activity",@"Invities", nil];
    [self createScrollMenu];

    [UIButton setCornerRadius:_startRap_Btn radius:_startRap_Btn.frame.size.height/2];
    _noData_Lbl.hidden = YES;
}

- (void)createScrollMenu
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    
    int x = 25;
    for (int i = 0; i < _buttonTitleArry.count; i++) {

        //create title button
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, 120, 30)];
        [button setTitle:[NSString stringWithFormat:@"%@",[_buttonTitleArry objectAtIndex:i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        button.tag = i;
        //set border
        button.layer.cornerRadius = 15.0f;
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [[UIColor colorWithRed:158/255.0 green:86/255.0 blue:198/255.0 alpha:1.0] CGColor];
        CALayer *sub = [CALayer new];
        sub.frame = CGRectInset(button.bounds, 4, 4);
        sub.backgroundColor = [UIColor clearColor].CGColor;
        [button.layer addSublayer:sub];
        
        if (i == 0){
            [button setBackgroundColor:[UIColor colorWithRed:158/255.0 green:86/255.0 blue:198/255.0 alpha:1.0]];
            _titleButtonSelected = button;
//            _invites_TableView.hidden = YES;
            [self getActivityList];
        }
        
        [scrollView addSubview:button];
        x += button.frame.size.width+15;
    }
    
    scrollView.contentSize = CGSizeMake(x, 50);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollsToTop = false;
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.bounces = false;
    [_buttonTitleView addSubview:scrollView];
}
-(void)titleButtonPressed:(UIButton*)button{

    [button setBackgroundColor:[UIColor colorWithRed:158/255.0 green:86/255.0 blue:198/255.0 alpha:1.0]];
    
    if (_titleButtonSelected != nil && _titleButtonSelected != button) {
        [_titleButtonSelected setBackgroundColor:[UIColor clearColor]];
    }
    _titleButtonSelected = button;
    
    if (button.tag == 0) {
        [self getActivityList];
        
    }else if (button.tag == 1){
        _activity_View.hidden = YES;
        _invites_TableView.hidden = NO;
        [self getInvitesList];
    }
}

//# MARK: uitableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_titleButtonSelected.tag == 0) {
        return self.activityList_arr.count;
    }else{
        return self.invitesList_arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_titleButtonSelected.tag == 0) {
        static NSString *ActivityCellCellIdentifier = @"ActivityCell";

        ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ActivityCellCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        MusicDuetFeed *value = [_activityList_arr objectAtIndex:indexPath.row];
        
        cell.songName.text = value.title;
        cell.userName.text = value.username;
        
        CGFloat imageOffsetY = -5.0;
        //        cell.noLike.text = [NSString stringWithFormat:@"👍 %ld",(long)value.likecount];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"like-normal"];
        attachment.bounds = CGRectMake(0, imageOffsetY, attachment.image.size.width, attachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.duetlikecount]];
        NSMutableAttributedString *finalLike = [[NSMutableAttributedString alloc]init];
        [finalLike appendAttributedString:attachmentString];
        [finalLike appendAttributedString:myString];
        //        [myString appendAttributedString:attachmentString];
        cell.noLike.textAlignment=NSTextAlignmentRight;
        cell.noLike.attributedText = finalLike;
        
        //        cell.noLove.text = [NSString stringWithFormat:@"❤️ %ld",(long)value.lovecount];
        
        NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
        attachment1.image = [UIImage imageNamed:@"heart-icon-normal"];
        attachment1.bounds = CGRectMake(0, imageOffsetY, attachment1.image.size.width, attachment1.image.size.height);
        NSAttributedString *attachmentString1 = [NSAttributedString attributedStringWithAttachment:attachment1];
        NSMutableAttributedString *myString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.duetlovecount]];
        NSMutableAttributedString *finalLove = [[NSMutableAttributedString alloc]init];
        [finalLove appendAttributedString:attachmentString1];
        [finalLove appendAttributedString:myString1];
        //        [myString appendAttributedString:attachmentString];
        cell.noLove.textAlignment=NSTextAlignmentRight;
        cell.noLove.attributedText = finalLove;
        
        
        //        cell.noDisLike.text = [NSString stringWithFormat:@"👎 %ld",(long)value.dislikecount];
        
        NSTextAttachment *attachment2 = [[NSTextAttachment alloc] init];
        attachment2.image = [UIImage imageNamed:@"unlike-normal"];
        attachment2.bounds = CGRectMake(0, imageOffsetY, attachment2.image.size.width, attachment2.image.size.height);
        NSAttributedString *attachmentString2 = [NSAttributedString attributedStringWithAttachment:attachment2];
        NSMutableAttributedString *myString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.duetdislikecount]];
        NSMutableAttributedString *finalDisLike = [[NSMutableAttributedString alloc]init];
        [finalDisLike appendAttributedString:attachmentString2];
        [finalDisLike appendAttributedString:myString2];
        //        [myString appendAttributedString:attachmentString];
        cell.noDisLike.textAlignment=NSTextAlignmentRight;
        cell.noDisLike.attributedText = finalDisLike;
        
        
        //        cell.noSmile.text = [NSString stringWithFormat:@"😀 %ld",(long)value.smilecount];
        
        NSTextAttachment *attachment3 = [[NSTextAttachment alloc] init];
        attachment3.image = [UIImage imageNamed:@"smile-normal"];
        attachment3.bounds = CGRectMake(0, imageOffsetY, attachment3.image.size.width, attachment3.image.size.height);
        NSAttributedString *attachmentString3 = [NSAttributedString attributedStringWithAttachment:attachment3];
        NSMutableAttributedString *myString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.duetsmilecount]];
        NSMutableAttributedString *finalSmile = [[NSMutableAttributedString alloc]init];
        [finalSmile appendAttributedString:attachmentString3];
        [finalSmile appendAttributedString:myString3];
        //        [myString appendAttributedString:attachmentString];
        cell.noSmile.textAlignment=NSTextAlignmentRight;
        cell.noSmile.attributedText = finalSmile;
        
        cell.noView.text = [NSString stringWithFormat:@"▶️ %ld",(long)value.duetviewcount];
        
        //        NSTextAttachment *attachment4 = [[NSTextAttachment alloc] init];
        //        attachment4.image = [UIImage imageNamed:@"like-normal"];
        //        attachment4.bounds = CGRectMake(0, imageOffsetY, attachment4.image.size.width, attachment4.image.size.height);
        //        NSAttributedString *attachmentString4 = [NSAttributedString attributedStringWithAttachment:attachment4];
        //        NSMutableAttributedString *myString4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  0"]];
        //        NSMutableAttributedString *finalView = [[NSMutableAttributedString alloc]init];
        //        [finalView appendAttributedString:attachmentString4];
        //        [finalView appendAttributedString:myString4];
        //        //        [myString appendAttributedString:attachmentString];
        //        cell.noView.textAlignment=NSTextAlignmentRight;
        //        cell.noView.attributedText = finalView;
        
        
        NSString *dateStr = value.created_at;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        NSDate *currDate = [NSDate date];
        
        //        NSCalendar*       calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //        NSDateComponents* components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
        //        NSInteger         day = [components day];
        //        NSInteger         month = [components month];
        //        NSInteger         year = [components year];
        //        NSLog(@"d=%ld/m=%ld/y=%ld", (long)day, (long)month, (long)year);
        NSLog(@"result=%@",[self startTime:date endDate:currDate]);
        cell.time.text = [self startTime:date endDate:currDate];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:value.musicimage_filename] placeholderImage:[UIImage imageNamed:@"musicPlaceholder"]];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"invitesListCell";
        
        InvitesTableViewCell *cell = [self.invites_TableView dequeueReusableCellWithIdentifier:cellIdentifier];
        InvitesSoloDetail *value = [self.invitesList_arr objectAtIndex:indexPath.row];
        
        // [cell.check_Box addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [UIButton setCornerRadius:cell.battle_Btn radius:10];
        [UIView setCornerRadius:cell.songBack_View radius:10];
        [UIView setCornerRadius:cell.profileBack_View radius:cell.profileBack_View.frame.size.height/2];
        [UIImageView setCornerRadius:cell.profilePic_Img radius:cell.profilePic_Img.frame.size.height/2];
        cell.name_Lbl.text = value.username;
        cell.songName_Lbl.text = value.title;
        cell.size_Lbl.text = [NSString stringWithFormat:@"▶️ %ld",(long)value.soloviewcount];
        cell.battle_Btn.tag = indexPath.row;
        NSString *dateStr = value.created_at;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        NSDate *currDate = [NSDate date];
        
        //        NSCalendar*       calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //        NSDateComponents* components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
        //        NSInteger         day = [components day];
        //        NSInteger         month = [components month];
        //        NSInteger         year = [components year];
        //        NSLog(@"d=%ld/m=%ld/y=%ld", (long)day, (long)month, (long)year);
        cell.date_Lbl.text = [self startTime:date endDate:currDate];
        
        //    cell.name_Lbl.text = value.
        [cell.profilePic_Img sd_setImageWithURL:[NSURL URLWithString:value.user_profileimage] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
        [cell.song_Img sd_setImageWithURL:[NSURL URLWithString:value.musicimage_filename] placeholderImage:[UIImage imageNamed:@"musicPlaceholder"]];
        
        cell.profilePic_Img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        tapGesture1.numberOfTapsRequired = 1;
        tapGesture1.view.tag = indexPath.row;
        cell.profilePic_Img.tag = indexPath.row;

        [cell.profilePic_Img addGestureRecognizer:tapGesture1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void) tapGesture: (UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"tag=%ld",(long)view.tag);
    //handle Tap...
    InvitesSoloDetail *value = [self.invitesList_arr objectAtIndex:view.tag];
    sendUser_ID = value.user_id;
    [self performSegueWithIdentifier:@"segueNotificationToProfileView" sender:nil];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_titleButtonSelected.tag == 0) {
        MusicDuetFeed *value = [_activityList_arr objectAtIndex:indexPath.row];
        _songTitle = value.title;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *URL = [NSURL URLWithString:value.record_filename];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                                completionHandler:
                                                  ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                      if (error == nil) {
                                                          NSError *error;
                                                          //getting docs dir path
                                                          NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                          NSString *docsDir = [tempArray objectAtIndex:0];
                                                          
                                                          //adding folder path
                                                          NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
                                                          
                                                          NSFileManager *fileManager = [NSFileManager defaultManager];
                                                          
                                                          if([fileManager fileExistsAtPath:appDir])
                                                          {
                                                              
                                                              [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
                                                          }
                                                          
                                                          [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
                                                          
                                                          BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
                                                          
                                                          NSLog(fileCopied ? @"Yes" : @"No");
                                                          
                                                          if (fileCopied) {
                                                              NSURL *url = [NSURL URLWithString:appDir];
                                                              url = [url URLByAppendingPathComponent:@"/demo.mp4"];
                                                              NSLog(@"filecopied-url==%@",url);
                                                          }else{
                                                              
                                                          }
                                                          NSString *str = NSHomeDirectory();
                                                          str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
                                                          NSLog(@"str-path==%@",str);
                                                          //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
                                                          //    NSLog(@"%@",audioPath);
                                                          self->_videoURL = [NSURL fileURLWithPath:str];
                                                          
                                                          //move next vc
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                              self.tabBarController.tabBar.userInteractionEnabled = true;
                                                              [self performSegueWithIdentifier:@"SegueNotificationToCommonVPlay" sender:nil];
                                                          });
                                                      }else{
                                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                          self.tabBarController.tabBar.userInteractionEnabled = true;
                                                          [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                      }
                                                      
                                                  }];
        
        [downloadTask resume];
    }
    
}


- (IBAction)settingsBarAction:(id)sender {
    
    
}
- (IBAction)startRap_Action:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

-(void)getInvitesList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;

        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/inviteduser",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->_searchBar.text forKey:@"search"];

        
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
                        NSLog(@"inviteduser response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            UserInviteResponse *object = [[UserInviteResponse alloc]initWithData:data error:&jsonModelError];
                            
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"inviteduser Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                if (object.inviteduser.count == 0) {
                                    self->_noData_Lbl.hidden = NO;
                                }else{
                                    self->_noData_Lbl.hidden = YES;
                                }
                                self->_invitesList_arr = [object.inviteduser mutableCopy];
                                [self->_invites_TableView reloadData];
                            
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

-(void)getActivityList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //       http://hiphoplive.sitecare.org/api/v1/musicacceptlis
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicacceptlist",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->_searchBar.text forKey:@"search"];

        
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
                        NSLog(@"musicacceptlist response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            MusicFeedResponse *object = [[MusicFeedResponse alloc]initWithData:data error:&jsonModelError];

                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"musicacceptlist Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                if (object.acceptedduet.count == 0) {
                                    self->_activity_View.hidden = NO;
                                    self->_invites_TableView.hidden = YES;
                                    self->_noData_Lbl.hidden = YES;
                                }else{
                                    self->_noData_Lbl.hidden = YES;
                                    self->_activity_View.hidden = YES;
                                    self->_invites_TableView.hidden = NO;
                                }
                                self->_activityList_arr = [object.acceptedduet mutableCopy];
                                [self->_invites_TableView reloadData];
                                
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

//- (IBAction)battle_Action:(UIButton*)sender {
//    _invitesselectedValue = [self.invitesList_arr objectAtIndex:sender.tag];
//
//    //multiple download
//    // Session
//    _songTitle = _invitesselectedValue.title;
//    NSURLSessionConfiguration *configFirst = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.first"];
//    notifysessionFirst = [NSURLSession sessionWithConfiguration:configFirst delegate:self delegateQueue:nil];
//
//    NSURLSessionConfiguration *configSecond = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.second"];
//    notifysessionSecond = [NSURLSession sessionWithConfiguration:configSecond delegate:self delegateQueue:nil];
//
//    // Start First Download
//    NSURLRequest *requestFirst = [NSURLRequest requestWithURL:[NSURL URLWithString:_invitesselectedValue.record_filename]];
//    NSURLSessionDownloadTask *downloadTaskFirst = [notifysessionFirst downloadTaskWithRequest:requestFirst];
//    [downloadTaskFirst resume];
//
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = @"Loading";
//    self.tabBarController.tabBar.userInteractionEnabled = false;
//
//}
//callback used
- (IBAction)battle_Action:(UIButton*)sender {
    
    _invitesselectedValue = [self.invitesList_arr objectAtIndex:sender.tag];
    _songTitle = _invitesselectedValue.title;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tabBarController.tabBar.userInteractionEnabled = false;
    
    //audio download
    NSURL *URL = [NSURL URLWithString:_invitesselectedValue.record_filename];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                 
                                                  if (error == nil){
                                                    
                                                      
                                                      NSError *error;
                                                      //getting docs dir path
                                                      NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                      NSString *docsDir = [tempArray objectAtIndex:0];
                                                      
                                                      //adding folder path
                                                      NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
                                                      
                                                      NSFileManager *fileManager = [NSFileManager defaultManager];
                                                      
                                                      if([fileManager fileExistsAtPath:appDir])
                                                      {
                                                          
                                                          [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
                                                      }
                                                      
                                                      [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
                                                      
                                                      BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
                                                      
                                                      NSLog(fileCopied ? @"Yes" : @"No");
                                                      
                                                      if (fileCopied) {
                                                          NSURL *url = [NSURL URLWithString:appDir];
                                                          url = [url URLByAppendingPathComponent:@"/demo.mp4"];
                                                          NSLog(@"filecopied-url==%@",url);
                                                      }else{
                                                          
                                                      }
                                                      NSString *str = NSHomeDirectory();
                                                      str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
                                                      NSLog(@"str-path==%@",str);
                                                      //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
                                                      //    NSLog(@"%@",audioPath);
                                                      //
                                                      self->_videoURL = [NSURL fileURLWithPath:str];

                                                      //lrc download
                                                      NSURL *URL = [NSURL URLWithString:self->_invitesselectedValue.music_lyrics_filename];
                                                      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                                                      
                                                      NSURLSession *session = [NSURLSession sharedSession];
                                                      NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                                                                              completionHandler:
                                                                                                ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                                                    if (error == nil) {
                                                                                                        NSError *error;
                                                                                                        //getting docs dir path
                                                                                                        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                                                                        NSString *docsDir = [tempArray objectAtIndex:0];
                                                                                                        
                                                                                                        //adding folder path
                                                                                                        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Lrc/"];
                                                                                                        
                                                                                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                                                        
                                                                                                        if([fileManager fileExistsAtPath:appDir])
                                                                                                        {
                                                                                                            
                                                                                                            [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
                                                                                                        }
                                                                                                        
                                                                                                        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
                                                                                                        
                                                                                                        BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/lrcview.lrc"] error:&error];
                                                                                                        
                                                                                                        NSLog(fileCopied ? @"Yes" : @"No");
                                                                                                        
                                                                                                        if (fileCopied) {
                                                                                                            NSURL *url = [NSURL URLWithString:appDir];
                                                                                                            url = [url URLByAppendingPathComponent:@"/lrcview.lrc"];
                                                                                                            NSLog(@"filecopied-lrcurl==%@",url);
                                                                                                        }else{
                                                                                                            
                                                                                                        }
                                                                                                        NSString *str = NSHomeDirectory();
                                                                                                        str = [str stringByAppendingString:@"/Documents/Lrc/lrcview.lrc"];
                                                                                                        NSLog(@"lrc-path==%@",str);
                                                                                                        //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
                                                                                                        //    NSLog(@"%@",audioPath);
                                                                                                        //
                                                                                                        VTXLyricParser *lyricParser = [[VTXBasicLyricParser alloc] init];
                                                                                                        self->_lyric = [lyricParser lyricFromLocalPathFileName:str];
                                                                                                        //move next vc
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                            self.tabBarController.tabBar.userInteractionEnabled = false;
                                                                                                            [self performSegueWithIdentifier:@"SegueNotificationToSoloMusicVC" sender:nil];
                                                                                                            
                                                                                                        });
                                                                                                    }else{
                                                                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                        self.tabBarController.tabBar.userInteractionEnabled = true;
                                                                                                        [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                                                                    }
                                                                                                    
                                                                                                }];
                                                      
                                                      [downloadTask resume];
                                                  }else{
                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                      self.tabBarController.tabBar.userInteractionEnabled = true;
                                                      [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                  }
                                              }];
    
    [downloadTask resume];
    
}

////MARK: Nsurlsession delegate
//-(void)URLSession:(NSURLSession* )session task:(NSURLSessionTask* )task didCompleteWithError:(NSError *)error
//{
//    NSLog(@"%@",[error localizedDescription]);
//    //    [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
//}
//
//
//-(void) URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    if (_titleButtonSelected.tag == 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            NSLog(@"%f",value);
//        });
//    }else if (session == notifysessionSecond){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            NSLog(@"%f",value);
//        });
//    }
//
//}
//
//-(void) URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//
//}
//
//-(void) URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//
//
//        if (_titleButtonSelected.tag == 0) {
//            NSError *error;
//            //getting docs dir path
//            NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docsDir = [tempArray objectAtIndex:0];
//
//            //adding folder path
//            NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
//
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//
//            if([fileManager fileExistsAtPath:appDir])
//            {
//
//                [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
//            }
//
//            [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
//
//            BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
//
//            NSLog(fileCopied ? @"Yes" : @"No");
//
//            if (fileCopied) {
//                NSURL *url = [NSURL URLWithString:appDir];
//                url = [url URLByAppendingPathComponent:@"/demo.mp4"];
//                NSLog(@"filecopied-url==%@",url);
//            }else{
//
//            }
//            NSString *str = NSHomeDirectory();
//            str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
//            NSLog(@"str-path==%@",str);
//            //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//            //    NSLog(@"%@",audioPath);
//            _videoURL = [NSURL fileURLWithPath:str];
//
//            //move next vc
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self->hud hideAnimated:YES];
//                self.tabBarController.tabBar.userInteractionEnabled = false;
//                [self performSegueWithIdentifier:@"SegueNotificationToCommonVPlay" sender:nil];
//            });
//        }else if (session == notifysessionFirst) {
//            // Start second Download
//            NSURLRequest *requestSecond = [NSURLRequest requestWithURL:[NSURL URLWithString:_invitesselectedValue.music_lyrics_filename]];
//            NSURLSessionDownloadTask *downloadTaskSecond = [notifysessionSecond downloadTaskWithRequest:requestSecond];
//            [downloadTaskSecond resume];
//
//            NSError *error;
//            //getting docs dir path
//            NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docsDir = [tempArray objectAtIndex:0];
//
//            //adding folder path
//            NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
//
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//
//            if([fileManager fileExistsAtPath:appDir])
//            {
//
//                [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
//            }
//
//            [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
//
//            BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
//
//            NSLog(fileCopied ? @"Yes" : @"No");
//
//            if (fileCopied) {
//                NSURL *url = [NSURL URLWithString:appDir];
//                url = [url URLByAppendingPathComponent:@"/demo.mp4"];
//                NSLog(@"filecopied-url==%@",url);
//            }else{
//
//            }
//            NSString *str = NSHomeDirectory();
//            str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
//            NSLog(@"str-path==%@",str);
//            //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//            //    NSLog(@"%@",audioPath);
//            //
//            _videoURL = [NSURL fileURLWithPath:str];
//        }else{
//            //        NSFileHandle *logFile = nil;
//            //        logFile = [NSFileHandle fileHandleForWritingAtPath:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"lrc"]];
//            //
//            //        //make path to file
//            //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"lrc"];
//            //
//            //        //write file
//            //        [[location path] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//
//            NSError *error;
//            //getting docs dir path
//            NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docsDir = [tempArray objectAtIndex:0];
//
//            //adding folder path
//            NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Lrc/"];
//
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//
//            if([fileManager fileExistsAtPath:appDir])
//            {
//
//                [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
//            }
//
//            [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
//
//            BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/lrcview.lrc"] error:&error];
//
//            NSLog(fileCopied ? @"Yes" : @"No");
//
//            if (fileCopied) {
//                NSURL *url = [NSURL URLWithString:appDir];
//                url = [url URLByAppendingPathComponent:@"/lrcview.lrc"];
//                NSLog(@"filecopied-lrcurl==%@",url);
//            }else{
//
//            }
//            NSString *str = NSHomeDirectory();
//            str = [str stringByAppendingString:@"/Documents/Lrc/lrcview.lrc"];
//            NSLog(@"lrc-path==%@",str);
//            //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//            //    NSLog(@"%@",audioPath);
//            //
//            VTXLyricParser *lyricParser = [[VTXBasicLyricParser alloc] init];
//            _lyric = [lyricParser lyricFromLocalPathFileName:str];
//            //move next vc
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self->hud hideAnimated:YES];
//                self.tabBarController.tabBar.userInteractionEnabled = false;
//                [self performSegueWithIdentifier:@"SegueNotificationToSoloMusicVC" sender:nil];
//
//            });
//        }
//
//}
//================


//# MARK: search delegate methods
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    if (_titleButtonSelected.tag == 0) {
        [self getActivityList];
        
    }else if (_titleButtonSelected.tag == 1){
        _activity_View.hidden = YES;
        _invites_TableView.hidden = NO;
        [self getInvitesList];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [_searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueNotificationToSoloMusicVC"]) {
        
        SoloMusicViewController *videoVC  = segue.destinationViewController;
        videoVC.videoURL = _videoURL;
        videoVC.songTitle = _songTitle;
        videoVC.lyric = _lyric;
        videoVC.invitesselectedValue = _invitesselectedValue;
        videoVC.selectionType = @"notification";
    }else if ([segue.identifier isEqualToString:@"segueNotificationToProfileView"]){
        UserProfileView *Vc = segue.destinationViewController;
        Vc.userID = sendUser_ID;
    }else if ([segue.identifier isEqualToString:@"SegueNotificationToCommonVPlay"]) {
        CommonVideoPlayerViewController *videoVC  = segue.destinationViewController;
        videoVC.getVideoURL = _videoURL;
        videoVC.songTitle = _songTitle;
        
    }
}



@end
