//
//  ActivityTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *noView;
@property (weak, nonatomic) IBOutlet UILabel *noLike;
@property (weak, nonatomic) IBOutlet UILabel *noDisLike;
@property (weak, nonatomic) IBOutlet UILabel *noSmile;
@property (weak, nonatomic) IBOutlet UILabel *noLove;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

NS_ASSUME_NONNULL_END
