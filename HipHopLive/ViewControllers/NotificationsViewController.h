//
//  NotificationsViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate>
@property(strong,nonatomic)NSArray *buttonTitleArry;
@property(strong,nonatomic)UIButton *titleButtonSelected;
@property(nonatomic,strong) NSMutableArray<InvitesSoloDetail> *invitesList_arr;
@property(nonatomic,strong) NSMutableArray<MusicDuetFeed> *activityList_arr;


@property (nonatomic) InvitesSoloDetail *invitesselectedValue;


//UI
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *buttonTitleView;
@property (weak, nonatomic) IBOutlet UIButton *startRap_Btn;
@property (weak, nonatomic) IBOutlet UITableView *invites_TableView;
@property (weak, nonatomic) IBOutlet UIView *activity_View;
@property (weak, nonatomic) IBOutlet UILabel *noData_Lbl;

@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
//Lycrics view
@property (strong, nonatomic) VTXLyric *lyric;

@end

NS_ASSUME_NONNULL_END
