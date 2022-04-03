//
//  ProfileViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 08/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
{
    UserDetails *object;
    bool isEdit;
    
    NSURL *videoURL;
    NSString *songTitle;
    MBProgressHUD *hud;
    
    NSInteger state_ID;
    NSInteger countryID;
    
    //send data
    NSString *music_solo_id;
    NSString *music_id;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [UIImageView setCornerRadius:_profileImage radius:_profileImage.frame.size.height/2];
    [_profileImage setImage:[UIImage imageNamed:@"profilePlaceholder"]];
    _profileImage.contentMode = UIViewContentModeScaleAspectFill;

//    _profileImage.layer.cornerRadius = _profileImage.frame.size.height/2;
//    _profileImage.clipsToBounds = YES;
    _buttonTitleArry = [[NSArray alloc]initWithObjects:@"My Profile",@"Solo List",@"Duet List",@"Featured States",@"Merchandise", nil];
    isEdit = false;
    [self createScrollMenu];
    
    stateArr = [[NSMutableArray<StateDetail> alloc]init];
    countryArr = [[NSMutableArray<CountryDetail> alloc]init];
    
    //new scroll
    // Register notification when the keyboard will be show
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//    // Register notification when the keyboard will be hide
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self getUserDetail];
}
- (void)getUserDetail{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getuserinfo",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
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
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"getuserinfo response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            self->object = [[UserDetails alloc]initWithData:data error:&jsonModelError];
                            if (self->object == nil) {
                                [self showNoHandlerAlertWithTitle:@"UserDetails Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                            
                            [Singletons sharedManager].userDetail  = self->object;
                            
                            self->_displayName.text = self->object.display_name?self->object.display_name:@"";
                            
                            [self->_followers setTitle:[NSString stringWithFormat:@"%d Followers",self->object.followers] forState:UIControlStateNormal];
                            [self->_following setTitle:[NSString stringWithFormat:@"%d Following",self->object.following] forState:UIControlStateNormal];
                            
                            [self->_profileImage sd_setImageWithURL:[NSURL URLWithString:self->object.imagename] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
                            
//                            self->_tableTitleArr = [[NSArray alloc]initWithObjects:@"Display Name  :",@"        Message  :",@"     First Name  :",@"     Last Name  :",@"              Email  :",@"     UserName  :",@"            Phone  :",@"        Country   :",@"             State   :",@"                City  :", nil];
//                            self->_tableValueArr = [[NSMutableArray alloc]init];
//                                [self->_tableValueArr addObject:self->object.display_name?self->object.display_name:@""];
//                                [self->_tableValueArr addObject:self->object.personal_message?self->object.personal_message:@""];
//                            [self->_tableValueArr addObject:self->object.firstname];
//                            [self->_tableValueArr addObject:self->object.lastname];
//                            [self->_tableValueArr addObject:self->object.email];
//                            [self->_tableValueArr addObject:self->object.username];
//                            [self->_tableValueArr addObject:self->object.phone];
//                            [self->_tableValueArr addObject:self->object.countryName];
//                            [self->_tableValueArr addObject:self->object.stateName];
//                            [self->_tableValueArr addObject:self->object.city];
//
                            [self->_tableView reloadData];

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
- (void)createScrollMenu
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    
    int x = 5;
    for (int i = 0; i < _buttonTitleArry.count; i++) {
        
        CGSize stringBoundingBox = [[_buttonTitleArry objectAtIndex:i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]}];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, stringBoundingBox.width, 50)];
        [button setTitle:[NSString stringWithFormat:@"%@",[_buttonTitleArry objectAtIndex:i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;
        button.tag = i;
        
        if (i == 0){
//            [UIButton setBottomLineForButton:button setColor:[UIColor colorWithRed:215/255.0 green:39/255.0 blue:251/255.0 alpha:1.0].CGColor borderWidth:2];
            _titlebtnBottomView = [[UIView alloc] initWithFrame:CGRectMake(x, button.frame.size.height-3, button.frame.size.width, 2)];
            [_titlebtnBottomView setBackgroundColor:[UIColor colorWithRed:239/255.0 green:67/255.0 blue:176/255.0 alpha:1.0]];
            [_scrollView addSubview:_titlebtnBottomView];
            [button setTitleColor:[UIColor colorWithRed:239/255.0 green:67/255.0 blue:176/255.0 alpha:1.0] forState:UIControlStateNormal];
            _titleButtonSelected = button;
            [self getUserDetail];
//            [self->_tableView reloadData];

        }

        [_scrollView addSubview:button];
        x += button.frame.size.width+20;
    }
    
    _scrollView.contentSize = CGSizeMake(x, 50);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollsToTop = false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.bounces = false;
    [_buttonTitleView addSubview:_scrollView];
}
-(void)titleButtonPressed:(UIButton*)button{
//    [UIButton setBottomLineForButton:button setColor:[UIColor colorWithRed:215/255.0 green:39/255.0 blue:251/255.0 alpha:1.0].CGColor borderWidth:2];
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = self->_titlebtnBottomView.frame;
         frame.origin.y = button.frame.size.height-3;
         frame.origin.x = button.frame.origin.x;
         frame.size.width = button.frame.size.width;
         frame.size.height = 2;
         self->_titlebtnBottomView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    [button setTitleColor:[UIColor colorWithRed:239/255.0 green:67/255.0 blue:176/255.0 alpha:1.0] forState:UIControlStateNormal];
    if (_titleButtonSelected != nil && _titleButtonSelected != button) {
        [_titleButtonSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [UIButton setBottomLineForButton:_titleButtonSelected setColor:[UIColor colorWithRed:83/255.0 green:61/255.0 blue:180/255.0 alpha:1.0].CGColor borderWidth:2];
        

    }
    isEdit = false;
    _titleButtonSelected = button;
    [self ApiCall];
}
-(void)ApiCall{
    if (_titleButtonSelected.tag == 0){
        [self getUserDetail];
//        [self->_tableView reloadData];

    }else if (_titleButtonSelected.tag == 1){
        [self getusersololist];
    }else if (_titleButtonSelected.tag == 2){
        [self getuserduetlist];
    }else{
        [_tableView reloadData];
    }
}

-(void)getusersololist{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/usersololist",Base_URL]];
        
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
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"usersololist response = %@",str);
                        
                        JSONModelError *jsonModelError = nil;
                        ChannelResponse *object = [[ChannelResponse alloc]initWithData:data error:&jsonModelError];
                        
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"usersololist Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{
                            [self->_tableValueArr removeAllObjects];
                            self->_tableValueArr = [object.RecordedSoloList mutableCopy];
                            
                            [self->_tableView reloadData];
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

-(void)getuserduetlist{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userduetlist",Base_URL]];
        
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
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"userduetlist response = %@",str);
                        
                        JSONModelError *jsonModelError = nil;
                        ChannelResponse *object = [[ChannelResponse alloc]initWithData:data error:&jsonModelError];
                        
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"usersololist Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{
                            [self->_tableValueArr removeAllObjects];
                            self->_tableValueArr = [object.RecordedDuetList mutableCopy];
                            
                            [self->_tableView reloadData];
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
//MARK: tableview datasource delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_titleButtonSelected.tag == 0) {
//        return 40;
        return 486;
    }else if (_titleButtonSelected.tag == 1){
        return 84;
    }else if (_titleButtonSelected.tag == 2){
        return 84;
    }
    return UITableViewAutomaticDimension;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (_titleButtonSelected.tag == 0 || _titleButtonSelected.tag == 1){
//        return 1;
//    }else{
//        return 0;
//    }
//    return 0;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_titleButtonSelected.tag == 0){
//        return _tableValueArr.count;
        return 1;
    }else if (_titleButtonSelected.tag == 1 || _titleButtonSelected.tag == 2){
        return _tableValueArr.count;
    }
    return 0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *profileTableCellIdentifier = @"Cell";
    static NSString *profileTableCellIdentifier = @"myprofileCell";
    static NSString *ChannelCellCellIdentifier = @"ChannelCell";

     MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:profileTableCellIdentifier];
    if (_titleButtonSelected.tag == 0){
        MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:profileTableCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyProfileTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.displayName_Txt.text = object.display_name;
        self->_displayName.text = object.display_name;
        cell.message_Txt.text = object.personal_message;
        cell.first_Txt.text = object.firstname;
        cell.lastName_Txt.text = object.lastname;
        cell.email_Txt.text = object.email;
        cell.email_Txt.tag = 4;
        cell.userName_Txt.text = object.username;
        cell.phone_Txt.text = object.phone;
        cell.country_Txt.text = object.countryName;
        cell.state_Txt.text = object.stateName;
        cell.city_Txt.text = object.city;
        
        state_ID = object.stateID;
        countryID = object.countryID;
        
        [UIColor setBottomLineForTextField:cell.displayName_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.message_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.first_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.lastName_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.email_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.userName_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.phone_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.country_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.state_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
        [UIColor setBottomLineForTextField:cell.city_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
    
        cell.displayName_Txt.delegate = self;
        cell.message_Txt.delegate = self;
        cell.first_Txt.delegate = self;
        cell.lastName_Txt.delegate = self;
        cell.email_Txt.delegate = self;
        cell.userName_Txt.delegate = self;
        cell.phone_Txt.delegate = self;
        cell.country_Txt.delegate = self;
        cell.state_Txt.delegate = self;
        cell.city_Txt.delegate = self;
//        [cell.city_Txt addTarget:self action:@selector(formValidation) forControlEvents:UIControlEventEditingDidBegin];

        [cell.changePwd_Btn addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
        [UIButton setCornerRadius:cell.changePwd_Btn radius:10];
        [cell.Edit_Btn addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //new
//        NSString *val = [_tableTitleArr objectAtIndex:indexPath.row];
//        cell.title_Lbl.text = val;
//        cell.value_Txt.placeholder = [[val stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
//        [UIColor setBottomLineForTextField:cell.value_Txt setColor:[UIColor darkGrayColor].CGColor borderWidth:1];
//        cell.value_Txt.text = [_tableValueArr objectAtIndex:indexPath.row];
//        cell.value_Txt.tag = indexPath.row;
//        cell.value_Txt.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(_titleButtonSelected.tag == 1){
        ChannelTableViewCell *cell = (ChannelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChannelCellCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ChannelDetail *value = [_tableValueArr objectAtIndex:indexPath.row];

        cell.songName.text = value.title;
        cell.userName.text = value.username;
        
        CGFloat imageOffsetY = -5.0;
//        cell.noLike.text = [NSString stringWithFormat:@"👍 %ld",(long)value.likecount];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"like-normal"];
        attachment.bounds = CGRectMake(0, imageOffsetY, attachment.image.size.width, attachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.sololikecount]];
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
        NSMutableAttributedString *myString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.sololovecount]];
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
        NSMutableAttributedString *myString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.solodislikecount]];
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
        NSMutableAttributedString *myString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld",(long)value.solosmilecount]];
        NSMutableAttributedString *finalSmile = [[NSMutableAttributedString alloc]init];
        [finalSmile appendAttributedString:attachmentString3];
        [finalSmile appendAttributedString:myString3];
        //        [myString appendAttributedString:attachmentString];
        cell.noSmile.textAlignment=NSTextAlignmentRight;
        cell.noSmile.attributedText = finalSmile;
        
        cell.noView.text = [NSString stringWithFormat:@"▶️ %ld",(long)value.soloviewcount];
        
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
        
        cell.moreoption_Btn.hidden = false;
        cell.moreoption_Img.hidden = false;
        cell.moreoption_Btn.tag = indexPath.row;
        [cell.moreoption_Btn addTarget:self action:@selector(moreOptionClick:) forControlEvents:UIControlEventTouchUpInside];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if(_titleButtonSelected.tag == 2){
        ChannelTableViewCell *cell = (ChannelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChannelCellCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        MusicDuetFeed *value = [_tableValueArr objectAtIndex:indexPath.row];
        
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.moreoption_Btn.hidden = false;
        cell.moreoption_Img.hidden = false;
        cell.moreoption_Btn.tag = indexPath.row;
        [cell.moreoption_Btn addTarget:self action:@selector(moreOptionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return cell;
}

-(void)moreOptionClick:(UIButton*)button{
    
   if(_titleButtonSelected.tag == 1){
       ChannelDetail *value = [_tableValueArr objectAtIndex:button.tag];
       
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"More Options"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleActionSheet]; // 1
       UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Invite"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 NSLog(@"You pressed button one");
                                                                 self->music_id = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:value.music_id]];
                                                                 self->music_solo_id = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:value.id]];
                                                                 
                                                                 [self performSegueWithIdentifier:@"SegueProfileVCToUserInvite" sender:nil];
                                                             }]; // 2
       UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button two");
                                                                  
                                                              }]; // 3
       UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Delete"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 NSLog(@"You pressed button one");
                                                                
                                                                 [self deletesolo:value.id];
                                                                
                                                             }]; // 2
       UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button two");
                                                                  
                                                              }]; // 3
       
       [alert addAction:firstAction]; // 4
       [alert addAction:secondAction]; // 5
       [alert addAction:thirdAction]; // 5
       [alert addAction:fourthAction]; // 5

       
       [self presentViewController:alert animated:YES completion:nil]; // 6
   }else{
       MusicDuetFeed *value = [_tableValueArr objectAtIndex:button.tag];

       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"More Options"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleActionSheet]; // 1
       UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Delete"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 NSLog(@"You pressed button one");
                                                                
                                                                 [self deleteduet:value.id];
                                                                
                                                             }]; // 2
       UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button two");
                                                                  
                                                              }]; // 3
       UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button two");
                                                                  
                                                              }]; // 3
       
       [alert addAction:firstAction]; // 4
       [alert addAction:secondAction]; // 5
       [alert addAction:thirdAction]; // 5

       
       [self presentViewController:alert animated:YES completion:nil]; // 6
   }
    
}

//solomusic delete
-(void)deletesolo:(int)music_solo_id{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        http://hiphoplive.sitecare.org/api/v1/deletesolo
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/deletesolo",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:[NSNumber numberWithInt:music_solo_id] forKey:@"music_solo_id"];

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
                        NSLog(@"deletesolo response = %@",str);
                        
                        JSONModelError *jsonModelError = nil;
                        CommonResponse *object = [[CommonResponse alloc]initWithData:data error:&jsonModelError];
                        
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"deletesolo Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{
                            [self showAlertWithTitle:@"" andMessage:object.message buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                [self getusersololist];

                            }];

                        }
                        
                    }
                    
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                    
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = false;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//duetmusic delete
-(void)deleteduet:(int)music_solo_id{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        http://hiphoplive.sitecare.org/api/v1/deleteduet
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/deleteduet",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:[NSNumber numberWithInt:music_solo_id] forKey:@"music_duet_id"];
        
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
                        NSLog(@"deleteduet response = %@",str);
                        
                        JSONModelError *jsonModelError = nil;
                        CommonResponse *object = [[CommonResponse alloc]initWithData:data error:&jsonModelError];
                        
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"deleteduet Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{
                            [self showAlertWithTitle:@"" andMessage:object.message buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                [self getuserduetlist];

                            }];
                        }
                        
                    }
                    
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                    
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            self.tabBarController.tabBar.userInteractionEnabled = false;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_titleButtonSelected.tag == 1){
        
        ChannelDetail *value = [_tableValueArr objectAtIndex:indexPath.row];
        songTitle = value.title;
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
                                                          self->videoURL = [NSURL fileURLWithPath:str];
                                                          
                                                          //move next vc
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                              self.tabBarController.tabBar.userInteractionEnabled = false;
                                                              [self performSegueWithIdentifier:@"SegueProfileToCommonVPlay" sender:nil];
                                                          });
                                                      }else{
                                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                          self.tabBarController.tabBar.userInteractionEnabled = true;
                                                          [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                      }
                                                      
                                                  }];
        
        [downloadTask resume];
        
        
        
    }else if (_titleButtonSelected.tag == 2){
        
        
        MusicDuetFeed *value = [_tableValueArr objectAtIndex:indexPath.row];
        songTitle = value.title;
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
                                                          self->videoURL = [NSURL fileURLWithPath:str];
                                                          
                                                          //move next vc
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                              self.tabBarController.tabBar.userInteractionEnabled = false;
                                                              [self performSegueWithIdentifier:@"SegueProfileToCommonVPlay" sender:nil];
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


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (_titleButtonSelected.tag == 0){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//        /* Create custom view to display section header... */
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//        [label setFont:[UIFont boldSystemFontOfSize:12]];
//        NSString *string =@"PROFILE";
//        /* Section header is in 0th index... */
//        [label setText:string];
//
//        //add button
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 75, 5, 75, 18)];
//        [button setTitle:@"Edit" forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor clearColor]];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        //    button.titleLabel.numberOfLines = 1;
//        //    button.titleLabel.adjustsFontSizeToFitWidth = YES;
//        //    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
//        //    button.tag = i;
//        //
//        [view addSubview:button];
//        [view addSubview:label];
//        [view setBackgroundColor:[UIColor lightGrayColor]]; //your background color...
//        return view;
//    }else{
//        return nil;
//    }
//
//}

-(void)channelSelected:(ChannelDetail*)value{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        songTitle = value.title;
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:value.record_filename]];
        [downloadTask resume];
    
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"Loading";
    
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
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            NSLog(@"%f",value);
//        });
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
//    if (_titleButtonSelected.tag == 2){
//        NSError *error;
//        //getting docs dir path
//        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docsDir = [tempArray objectAtIndex:0];
//
//        //adding folder path
//        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        if([fileManager fileExistsAtPath:appDir])
//        {
//
//            [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
//        }
//
//        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
//
//        BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
//
//        NSLog(fileCopied ? @"Yes" : @"No");
//
//        if (fileCopied) {
//            NSURL *url = [NSURL URLWithString:appDir];
//            url = [url URLByAppendingPathComponent:@"/demo.mp4"];
//            NSLog(@"filecopied-url==%@",url);
//        }else{
//
//        }
//        NSString *str = NSHomeDirectory();
//        str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
//        NSLog(@"str-path==%@",str);
//        //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//        //    NSLog(@"%@",audioPath);
//        videoURL = [NSURL fileURLWithPath:str];
//
//        //move next vc
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self->hud hideAnimated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = false;
//            [self performSegueWithIdentifier:@"SegueProfileToCommonVPlay" sender:nil];
//        });
//    }else{
//        NSError *error;
//        //getting docs dir path
//        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docsDir = [tempArray objectAtIndex:0];
//
//        //adding folder path
//        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp4/"];
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        if([fileManager fileExistsAtPath:appDir])
//        {
//
//            [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
//        }
//
//        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
//
//        BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error];
//
//        NSLog(fileCopied ? @"Yes" : @"No");
//
//        if (fileCopied) {
//            NSURL *url = [NSURL URLWithString:appDir];
//            url = [url URLByAppendingPathComponent:@"/demo.mp4"];
//            NSLog(@"filecopied-url==%@",url);
//        }else{
//
//        }
//        NSString *str = NSHomeDirectory();
//        str = [str stringByAppendingString:@"/Documents/Songs_Mp4/demo.mp4"];
//        NSLog(@"str-path==%@",str);
//        //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//        //    NSLog(@"%@",audioPath);
//        videoURL = [NSURL fileURLWithPath:str];
//
//        //move next vc
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self->hud hideAnimated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = false;
//            [self performSegueWithIdentifier:@"SegueProfileToCommonVPlay" sender:nil];
//        });
//    }
//
//}
//===================


-(void)editButtonPressed:(UIButton*)button{
    
    if (isEdit){
                
        CGPoint center= button.center;
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:center];
        NSLog(@"%@",indexPath);
        
        MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.displayName_Txt.text isEqualToString:@""]){
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Display Name"];
        }else{
            if ([cell.message_Txt.text isEqualToString:@""]){
                [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Message"];
            }else{
                if ([cell.first_Txt.text isEqualToString:@""]){
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the First Name"];
                }else{
                    if ([cell.lastName_Txt.text isEqualToString:@""]) {
                        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Last Name"];
                    }else{
                        if ([cell.userName_Txt.text isEqualToString:@""]){
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the UserName"];
                        }else{
                            if ([cell.phone_Txt.text isEqualToString:@""]){
                                [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the Phone Number"];
                            }else{
                                if ([cell.country_Txt.text isEqualToString:@""]) {
                                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Choose the Country"];
                                }else{
                                    if ([cell.state_Txt.text isEqualToString:@""]){
                                        [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Choose the State"];
                                    }else{
                                        if ([cell.city_Txt.text isEqualToString:@""]){
                                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:@"Please Enter the City"];
                                        }else{

                                            
                                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                                            [button setTitle:@"Edit" forState:UIControlStateNormal];
                                            isEdit = false;
                                            [self updateProfile:cell];
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
    }else{
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        isEdit = true;
    }


}

-(void)updateProfile:(MyProfileTableViewCell*)cell{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/update",Base_URL]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:cell.displayName_Txt.text forKey:@"display_name"];
        [paramDic setObject:cell.message_Txt.text forKey:@"personal_message"];
        [paramDic setObject:cell.first_Txt.text forKey:@"firstname"];
        [paramDic setObject:cell.lastName_Txt.text forKey:@"lastname"];
        [paramDic setObject:cell.userName_Txt.text forKey:@"username"];
        [paramDic setObject:cell.phone_Txt.text forKey:@"phone"];
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self->state_ID] forKey:@"stateID"];
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self->countryID] forKey:@"countryID"];
        [paramDic setObject:cell.city_Txt.text forKey:@"city"];

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

                            [Singletons sharedManager].userDetail  = object.userDetail;
                            [self showAlertWithTitle:@"Wow 👍" andMessage:@"Successfully Updated" buttonTitles:@[@"Ok"] andHandler:^(UIAlertAction * _Nonnull action) {
                                
                                if ([action.title isEqualToString:@"Ok"]){
                                    self->object = object.userDetail;
                                    [self->_tableView reloadData];
                                }
                                
                            }];
                            
                            //                          }
                        }else{
                            NSDictionary *errorDic = [returnedDict objectForKey:@"error"];
                            
                            [self showNoHandlerAlertWithTitle:@"Profile Update failed 👎" andMessage:[[errorDic objectForKey:[[errorDic allKeys] objectAtIndex:0]] objectAtIndex:0]];
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
//MARK:Textfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (isEdit){
        if (textField.tag == 4){
            return false;
        }
//        CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:_tableView];
//        CGPoint contentOffset = _tableView.contentOffset;
//
//        contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
//
//        NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
//
//        [_tableView setContentOffset:contentOffset animated:YES];

        return true;

    }else{
        return false;
    }
    
    self.actifText = textField;
    return true;
}

//     **************
// To be link with your TextField event "Editing Did Begin"
//  memoryze the current TextField
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    self.actifText = textField;
}

// To be link with your TextField event "Editing Did End"
//  release current TextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.actifText = nil;
}

-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    if (self.actifText)
    {
        CGRect textFieldRect = [self.tableView convertRect:self.actifText.bounds fromView:self.actifText];
        [self.tableView scrollRectToVisible:textFieldRect animated:NO];
    }
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    [UIView commitAnimations];
}

// ************

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.actifText = nil;
    [textField resignFirstResponder];
    return true;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    [textField resignFirstResponder];
//
//    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
//    {
//        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
//        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//
//        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
//    }
    
    return YES;
}

-(void)changePassword:(UIButton*)button{
    [self performSegueWithIdentifier:@"segueProfileToChangePwd" sender:self];
}

//MARK: scrollview delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [UIView animateWithDuration:.25f animations:^{
//        scrollView.contentOffset = scrollView.contentOffset;
//    }];
//
//}
- (IBAction)profilePicEdit:(id)sender {
    [self performSegueWithIdentifier:@"segueProfileToUpload" sender:self];
    
}
- (IBAction)followersAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueProfileVCToFollowerFollowing" sender:@"followers"];
        
    });
}
- (IBAction)followingAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueProfileVCToFollowerFollowing" sender:@"following"];
        
    });
}
- (IBAction)logoutAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
    NSLog(@"isLogin=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]);
    NSLog(@"token=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]);

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        LandingViewController *landingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"landingViewController"]; //or the homeController
                        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingViewController];
                        self.view.window.rootViewController = navController;
                    }
                    completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"SegueProfileToCommonVPlay"]) {
        CommonVideoPlayerViewController *videoVC  = segue.destinationViewController;
        videoVC.getVideoURL = videoURL;
        videoVC.songTitle = songTitle;
        
    }else if ([segue.identifier isEqualToString:@"segueSignUpToProfileUpload"]) {
        //        UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
        //        RapMusicViewController *rapVC = (RapMusicViewController *)dest.topViewController;
        
        ProfileUploadViewController *rapVC = segue.destinationViewController;
        rapVC.isSignUp = false;
    }else if ([segue.identifier isEqualToString:@"SegueProfileVCToFollowerFollowing"]) {
        
        FollowersFollowingViewController *nextVC  = segue.destinationViewController;
        nextVC.selectionType = sender;
        nextVC.userID = [Singletons sharedManager].userDetail.id;
    }else if ([segue.identifier isEqualToString:@"SegueProfileToCommonVPlay"]) {
        CommonVideoPlayerViewController *videoVC  = segue.destinationViewController;
        videoVC.getVideoURL = videoURL;
        videoVC.songTitle = songTitle;
        
    }else if ([segue.identifier isEqualToString:@"SegueProfileVCToUserInvite"]) {
        UserInviteViewController *inviteVC  = segue.destinationViewController;
        inviteVC.music_id = music_id;
        inviteVC.music_solo_id = music_solo_id;
        
    }
}


@end
