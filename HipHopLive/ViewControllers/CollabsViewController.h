//
//  CollabsViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollabsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,NSURLSessionDelegate,UISearchBarDelegate>{
    
}
//UI
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSArray  *tableArrayList;
@property (strong,nonatomic) NSMutableArray<MusicDuetFeed>   *musicDuetFeed_Arr;
@property (strong,nonatomic) NSMutableArray<MusicSoloFeed>  *musicSoloFeed_Arr;

@property (strong,nonatomic) UICollectionView *soloCollectionView;
@property (strong,nonatomic) UICollectionView *duetCollectionView;

@property (strong,nonatomic) NSMutableArray<NSIndexPath *> *soloLikeIndex_Arr;
@property (strong,nonatomic) NSMutableArray<NSIndexPath *> *duetLikeIndex_Arr;

//move nextVC items
@property (nonatomic) MusicSoloFeed *soloselectedValue;
@property (nonatomic) MusicDuetFeed *duetselectedValue;
@property (strong,nonatomic) NSURL *videoURL;
@property (strong,nonatomic) NSString *songTitle;
//Lycrics view
@property (strong, nonatomic) VTXLyric *lyric;

@end

NS_ASSUME_NONNULL_END
