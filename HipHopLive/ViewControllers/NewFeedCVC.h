//
//  NewFeedCVC.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/02/22.
//  Copyright © 2022 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewFeedCVC : UICollectionViewCell{
   // AVPlayerViewController *playerViewController;
    
}
@property(nonatomic, strong) AVPlayerViewController *playerViewController;
@property(nonatomic, assign) NSString *urlStr;
@property(nonatomic, assign) AVPlayer* playVideoRef;
-(void)setCollectionData: (BeatMusicDetail *)data;
-(void)stopVideo: (id)data;
-(void)resumeVideo: (id)data;
@end

NS_ASSUME_NONNULL_END
