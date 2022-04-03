//
//  CollabsCollectionViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 23/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollabsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *grayBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *songsPlay_Btn;
@property (weak, nonatomic) IBOutlet UILabel *songTitle_Lbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *userName_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *createDate_Lbl;
@property (weak, nonatomic) IBOutlet UIView *borderView;

@property (weak, nonatomic) IBOutlet UILabel *noView;
@property (weak, nonatomic) IBOutlet UIButton *view_Btn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLbl;
@property (weak, nonatomic) IBOutlet UIView *likeBackView;

@end

NS_ASSUME_NONNULL_END
