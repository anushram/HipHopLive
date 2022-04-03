//
//  FeedViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 08/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeEmojiViews.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController<UISearchBarDelegate,NSURLSessionDelegate>
{
    NSMutableArray *feedArr;
    NSString *selectedCategoryName;
    
}
@property(strong,nonatomic)NSArray *buttonTitleArry;
@property(strong,nonatomic)UIButton *titleButtonSelected;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)LikeEmojiViews *likeView;
//UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *buttonTitleView;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (weak, nonatomic) IBOutlet UILabel *noData_Lbl;

@property (strong,nonatomic) NSMutableArray<NSIndexPath *> *feedLikeIndex_Arr;

//
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressBar;

//Lycrics view
@property (strong, nonatomic) VTXLyric *sendLyric;
@end

NS_ASSUME_NONNULL_END
