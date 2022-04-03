//
//  UserProfileView.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 07/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "UserProfileView.h"

@interface UserProfileView ()
{
    UserDetails *object;
    MBProgressHUD *hud;
    BOOL isSoloSelection;
    
    //multiple download
    NSURLSession *userprofilesessionFirst;
    NSURLSession *userprofilesessionSecond;

}
@end

@implementation UserProfileView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    
    [self setNavigationBar:@"User Profile View"];

    //    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [UIImageView setCornerRadius:_profileImage radius:_profileImage.frame.size.height/2];
    [_profileImage setImage:[UIImage imageNamed:@"profilePlaceholder"]];
    _profileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    //    _profileImage.layer.cornerRadius = _profileImage.frame.size.height/2;
    //    _profileImage.clipsToBounds = YES;
    _buttonTitleArry = [[NSArray alloc]initWithObjects:@"Solo List",@"Duet List", nil];
    [self createScrollMenu];
    
    [UIButton setCornerRadius:_follow_Btn radius:10];
    [UIButton setCornerRadius:_block_Btn radius:10];


}


- (void)viewWillAppear:(BOOL)animated{
//    [self getUserDetail];
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

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userdetails",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInteger:self->_userID] forKey:@"id"];
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
                        NSLog(@"userdetails response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            UserDetailResponse *object = [[UserDetailResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"userdetails Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                if ([object.follow_status isEqualToString:@"unfollow"]) {
                                    [self->_follow_Btn setTitle:@"Follow" forState:UIControlStateNormal];
                                }else{
                                    [self->_follow_Btn setTitle:@"UnFollow" forState:UIControlStateNormal];
                                }
                                
                                if ([object.block_status isEqualToString:@"unblock"]) {
                                    [self->_block_Btn setTitle:@"Block" forState:UIControlStateNormal];
                                }else{
                                    [self->_block_Btn setTitle:@"Unblock" forState:UIControlStateNormal];
                                }
                                
                                self->_displayName.text = object.userdetail.display_name?object.userdetail.display_name:object.userdetail.firstname;
                                
                                [self->_followers setTitle:[NSString stringWithFormat:@"%d Followers",object.userdetail.followers] forState:UIControlStateNormal];
                                [self->_following setTitle:[NSString stringWithFormat:@"%d Following",object.userdetail.following] forState:UIControlStateNormal];
                                
                                [self->_profileImage sd_setImageWithURL:[NSURL URLWithString:object.userdetail.imagename] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
                                
                                self->_musicSoloFeed_Arr = [object.sololist mutableCopy];
                                self->_musicDuetFeed_Arr = [object.duetlist mutableCopy];
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
    
    int x = 0;
    for (int i = 0; i < _buttonTitleArry.count; i++) {
        
        CGSize stringBoundingBox = [[_buttonTitleArry objectAtIndex:i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:20.0f]}];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, self.view.frame.size.width/2, 50)];
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
    _titleButtonSelected = button;
    [self ApiCall];
}
-(void)ApiCall{
//    if (_titleButtonSelected.tag == 0){
////        [self getUserDetail];
//        //        [self->_tableView reloadData];
//
//    }else if (_titleButtonSelected.tag == 1){
//
////        [self getChannelData];
//    }else{
//        [_tableView reloadData];
//    }
    
    [_tableView reloadData];
}



//MARK: tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_titleButtonSelected.tag == 0){
        //        return _tableValueArr.count;
        return _musicSoloFeed_Arr.count;
        
    }else if (_titleButtonSelected.tag == 1){
        return _musicDuetFeed_Arr.count;
    }
    return 0;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    static NSString *profileTableCellIdentifier = @"Cell";
    static NSString *ChannelCellCellIdentifier = @"ChannelCell";
    
    MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChannelCellCellIdentifier];
    if (_titleButtonSelected.tag == 0){
        ChannelTableViewCell *cell = (ChannelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChannelCellCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ChannelDetail *value = [_musicSoloFeed_Arr objectAtIndex:indexPath.row];
        
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(_titleButtonSelected.tag == 1){
        ChannelTableViewCell *cell = (ChannelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChannelCellCellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        MusicDuetFeed *value = [_musicDuetFeed_Arr objectAtIndex:indexPath.row];
        
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
        
        return cell;
        
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_titleButtonSelected.tag == 0){
        isSoloSelection = true;
        _soloselectedValue = [_musicSoloFeed_Arr objectAtIndex:indexPath.row];
    }else{
        isSoloSelection = false;
        _duetselectedValue = [_musicDuetFeed_Arr objectAtIndex:indexPath.row];
    }
    [self rowSelected];

}



-(void)rowSelected{
    if (!isSoloSelection) {
        
        _songTitle = _duetselectedValue.title;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *URL = [NSURL URLWithString:_duetselectedValue.record_filename];
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
                                                              self.tabBarController.tabBar.userInteractionEnabled = false;
                                                              [self performSegueWithIdentifier:@"SegueUserProfileViewToCommonVPlay" sender:nil];
                                                              
                                                          });
                                                      }else{
                                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                          self.tabBarController.tabBar.userInteractionEnabled = true;
                                                          [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                      }
                                                      
                                                  }];
        
        [downloadTask resume];
        
    }else{
        
        _songTitle = _soloselectedValue.title;

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //audio download
        NSURL *URL = [NSURL URLWithString:_soloselectedValue.record_filename];
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
                                                          //
                                                          self->_videoURL = [NSURL fileURLWithPath:str];
                                                          
                                                          //lrc download
                                                          NSURL *URL = [NSURL URLWithString:self->_soloselectedValue.music_lyrics_filename];
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
                                                                                                                [self performSegueWithIdentifier:@"SegueUserProfileViewToSoloMusic" sender:nil];
                                                                                                                
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
//    if (!isSoloSelection) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            NSLog(@"%f",value);
//        });
//    }else{
//        if (session == userprofilesessionSecond){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//                double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//                NSLog(@"%f",value);
//            });
//        }
//    }
//
//}
//
//-(void)URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//
//}
//
//-(void)URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//
//    if (!isSoloSelection) {
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
//        _videoURL = [NSURL fileURLWithPath:str];
//
//        //move next vc
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self->hud hideAnimated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = false;
//            [self performSegueWithIdentifier:@"SegueUserProfileViewToCommonVPlay" sender:nil];
//
//        });
//    }else{
//
//
//        if (session == userprofilesessionFirst) {
//            // Start second Download
//            NSURLRequest *requestSecond = [NSURLRequest requestWithURL:[NSURL URLWithString:_soloselectedValue.music_lyrics_filename]];
//            NSURLSessionDownloadTask *downloadTaskSecond = [userprofilesessionSecond downloadTaskWithRequest:requestSecond];
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
//                [self performSegueWithIdentifier:@"SegueUserProfileViewToSoloMusic" sender:nil];
//
//            });
//        }
//
//    }
//
//}



- (IBAction)follow_Action:(id)sender {
    
    if ([_follow_Btn.titleLabel.text isEqualToString:@"UnFollow"]) {
        [self followAndUnfollow:@"unfollow" userID:self->_userID];
    }else{
        [self followAndUnfollow:@"follow" userID:self->_userID];
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
                            //                            JSONModelError *jsonModelError = nil;
                            //                            UserDetailResponse *object = [[UserDetailResponse alloc]initWithData:data error:&jsonModelError];
                            //                            if (object == nil) {
                            //                                [self showNoHandlerAlertWithTitle:@"userdetails Parse Error" andMessage:[jsonModelError localizedDescription]];
                            //                            }else{
                            //
                            //                                if ([object.follow_status isEqualToString:@"unfollow"]) {
                            //                                    [self->_follow_Btn setTitle:@"Follow" forState:UIControlStateNormal];
                            //                                }else{
                            //                                    [self->_follow_Btn setTitle:@"UnFollow" forState:UIControlStateNormal];
                            //
                            //                                }
                            //
                            //                                self->_displayName.text = object.userdetail.display_name?object.userdetail.display_name:object.userdetail.firstname;
                            //
                            //                                [self->_followers setTitle:[NSString stringWithFormat:@"%d Followers",object.userdetail.followers] forState:UIControlStateNormal];
                            //                                [self->_following setTitle:[NSString stringWithFormat:@"%d Following",object.userdetail.following] forState:UIControlStateNormal];
                            //
                            //                                [self->_profileImage sd_setImageWithURL:[NSURL URLWithString:object.userdetail.imagename] placeholderImage:[UIImage imageNamed:@"profilePlaceholder"]];
                            //
                            //                                self->_musicSoloFeed_Arr = [object.sololist mutableCopy];
                            //                                self->_musicDuetFeed_Arr = [object.duetlist mutableCopy];
                            //                                //
                            //                                [self->_tableView reloadData];
                            
                            //                            }
                            
                            [self getUserDetail];
                            
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

- (IBAction)followers_Action:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueUserProfileToFollowerFollowing" sender:@"followers"];
        
    });
    
}

- (IBAction)following_Action:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueUserProfileToFollowerFollowing" sender:@"following"];
        
    });
}
- (IBAction)block_Action:(id)sender {
    
    if ([_block_Btn.titleLabel.text isEqualToString:@"Block"]) {
        [self bolckAndUnblock:@"block" userID:self->_userID];
    }else{
        [self bolckAndUnblock:@"unblock" userID:self->_userID];
    }
}
- (void)bolckAndUnblock:(NSString*)follow_status userID:(NSInteger)userid{
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
                            
                            [self getUserDetail];
                            
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

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
     if ([segue.identifier isEqualToString:@"SegueUserProfileViewToCommonVPlay"]) {
         CommonVideoPlayerViewController *videoVC  = segue.destinationViewController;
         videoVC.getVideoURL = _videoURL;
         videoVC.songTitle = _songTitle;
         videoVC.selectionType = @"prfileview";
     
     }else if ([segue.identifier isEqualToString:@"SegueUserProfileViewToSoloMusic"]) {
     //        UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
     //        RapMusicViewController *rapVC = (RapMusicViewController *)dest.topViewController;
     
         SoloMusicViewController *videoVC  = segue.destinationViewController;
         videoVC.videoURL = _videoURL;
         videoVC.songTitle = _songTitle;
         videoVC.lyric = _lyric;
         videoVC.soloselectedValue = _soloselectedValue;
         videoVC.selectionType = @"profileview";
     }else if ([segue.identifier isEqualToString:@"SegueUserProfileToFollowerFollowing"]) {
         
         FollowersFollowingViewController *nextVC  = segue.destinationViewController;
         nextVC.selectionType = sender;
         nextVC.userID = _userID;
     }
     
 }



@end
