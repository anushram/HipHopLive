//
//  FollowersTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profile_pic;
@property (weak, nonatomic) IBOutlet UILabel *name_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *user_name_Lbl;
@property (weak, nonatomic) IBOutlet UIButton *follow_Btn;

@end

NS_ASSUME_NONNULL_END
