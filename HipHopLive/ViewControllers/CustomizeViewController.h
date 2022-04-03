//
//  CustomizeViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 18/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray<CategoriesDetail>   *allCatogoryList_Arr;
@property (strong,nonatomic) NSArray<CategoriesDetail>  *selected_CatogoryList_Arr;
@property (strong,nonatomic) NSArray  *headerTitle_Arr;
@property (strong,nonatomic) NSMutableArray  *selectedCatID_Arr;

@end

NS_ASSUME_NONNULL_END
