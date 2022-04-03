//
//  BeatLabTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 13/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeatLabTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgBackView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *byName;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLbl;
@property (weak, nonatomic) IBOutlet UIView *likeBackView;
@property (weak, nonatomic) IBOutlet UIButton *rapBtn;
@property (weak, nonatomic) IBOutlet UIButton *costBtn;

@end

NS_ASSUME_NONNULL_END
