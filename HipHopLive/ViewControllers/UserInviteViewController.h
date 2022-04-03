//
//  UserInviteViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 01/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInviteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray<UserDetails> *userList_Arr;
@property (strong,nonatomic) NSMutableArray  *selectedUserID_Arr;
@property (weak, nonatomic) IBOutlet UIButton *invite_Btn;

//receive data
@property (nonatomic,strong) NSString *music_solo_id;
@property (nonatomic,strong) NSString *music_id;


@end

NS_ASSUME_NONNULL_END
