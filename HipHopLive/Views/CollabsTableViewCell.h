//
//  CollabsTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 23/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollabsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle_Lbl;
@property (weak, nonatomic) IBOutlet UIButton *seeAll_Btn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *noData_Lbl;

@end

NS_ASSUME_NONNULL_END
