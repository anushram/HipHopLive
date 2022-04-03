//
//  BeatLabViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 10/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeatLabTableViewCell.h"

//Lyrics view
#import "VTXLyric.h"
#import "VTXLyricParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeatLabViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,NSURLSessionDelegate,UISearchBarDelegate>
{
    NSMutableArray *beatLabArr;
    NSMutableArray *selectedCategoryIDArr;

}
@property(strong,nonatomic)NSArray *buttonTitleArry;
@property(strong,nonatomic)UIButton *titleButtonSelected;
@property(strong,nonatomic)UIScrollView *scrollView;

//UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *buttonTitleView;
@property (weak, nonatomic) IBOutlet UITableView *beatLabTableView;
@property (weak, nonatomic) IBOutlet UILabel *noData_Lbl;

@property (strong,nonatomic) NSMutableArray<NSIndexPath *> *beatLabLikeIndex_Arr;

//
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressBar;

//Lycrics view
@property (strong, nonatomic) VTXLyric *sendLyric;

@end

NS_ASSUME_NONNULL_END
