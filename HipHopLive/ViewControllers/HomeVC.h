//
//  HomeVC.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 11/02/22.
//  Copyright © 2022 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (strong,nonatomic)IBOutlet UICollectionView *videoCollectionView;
@property (strong,nonatomic) NSMutableArray   *musicallFeed_Arr;
@property(nonatomic, strong) AVPlayerViewController *playerViewController;
@end

NS_ASSUME_NONNULL_END
