//
//  CommonVideoPlayerViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 27/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonVideoPlayerViewController : UIViewController
@property (nonatomic,strong) IBOutlet UIView *videoview;
@property (nonatomic) NSURL *getVideoURL;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *isMoving;
@property (nonatomic) int id;
@property (nonatomic) NSInteger music_id;
@property (strong,nonatomic) NSString *selectionType;


@end

NS_ASSUME_NONNULL_END
