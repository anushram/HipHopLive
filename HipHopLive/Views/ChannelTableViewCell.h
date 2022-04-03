//
//  ChannelTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 27/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *noView;
@property (weak, nonatomic) IBOutlet UILabel *noLike;
@property (weak, nonatomic) IBOutlet UILabel *noDisLike;
@property (weak, nonatomic) IBOutlet UILabel *noSmile;
@property (weak, nonatomic) IBOutlet UILabel *noLove;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *moreoption_Btn;
@property (weak, nonatomic) IBOutlet UIImageView *moreoption_Img;

@end

NS_ASSUME_NONNULL_END
