//
//  UserProfileView.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 07/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicSoloFeed.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserProfileView : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate>
@property(strong,nonatomic)NSArray *buttonTitleArry;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIButton *titleButtonSelected;
@property(strong,nonatomic)UIView *titlebtnBottomView;
@property(nonatomic)NSInteger userID;

@property (strong,nonatomic) NSMutableArray<MusicDuetFeed>   *musicDuetFeed_Arr;
@property (strong,nonatomic) NSMutableArray<MusicSoloFeed>  *musicSoloFeed_Arr;
//move nextVC items
@property (nonatomic) MusicSoloFeed *soloselectedValue;
@property (nonatomic) MusicDuetFeed *duetselectedValue;

@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
//Lycrics view
@property (strong, nonatomic) VTXLyric *lyric;

//UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UIView *buttonTitleView;
@property (weak, nonatomic) IBOutlet UIButton *followers;
@property (weak, nonatomic) IBOutlet UIButton *following;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *follow_Btn;
@property (weak, nonatomic) IBOutlet UIButton *block_Btn;

@end

NS_ASSUME_NONNULL_END
