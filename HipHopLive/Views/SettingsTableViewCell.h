//
//  SettingsTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 28/03/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *switch_btn;

@end

NS_ASSUME_NONNULL_END
