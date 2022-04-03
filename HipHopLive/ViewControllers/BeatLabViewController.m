//
//  BeatLabViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "BeatLabViewController.h"

@interface BeatLabViewController ()
{
    NSURL *audioURL;
    MBProgressHUD *hud;
    
    //multiple download
    NSURLSession *beatsessionFirst;
    NSURLSession *beatsessionSecond;
    //common
    NSURLSessionDownloadTask *downloadTask;
    NSURLSessionConfiguration *configFirst;
    NSURLSessionConfiguration *configSecond;
    
    BeatMusicDetail *rapValue;
}
@end

@implementation BeatLabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
//    _buttonTitleArry = [[NSArray alloc]initWithObjects:@" Club ",@" Dirty South ",@" Old School ",@" East Coast ", nil];
//    [self createScrollMenu];
    beatLabArr = [[NSMutableArray alloc]init];
    _beatLabLikeIndex_Arr = [[NSMutableArray alloc]init];
    selectedCategoryIDArr=[[NSMutableArray alloc]init];

}
- (void)viewWillAppear:(BOOL)animated{
    [self getCategoryList];
}
- (void)createScrollMenu
{
    [_scrollView removeFromSuperview];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];

    int x = 25;
    for (int i = 0; i < _buttonTitleArry.count + 1; i++) {
        
        if (i == _buttonTitleArry.count){
            //create + button
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, 30, 30)];
            [button setTitle:@"+" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            button.tag = i;
            
            button.titleLabel.numberOfLines = 1;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.lineBreakMode = NSLineBreakByClipping;
            
            //set border
            button.layer.cornerRadius = button.frame.size.width / 2;
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [[UIColor colorWithRed:158/255.0 green:86/255.0 blue:198/255.0 alpha:1.0] CGColor];
            CALayer *sub = [CALayer new];
            sub.frame = CGRectInset(button.bounds, 4, 4);
            sub.backgroundColor = [UIColor clearColor].CGColor;
            [button.layer addSublayer:sub];
            
            [_scrollView addSubview:button];
            x += button.frame.size.width+15;
        }else{
            //        CGSize stringsize = [[_buttonTitleArry objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:14]];
            
            //create title button
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, 120, 30)];
            CategoriesDetail *value = [_buttonTitleArry objectAtIndex:i];
            [button setTitle:value.name_category forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            button.tag = i;
            
            button.titleLabel.numberOfLines = 1;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.lineBreakMode = NSLineBreakByClipping;
            
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
                [selectedCategoryIDArr removeAllObjects];
                [selectedCategoryIDArr addObject:[NSNumber numberWithInteger:value.id]];
                [self getBeatMusicList];
            }
            
            [_scrollView addSubview:button];
            x += button.frame.size.width+15;
        }
        

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
    
    if (_buttonTitleArry.count == button.tag) {
        //move next vc
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"segueBeatLabToCustomizeVC" sender:nil];
            
        });
    }else{
        CategoriesDetail *value = [_buttonTitleArry objectAtIndex:button.tag];
        [selectedCategoryIDArr removeAllObjects];
        [selectedCategoryIDArr addObject:[NSNumber numberWithInteger:value.id]];
        [self getBeatMusicList];
        
        [button setBackgroundColor:[UIColor colorWithRed:158/255.0 green:86/255.0 blue:198/255.0 alpha:1.0]];
        
        if (_titleButtonSelected != nil && _titleButtonSelected != button) {
            [_titleButtonSelected setBackgroundColor:[UIColor clearColor]];
        }
        _titleButtonSelected = button;
    }

}
-(void)getCategoryList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
    
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/customizecategory",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
//        [paramDic setObject:self->selectedCategoryIDArr forKey:@"category_id"];
        
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
                        NSLog(@"customizecategory response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){

                            JSONModelError *jsonModelError = nil;
//                            CategoriesResponse *object = [[CategoriesResponse alloc]initWithData:data error:&jsonModelError];
                            CustomizeCategoryResponse *object = [[CustomizeCategoryResponse alloc]initWithData:data error:&jsonModelError];

                            
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"customizecategory Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                if (object.selected_category.count == 0){
                                    self->_buttonTitleArry = [object.all_category mutableCopy];
                                }else{
                                    self->_buttonTitleArry = [object.selected_category mutableCopy];
                                }
                                
//                                self->_buttonTitleArry = [object.categories mutableCopy];
                                [self createScrollMenu];
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
-(void)getBeatMusicList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));

        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getmusic",Base_URL]];

        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->selectedCategoryIDArr forKey:@"category_id"];
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
                        //                            NSError *error;

                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"getmusic response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            BeatMusicResponse *object = [[BeatMusicResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"BeatMusicResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                            self->beatLabArr = [object.musiclist mutableCopy];
                            dispatch_async(dispatch_get_main_queue(), ^{

                                if (self->beatLabArr.count == 0){
                                    self->_noData_Lbl.hidden = false;
                                }else{
                                    self->_noData_Lbl.hidden = true;
                                }
                            [self->_beatLabTableView reloadData];
                                
                            });
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

//MARK: tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self->beatLabArr.count;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *beatTableCellIdentifier = @"beatTableCell";
    
    BeatLabTableViewCell *cell = (BeatLabTableViewCell *)[tableView dequeueReusableCellWithIdentifier:beatTableCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"beatTableCellIdentifier" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    BeatMusicDetail *value = [beatLabArr objectAtIndex:indexPath.row];
    cell.songName.text = value.title;
    cell.byName.text = [NSString stringWithFormat:@"by %@",value.music_singer];
    cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.likecount];
    [UIButton setCornerRadius:cell.rapBtn radius:cell.rapBtn.frame.size.height/2];
    [UIButton setCornerRadius:cell.costBtn radius:cell.costBtn.frame.size.height/2];
    [UIView setCornerRadius:cell.likeBackView radius:cell.likeBackView.frame.size.height/2];
    if ([_beatLabLikeIndex_Arr containsObject:indexPath]){
        cell.likeBackView.hidden = false;
    }else{
        cell.likeBackView.hidden = true;
    }
    
    if ([value.likestatus  isEqual: @""]){
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-normal"] forState:UIControlStateNormal];
        cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.likecount];
    }else if ([value.likestatus  isEqual: @"like"]){
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-active"] forState:UIControlStateNormal];
        cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.likecount];
    }else if ([value.likestatus  isEqual: @"dislike"]){
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"unlike-active"] forState:UIControlStateNormal];
        cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.dislikecount];
    }else if ([value.likestatus  isEqual: @"smile"]){
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"smile-active"] forState:UIControlStateNormal];
        cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.smilecount];
    }else if ([value.likestatus  isEqual: @"love"]){
        [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart-icon-active"] forState:UIControlStateNormal];
        cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)value.lovecount];
    }

    
    cell.likeBtn.tag = indexPath.row;
    cell.rapBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [cell.rapBtn addTarget:self action:@selector(rapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:value.music_profile] placeholderImage:[UIImage imageNamed:@"musicPlaceholder"]];
    
//    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
//    [trianglePath moveToPoint:CGPointMake(0, 10)];
//    [trianglePath addLineToPoint:CGPointMake(10, 10)];
//    [trianglePath addLineToPoint:CGPointMake(12, 0)];
//    [trianglePath addLineToPoint:CGPointMake(15, 10)];
//    [trianglePath addLineToPoint:CGPointMake(cell.likeBackView.frame.size.width, 10)];
////    [trianglePath addLineToPoint:CGPointMake(cell.likeBackView.frame.size.width, cell.likeBackView.frame.size.height)];
////    [trianglePath addLineToPoint:CGPointMake(0, cell.likeBackView.frame.size.height)];
////    [trianglePath addLineToPoint:CGPointMake(0, 10)];
//
//
//    [trianglePath closePath];
//
//    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
//    [triangleMaskLayer setPath:trianglePath.CGPath];
//
//    cell.likeBackView.layer.mask = triangleMaskLayer;
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)likeButtonPressed:(UIButton*)button{
    CGPoint center= button.center;
    CGPoint rootViewPoint = [button.superview convertPoint:center toView:_beatLabTableView];
    NSIndexPath *indexPath = [_beatLabTableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    //    BeatLabTableViewCell *cell = [_feedTableView cellForRowAtIndexPath:indexPath];
    if ([_beatLabLikeIndex_Arr containsObject:indexPath]){
        [_beatLabLikeIndex_Arr removeObject:indexPath];
    }else{
        [_beatLabLikeIndex_Arr addObject:indexPath];
    }
    [_beatLabTableView beginUpdates];
    [_beatLabTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_beatLabTableView endUpdates];
    
}
- (IBAction)likeActions:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    UIView *view = button.superview;
    CGPoint center= view.center;
    CGPoint rootViewPoint = [view.superview convertPoint:center toView:_beatLabTableView];
    NSIndexPath *indexPath = [_beatLabTableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    //    BeatLabTableViewCell *cell = [_feedTableView cellForRowAtIndexPath:indexPath];
    if ([_beatLabLikeIndex_Arr containsObject:indexPath]){
        [_beatLabLikeIndex_Arr removeObject:indexPath];
    }else{
        [_beatLabLikeIndex_Arr addObject:indexPath];
    }
    
    //    [_feedTableView beginUpdates];
    //    [_feedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //    [_feedTableView endUpdates];
    
    BeatMusicDetail *value = [beatLabArr objectAtIndex:indexPath.row];
    NSString *like = @"";
    if (button.tag == 0){
        like = @"like";
    }else if (button.tag == 1){
        like = @"dislike";
    }else if (button.tag == 2){
        like = @"smile";
    }else if (button.tag == 3){
        like = @"love";
    }
    
    [self likeApiCall:value.id Category:value.category_id musicLike:like index:indexPath];
}

-(void)likeApiCall:(int)music_id Category:(NSInteger)category_id musicLike:(NSString *)like index:(NSIndexPath*)indexPath{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musiclike",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&deviceType=%@&deviceToken=%@",self->_email.text,self->_password.text,deviceType,@""];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[NSNumber numberWithInt:music_id] forKey:@"music_id"];
        [paramDic setObject:[NSNumber numberWithInteger:category_id] forKey:@"category_id"];
        [paramDic setObject:like forKey:@"like"];
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
                        NSLog(@"musiclike response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            BeatMusicLikeResponse *object = [[BeatMusicLikeResponse alloc]initWithData:data error:&jsonModelError];
                            
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"musiclike Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                [self->beatLabArr replaceObjectAtIndex:indexPath.row withObject:object.MusicLike];
                                
                                [self->_beatLabTableView beginUpdates];
                                [self->_beatLabTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                [self->_beatLabTableView endUpdates];
                            }
                            
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


-(void)rapButtonPressed:(UIButton*)button{
    
//    //multiple download
//    // Session
//    configFirst = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.first"];
//    beatsessionFirst = [NSURLSession sessionWithConfiguration:configFirst delegate:self delegateQueue:nil];
//
//    configSecond = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.second"];
//    beatsessionSecond = [NSURLSession sessionWithConfiguration:configSecond delegate:self delegateQueue:nil];
//
//    rapValue = [beatLabArr objectAtIndex:button.tag];
//    // Start First Download
//    NSURLRequest *requestFirst = [NSURLRequest requestWithURL:[NSURL URLWithString:rapValue.music_filename]];
////    NSURLSessionDownloadTask *downloadTaskFirst = [sessionFirst downloadTaskWithRequest:requestFirst];
////    [downloadTaskFirst resume];
//
//    downloadTask = [beatsessionFirst downloadTaskWithRequest:requestFirst];
//    [downloadTask resume];
//
//
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = @"Loading";
//    self.tabBarController.tabBar.userInteractionEnabled = false;
    
    //callback method used
    rapValue = [beatLabArr objectAtIndex:button.tag];
    [self callback:[NSURL URLWithString:rapValue.music_filename]];
}

//first use callback method Link : https://aruniphoneapplication.blogspot.com/2017/03/nsurlsession-cache-policy.html
-(void)callback:(NSURL *)URL{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tabBarController.tabBar.userInteractionEnabled = false;
    
    //audio download
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
          
          NSError *error1;
          //getting docs dir path
          NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
          NSString *docsDir = [tempArray objectAtIndex:0];
          
          //adding folder path
          NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp3/"];
          
          NSFileManager *fileManager = [NSFileManager defaultManager];
          
          if([fileManager fileExistsAtPath:appDir])
          {
              
              [[NSFileManager defaultManager] removeItemAtPath:appDir error:nil];
          }
          
          [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error1];
          
          BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp3"] error:&error1];
          
          NSLog(fileCopied ? @"Yes" : @"No");
          
          if (fileCopied) {
              NSURL *url = [NSURL URLWithString:appDir];
              url = [url URLByAppendingPathComponent:@"/demo.mp3"];
              NSLog(@"filecopied-url==%@",url);
          }else{
              
          }
          NSString *str = NSHomeDirectory();
          str = [str stringByAppendingString:@"/Documents/Songs_Mp3/demo.mp3"];
          NSLog(@"str-path==%@",str);
          //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
          //    NSLog(@"%@",audioPath);
          //
          self->audioURL = [NSURL fileURLWithPath:str];
          
          //lrc download
          NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self->rapValue.music_lyrics_filename]];
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
                                                            self->_sendLyric = [lyricParser lyricFromLocalPathFileName:str];
                                                            //move next vc
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                self.tabBarController.tabBar.userInteractionEnabled = false;
                                                                [self performSegueWithIdentifier:@"segueBeatLabToRapVC" sender:nil];
                                                                
                                                            });
                                                        }else{
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            self.tabBarController.tabBar.userInteractionEnabled = true;
                                                            [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
                                                            
                                                        }
                
                                                        
                                                        
            }];
          
          [downloadTask resume];
        }];
    
    [downloadTask resume];
}


- (IBAction)settingsBarAction:(id)sender {
    
    
}
////MARK: Nsurlsession delegate
//-(void)URLSession:(NSURLSession*)session task:(NSURLSessionTask* )task didCompleteWithError:(NSError *)error
//{
//    NSLog(@"%@",[error localizedDescription]);
////    [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
//}
//
//
//-(void) URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask* )downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    if (session == beatsessionSecond){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->hud.progress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            double value =(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//            NSLog(@"%f",value);
//        });
//    }
//
//}
//
//-(void) URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask* )downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//
//}
//
//-(void) URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask* )downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//
//    if (session == beatsessionFirst) {
//        // Start second Download
//        NSURLRequest *requestSecond = [NSURLRequest requestWithURL:[NSURL URLWithString:rapValue.music_lyrics_filename]];
////        NSURLSessionDownloadTask *downloadTaskSecond = [sessionSecond downloadTaskWithRequest:requestSecond];
////        [downloadTaskSecond resume];
//
//        downloadTask = [beatsessionSecond downloadTaskWithRequest:requestSecond];
//        [downloadTask resume];
//
//        NSError *error;
//        //getting docs dir path
//        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docsDir = [tempArray objectAtIndex:0];
//
//        //adding folder path
//        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Songs_Mp3/"];
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
//        BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp3"] error:&error];
//
//        NSLog(fileCopied ? @"Yes" : @"No");
//
//        if (fileCopied) {
//            NSURL *url = [NSURL URLWithString:appDir];
//            url = [url URLByAppendingPathComponent:@"/demo.mp3"];
//            NSLog(@"filecopied-url==%@",url);
//        }else{
//
//        }
//        NSString *str = NSHomeDirectory();
//        str = [str stringByAppendingString:@"/Documents/Songs_Mp3/demo.mp3"];
//        NSLog(@"str-path==%@",str);
//        //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//        //    NSLog(@"%@",audioPath);
//        //
//        audioURL = [NSURL fileURLWithPath:str];
//    }else{
////        NSFileHandle *logFile = nil;
////        logFile = [NSFileHandle fileHandleForWritingAtPath:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"lrc"]];
////
////        //make path to file
////        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"lrc"];
////
////        //write file
////        [[location path] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//        NSError *error;
//        //getting docs dir path
//        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docsDir = [tempArray objectAtIndex:0];
//
//        //adding folder path
//        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Lrc/"];
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
//        BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/lrcview.lrc"] error:&error];
//
//        NSLog(fileCopied ? @"Yes" : @"No");
//
//        if (fileCopied) {
//            NSURL *url = [NSURL URLWithString:appDir];
//            url = [url URLByAppendingPathComponent:@"/lrcview.lrc"];
//            NSLog(@"filecopied-lrcurl==%@",url);
//        }else{
//
//        }
//        NSString *str = NSHomeDirectory();
//        str = [str stringByAppendingString:@"/Documents/Lrc/lrcview.lrc"];
//        NSLog(@"lrc-path==%@",str);
//        //    NSString *audioPath = [[NSBundle mainBundle] pathForResource: [audioArray objectAtIndex:indexPath.row] ofType:@"mp3"];
//        //    NSLog(@"%@",audioPath);
//        //
//        VTXLyricParser *lyricParser = [[VTXBasicLyricParser alloc] init];
//        _sendLyric = [lyricParser lyricFromLocalPathFileName:str];
//        //move next vc
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self->hud hideAnimated:YES];
//            self.tabBarController.tabBar.userInteractionEnabled = false;
//            [self performSegueWithIdentifier:@"segueBeatLabToRapVC" sender:nil];
//
//        });
//    }
//
//}
//================

//# MARK: search delegate methods
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self getBeatMusicList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_searchBar resignFirstResponder];
    [downloadTask cancel];
    
    [NSURLSession sessionWithConfiguration:configFirst delegate:nil delegateQueue:nil];
    [NSURLSession sessionWithConfiguration:configSecond delegate:nil delegateQueue:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueBeatLabToRapVC"]) {
//        UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
//        RapMusicViewController *rapVC = (RapMusicViewController *)dest.topViewController;
        
        RapMusicViewController *rapVC = segue.destinationViewController;
        rapVC.musicURL = audioURL;
        rapVC.lyric = _sendLyric;
        rapVC.rapValue = rapValue;
    }
}


@end
