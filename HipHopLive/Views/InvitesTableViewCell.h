//
//  InvitesTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 05/02/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvitesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *profileBack_View;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic_Img;
@property (weak, nonatomic) IBOutlet UILabel *name_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_Lbl;
@property (weak, nonatomic) IBOutlet UIButton *battle_Btn;
@property (weak, nonatomic) IBOutlet UIView *songBack_View;
@property (weak, nonatomic) IBOutlet UIImageView *song_Img;
@property (weak, nonatomic) IBOutlet UILabel *songStatus_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *songName_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *size_Lbl;

@end

NS_ASSUME_NONNULL_END
