//
//  CustomizeTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 18/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBox_Btn;
@property (weak, nonatomic) IBOutlet UILabel *catogary_Lbl;

@end

NS_ASSUME_NONNULL_END
