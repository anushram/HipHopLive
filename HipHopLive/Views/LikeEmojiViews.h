//
//  LikeEmojiViews.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 08/01/20.
//  Copyright © 2020 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LikeEmojiViews : UIView

@property (weak, nonatomic) IBOutlet UIView *likeBaseView;
+(LikeEmojiViews *)instanceFromNib;

@end

NS_ASSUME_NONNULL_END
