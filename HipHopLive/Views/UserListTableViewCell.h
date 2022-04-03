//
//  UserListTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 04/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profile_Pic;
@property (weak, nonatomic) IBOutlet UIButton *check_Box;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

NS_ASSUME_NONNULL_END
