//
//  FollowersFollowingViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface FollowersFollowingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSString *selectionType;
@property(nonatomic)NSInteger userID;
@property(nonatomic)NSInteger send_userID;
@property (strong,nonatomic) NSMutableArray<FollowDetails>  *arrayList;
@property (weak, nonatomic) IBOutlet UILabel *noData_Lbl;

//user view list
@property (nonatomic) MusicSoloFeed *soloselectedValue;
@property (nonatomic) MusicDuetFeed *duetselectedValue;
@property (nonatomic) NSString *valueType;

@end

NS_ASSUME_NONNULL_END
