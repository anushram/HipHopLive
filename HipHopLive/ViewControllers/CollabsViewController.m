//
//  CollabsViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "CollabsViewController.h"

@interface CollabsViewController ()
{
    //single download
    MBProgressHUD *hud;

    //multiple download
    NSURLSession *collabssessionFirst;
    NSURLSession *collabssessionSecond;
    //common
    NSURLSessionDownloadTask *downloadTask;
    NSURLSessionConfiguration *configFirst;
    NSURLSessionConfiguration *configSecond;
    
    BOOL isSoloSelection;
    MusicSoloFeed *solovalueview;
    MusicDuetFeed *duetvalueview;
//    MusicDuetFeed *soloselectedValue;
    
}
@end

@implementation CollabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"

    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableArrayList = [[NSArray alloc]initWithObjects:@"Solo List",@"Duet List",nil];
    _soloLikeIndex_Arr = [[NSMutableArray alloc]init];
    _duetLikeIndex_Arr = [[NSMutableArray alloc]init];

//    [self.tableView reloadData];

}
- (void)viewWillAppear:(BOOL)animated{
    [self getCollabsList];
}

-(void)getCollabsList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicfeed",Base_URL]];

        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->_searchBar.text forKey:@"search"];
        
        //        NSString *post = nil;
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
                        NSLog(@"musicfeed response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            MusicFeedResponse *object = [[MusicFeedResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"musicfeed Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    self->_musicDuetFeed_Arr = [object.musicDuetFeed mutableCopy];
                                    self->_musicSoloFeed_Arr = [object.musicSoloFeed mutableCopy];
                                    [self->_tableView reloadData];
                                    
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

- (IBAction)settingsBarAction:(id)sender {
    
    
}

//# MARK: uitableview data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.headerTitle_Arr.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"collabsCell";
    
    NSLog(@"section= %ld",(long)indexPath.section);
    CollabsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (indexPath.row == 0) {
        
        if (_musicSoloFeed_Arr.count == 0) {
            cell.noData_Lbl.hidden = NO;
        }else{
            cell.noData_Lbl.hidden = YES;
        }
        
        cell.categoryTitle_Lbl.text = [self.tableArrayList objectAtIndex:indexPath.row];
        cell.categoryTitle_Lbl.layer.cornerRadius = 8.0f;
        cell.categoryTitle_Lbl.clipsToBounds = YES;
        cell.seeAll_Btn.tag = indexPath.row;
        cell.collectionView.tag = indexPath.row;
        [cell.seeAll_Btn addTarget:self action:@selector(seeAllButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        [cell.collectionView reloadData];
        
        return cell;
    }else{
        if (_musicDuetFeed_Arr.count == 0) {
            cell.noData_Lbl.hidden = NO;
        }else{
            cell.noData_Lbl.hidden = YES;
        }
        
        cell.categoryTitle_Lbl.text = [self.tableArrayList objectAtIndex:indexPath.row];
        cell.categoryTitle_Lbl.layer.cornerRadius = 8.0f;
        cell.categoryTitle_Lbl.clipsToBounds = YES;
        cell.seeAll_Btn.tag = indexPath.row;
        cell.collectionView.tag = indexPath.row;
        [cell.seeAll_Btn addTarget:self action:@selector(seeAllButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        [cell.collectionView reloadData];

        
        return cell;
        
    }
    
}

//# MARK: uicollectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 0) {
        return self.musicSoloFeed_Arr.count;
    }else{
        return self.musicDuetFeed_Arr.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"collabsCollectionCell";
    NSLog(@"collection section= %ld",(long)indexPath.section);
    CollabsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    MusicSoloFeed *solovalue;
    MusicDuetFeed *duetvalue;

    if (collectionView.tag == 0) {
        solovalue = [self.musicSoloFeed_Arr objectAtIndex:indexPath.row];
        _soloCollectionView = collectionView;
        if ([_soloLikeIndex_Arr containsObject:indexPath]){
            cell.likeBackView.hidden = false;
        }else{
            cell.likeBackView.hidden = true;
        }
        
        cell.songTitle_Lbl.text = solovalue.title;
        cell.userName_Lbl.text = solovalue.username;
        
        //date compare
        NSString *dateStr = solovalue.created_at;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        NSDate *currDate = [NSDate date];
        NSLog(@"result=%@",[self startTime:date endDate:currDate]);
        cell.createDate_Lbl.text = [self startTime:date endDate:currDate];
        
        [UIButton setCornerRadius:cell.songsPlay_Btn radius:11.0f];
        [UIView setCornerRadius:cell.grayBackgroundView radius:11.0f];
        cell.imageView.layer.cornerRadius = 11.0f;
        cell.imageView.clipsToBounds = YES;
        
        // border radius
        [cell.borderView.layer setCornerRadius:10.0f];
        cell.borderView.clipsToBounds = YES;
        
        // border
        [cell.borderView.layer setBorderColor:[UIColor colorWithRed:218.00/255.00 green:66.00/255.00 blue:156.00/255.00 alpha:1.0].CGColor];
        [cell.borderView.layer setBorderWidth:0.5f];
        
        // drop shadow
        [cell.borderView.layer setShadowColor:[UIColor redColor].CGColor];
        [cell.borderView.layer setShadowOpacity:1.8];
        [cell.borderView.layer setShadowRadius:10.0];
        [cell.borderView.layer setShadowOffset:CGSizeMake(10.0, 10.0)];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:solovalue.musicimage_filename] placeholderImage:[UIImage imageNamed:@"musicPlaceholder"]];
        
        //like added
        [UIView setCornerRadius:cell.likeBackView radius:cell.likeBackView.frame.size.height/2];
        cell.noView.text = [NSString stringWithFormat:@"▶️ %ld",(long)solovalue.soloviewcount];
        
        if ([solovalue.musicSololikestatus  isEqual: @""]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-normal"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)solovalue.sololikecount];
        }else if ([solovalue.musicSololikestatus  isEqual: @"like"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)solovalue.sololikecount];
        }else if ([solovalue.musicSololikestatus  isEqual: @"dislike"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"unlike-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)solovalue.solodislikecount];
        }else if ([solovalue.musicSololikestatus  isEqual: @"smile"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"smile-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)solovalue.solosmilecount];
        }else if ([solovalue.musicSololikestatus  isEqual: @"love"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart-icon-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)solovalue.sololovecount];
        }
        
    }else{
        
        duetvalue = [self.musicDuetFeed_Arr objectAtIndex:indexPath.row];
        _duetCollectionView = collectionView;
        if ([_duetLikeIndex_Arr containsObject:indexPath]){
            cell.likeBackView.hidden = false;
        }else{
            cell.likeBackView.hidden = true;
        }
        
        cell.songTitle_Lbl.text = duetvalue.title;
        cell.userName_Lbl.text = duetvalue.username;
        
        //date compare
        NSString *dateStr = duetvalue.created_at;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        NSDate *currDate = [NSDate date];
        NSLog(@"result=%@",[self startTime:date endDate:currDate]);
        cell.createDate_Lbl.text = [self startTime:date endDate:currDate];
        
        [UIButton setCornerRadius:cell.songsPlay_Btn radius:11.0f];
        [UIView setCornerRadius:cell.grayBackgroundView radius:11.0f];
        cell.imageView.layer.cornerRadius = 11.0f;
        cell.imageView.clipsToBounds = YES;
        
        // border radius
        [cell.borderView.layer setCornerRadius:10.0f];
        cell.borderView.clipsToBounds = YES;
        
        // border
        [cell.borderView.layer setBorderColor:[UIColor colorWithRed:218.00/255.00 green:66.00/255.00 blue:156.00/255.00 alpha:1.0].CGColor];
        [cell.borderView.layer setBorderWidth:0.5f];
        
        // drop shadow
        [cell.borderView.layer setShadowColor:[UIColor redColor].CGColor];
        [cell.borderView.layer setShadowOpacity:1.8];
        [cell.borderView.layer setShadowRadius:10.0];
        [cell.borderView.layer setShadowOffset:CGSizeMake(10.0, 10.0)];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:duetvalue.musicimage_filename] placeholderImage:[UIImage imageNamed:@"musicPlaceholder"]];
        
        //like added
        [UIView setCornerRadius:cell.likeBackView radius:cell.likeBackView.frame.size.height/2];
        cell.noView.text = [NSString stringWithFormat:@"▶️ %ld",(long)duetvalue.duetviewcount];
        
        if ([duetvalue.musicDuetlikestatus  isEqual: @""]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-normal"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)duetvalue.duetlikecount];
        }else if ([duetvalue.musicDuetlikestatus  isEqual: @"like"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)duetvalue.duetlikecount];
        }else if ([duetvalue.musicDuetlikestatus  isEqual: @"dislike"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"unlike-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)duetvalue.duetdislikecount];
        }else if ([duetvalue.musicDuetlikestatus  isEqual: @"smile"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"smile-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)duetvalue.duetsmilecount];
        }else if ([duetvalue.musicDuetlikestatus  isEqual: @"love"]){
            [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"heart-icon-active"] forState:UIControlStateNormal];
            cell.likeCountLbl.text = [NSString stringWithFormat:@"%ld",(long)duetvalue.duetlovecount];
        }
        
    }
    
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.view_Btn.tag = indexPath.row;
    [cell.view_Btn addTarget:self action:@selector(noViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.tabBarController.tabBar.userInteractionEnabled = false;

    if (collectionView.tag == 0) {
        isSoloSelection = true;
        _soloselectedValue = [_musicSoloFeed_Arr objectAtIndex:indexPath.row];
        [self collabsSelected:[_musicSoloFeed_Arr objectAtIndex:indexPath.row]];
    }else{
        isSoloSelection = false;
        _duetselectedValue = [_musicDuetFeed_Arr objectAtIndex:indexPath.row];
        [self collabsSelected:[_musicDuetFeed_Arr objectAtIndex:indexPath.row]];
    }

}

-(void)likeButtonPressed:(UIButton*)button{
    CGPoint center= button.center;
    UIView *collview = (UIView *)button.superview;
    CollabsCollectionViewCell *collcell = (CollabsCollectionViewCell*)collview.superview;
    UICollectionView *coll = (UICollectionView*)collcell.superview;
    
    if (coll == _soloCollectionView) {
        CGPoint rootViewPoint = [button.superview convertPoint:center toView:_soloCollectionView];
        NSIndexPath *indexPath = [_soloCollectionView indexPathForItemAtPoint:rootViewPoint];
        NSLog(@"%@",indexPath);
        
        if ([_soloLikeIndex_Arr containsObject:indexPath]) {
            [_soloLikeIndex_Arr removeObject:indexPath];

        }else{
            [_soloLikeIndex_Arr addObject:indexPath];
        }
        
        [UIView setAnimationsEnabled:NO];
        [_soloCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [UIView setAnimationsEnabled:false];
    }else if(coll == _duetCollectionView){
        CGPoint rootViewPoint = [button.superview convertPoint:center toView:_duetCollectionView];
        NSIndexPath *indexPath = [_duetCollectionView indexPathForItemAtPoint:rootViewPoint];
        NSLog(@"%@",indexPath);
        
        if ([_duetLikeIndex_Arr containsObject:indexPath]) {
            [_duetLikeIndex_Arr removeObject:indexPath];
            
        }else{
            [_duetLikeIndex_Arr addObject:indexPath];
        }
        
        [UIView setAnimationsEnabled:NO];
        [_duetCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [UIView setAnimationsEnabled:false];
    }
}

-(void)noViewButtonPressed:(UIButton*)button{
    
    CGPoint center= button.center;
    UIView *collview = (UIView *)button.superview;
    CollabsCollectionViewCell *collcell = (CollabsCollectionViewCell*)collview.superview;
    UICollectionView *coll = (UICollectionView*)collcell.superview;

    if (coll == _soloCollectionView) {
        solovalueview = [self.musicSoloFeed_Arr objectAtIndex:button.tag];
        [self performSegueWithIdentifier:@"SegueCollobsToFollowerFollowing" sender:@"solo"];


    }else if(coll == _duetCollectionView){
        duetvalueview = [self.musicDuetFeed_Arr objectAtIndex:button.tag];
        [self performSegueWithIdentifier:@"SegueCollobsToFollowerFollowing" sender:@"duet"];

    }
    
}

- (IBAction)likeActions:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    UIView *view = button.superview;
    UIView *contentview = (UIView*)view.superview;
    CollabsCollectionViewCell *collcell = (CollabsCollectionViewCell*)contentview.superview;
    UICollectionView *coll = (UICollectionView*)collcell.superview;
    
    NSString *like = @"";
    NSIndexPath *indexPath;

    UICollectionView *reloadColl;
    if (coll.tag == 0) {
        CGPoint center= view.center;
        CGPoint rootViewPoint = [view.superview convertPoint:center toView:_soloCollectionView];
        indexPath = [_soloCollectionView indexPathForItemAtPoint:rootViewPoint];
        NSLog(@"%@",indexPath);
        MusicSoloFeed *value = [_musicSoloFeed_Arr objectAtIndex:indexPath.row];
        if (button.tag == 0){
            like = @"like";
        }else if (button.tag == 1){
            like = @"dislike";
        }else if (button.tag == 2){
            like = @"smile";
        }else if (button.tag == 3){
            like = @"love";
        }
        
        if ([_soloLikeIndex_Arr containsObject:indexPath]) {
            [_soloLikeIndex_Arr removeObject:indexPath];
        }
        reloadColl = _soloCollectionView;
        [self likeApiCall:value.id musicid:value.music_id Category:value.category_id musicLike:like collectionView:reloadColl index:indexPath];

        
    }else{
        CGPoint center= view.center;
        CGPoint rootViewPoint = [view.superview convertPoint:center toView:_duetCollectionView];
        indexPath = [_duetCollectionView indexPathForItemAtPoint:rootViewPoint];
        NSLog(@"%@",indexPath);
        MusicDuetFeed *value = [_musicDuetFeed_Arr objectAtIndex:indexPath.row];
        if (button.tag == 0){
            like = @"like";
        }else if (button.tag == 1){
            like = @"dislike";
        }else if (button.tag == 2){
            like = @"smile";
        }else if (button.tag == 3){
            like = @"love";
        }
        
        if ([_duetLikeIndex_Arr containsObject:indexPath]) {
            [_duetLikeIndex_Arr removeObject:indexPath];
        }
        reloadColl = _duetCollectionView;

        [self likeApiCall:value.id musicid:value.music_id Category:value.category_id musicLike:like collectionView:reloadColl index:indexPath];

    }
    
}

-(void)likeApiCall:(int)_id musicid:(NSInteger)music_id Category:(NSInteger)category_id musicLike:(NSString *)like collectionView:(UICollectionView*)collectionview index:(NSIndexPath*)indexPath{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //http://hiphoplive.sitecare.org/api/v1/musicsololike
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicsololike",Base_URL]];
        //old
        //        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&deviceType=%@&deviceToken=%@",self->_email.text,self->_password.text,deviceType,@""];
        //        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        NSURL *url;
        if (collectionview == self->_soloCollectionView) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicsololike",Base_URL]];
            
            [paramDic setObject:[NSNumber numberWithInteger:music_id] forKey:@"music_id"];
            [paramDic setObject:[NSNumber numberWithInt:_id] forKey:@"music_solo_id"];
            [paramDic setObject:[NSNumber numberWithInteger:category_id] forKey:@"category_id"];
            [paramDic setObject:like forKey:@"like"];
            [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        }else{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/musicduetlike",Base_URL]];
            
            [paramDic setObject:[NSNumber numberWithInteger:music_id] forKey:@"music_id"];
            [paramDic setObject:[NSNumber numberWithInt:_id] forKey:@"music_duet_id"];
            [paramDic setObject:[NSNumber numberWithInteger:category_id] forKey:@"category_id"];
            [paramDic setObject:like forKey:@"like"];
            [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        }

        
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
                        NSLog(@"musicsololike response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            CollabsLikeResponse *object = [[CollabsLikeResponse alloc]initWithData:data error:&jsonModelError];

                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"musicsololike Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                if (collectionview == self->_soloCollectionView){
                                    [self->_musicSoloFeed_Arr replaceObjectAtIndex:indexPath.row withObject:object.MusicSoloLike];
                                    
                                }else{
                                    [self->_musicDuetFeed_Arr replaceObjectAtIndex:indexPath.row withObject:object.MusicDuetLike];
                                }

                                [UIView setAnimationsEnabled:NO];
                                [collectionview reloadItemsAtIndexPaths:@[indexPath]];
                                [UIView setAnimationsEnabled:false];
                            }
                            
//                            [collectionview reloadData];
                            
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


//-(void)collabsSelected:(MusicDuetFeed*)value{
//    if (!isSoloSelection) {
//        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//        _songTitle = _duetselectedValue.title;
////        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:_duetselectedValue.record_filename]];
////        [downloadTask resume];
//        downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:_duetselectedValue.record_filename]];
//        [downloadTask resume];
//
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.label.text = @"Loading";
////        self.tabBarController.tabBar.userInteractionEnabled = false;
//    }else{
//        //multiple download
//        // Session
//        _songTitle = _soloselectedValue.title;
//        configFirst = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.first"];
//        collabssessionFirst = [NSURLSession sessionWithConfiguration:configFirst delegate:self delegateQueue:nil];
//
//        configSecond = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.test.second"];
//        collabssessionSecond = [NSURLSession sessionWithConfiguration:configSecond delegate:self delegateQueue:nil];
//
//        // Start First Download
//        NSURLRequest *requestFirst = [NSURLRequest requestWithURL:[NSURL URLWithString:_soloselectedValue.record_filename]];
////        NSURLSessionDownloadTask *downloadTaskFirst = [sessionFirst downloadTaskWithRequest:requestFirst];
////        [downloadTaskFirst resume];
//        downloadTask = [collabssessionFirst downloadTaskWithRequest:requestFirst];
//        [downloadTask resume];
//
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.label.text = @"Loading";
////        self.tabBarController.tabBar.userInteractionEnabled = false;
//    }
//
//
//}
//



//callback used
-(void)collabsSelected:(MusicDuetFeed*)value{
    if (!isSoloSelection) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        _songTitle = _duetselectedValue.title;
        
        NSURL *URL = [NSURL URLWithString:_duetselectedValue.record_filename];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                                completionHandler:
                                                  ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                      
          if (error == nil){
              NSError *error1;
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
              
              [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error1];
              
              BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:[appDir stringByAppendingString:@"/demo.mp4"] error:&error1];
              
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
                  [self performSegueWithIdentifier:@"SegueCollabsToCommonVPlay" sender:nil];
                  
              });
          }else{
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              self.tabBarController.tabBar.userInteractionEnabled = true;
              [self showNoHandlerAlertWithTitle:@"download failed 👎" andMessage:@""];
          }
                                                      
                                                      
          }];
        
        [downloadTask resume];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        _songTitle = _soloselectedValue.title;

        //audio download
        NSURL *URL = [NSURL URLWithString:_soloselectedValue.record_filename];
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
              NSURL *URL = [NSURL URLWithString:self->_soloselectedValue.music_lyrics_filename];
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
                        self.tabBarController.tabBar.userInteractionEnabled = true;
                        [self performSegueWithIdentifier:@"SegueCollabsToSoloMusicVC" sender:nil];
                        
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
//        if (session == collabssessionSecond){
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
//-(void) URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//
//}
//
//-(void) URLSession:(NSURLSession* )session downloadTask:(NSURLSessionDownloadTask* )downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
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
//            [self performSegueWithIdentifier:@"SegueCollabsToCommonVPlay" sender:nil];
//
//        });
//    }else{
//
//
//        if (session == collabssessionFirst) {
//            // Start second Download
//            NSURLRequest *requestSecond = [NSURLRequest requestWithURL:[NSURL URLWithString:_soloselectedValue.music_lyrics_filename]];
////            NSURLSessionDownloadTask *downloadTaskSecond = [sessionSecond downloadTaskWithRequest:requestSecond];
////            [downloadTaskSecond resume];
//            downloadTask = [collabssessionSecond downloadTaskWithRequest:requestSecond];
//            [downloadTask resume];
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
//                [self performSegueWithIdentifier:@"SegueCollabsToSoloMusicVC" sender:nil];
//
//            });
//        }
//
//    }
//
//}
//===================



-(void)seeAllButtonPressed:(UIButton*)button{

    if (button.tag == 0) {
        
    }else{
        
    }
}

//# MARK: search delegate methods
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self getCollabsList];
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
    
    if ([segue.identifier isEqualToString:@"SegueCollabsToSoloMusicVC"]) {
        
        SoloMusicViewController *videoVC  = segue.destinationViewController;
        videoVC.videoURL = _videoURL;
        videoVC.songTitle = _songTitle;
        videoVC.lyric = _lyric;
        videoVC.soloselectedValue = _soloselectedValue;
        
    }else if ([segue.identifier isEqualToString:@"SegueCollabsToCommonVPlay"]){
        
        CommonVideoPlayerViewController *videoVC  = segue.destinationViewController;
        videoVC.getVideoURL = _videoURL;
        videoVC.songTitle = _songTitle;
        videoVC.isMoving = @"duet";
        videoVC.music_id = _duetselectedValue.music_id;
        videoVC.id = _duetselectedValue.id;
        
    }else if ([segue.identifier isEqualToString:@"SegueCollobsToFollowerFollowing"]){
        
        FollowersFollowingViewController *nextVC  = segue.destinationViewController;
        nextVC.selectionType = @"viewlist";
        nextVC.valueType = sender;
        if ([sender isEqualToString:@"solo"]) {
            nextVC.soloselectedValue = solovalueview;
        }else{
            nextVC.duetselectedValue = duetvalueview;
        }
        
    }
}


@end
