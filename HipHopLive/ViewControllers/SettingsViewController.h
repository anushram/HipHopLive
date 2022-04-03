//
//  SettingsViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 13/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *tableDic;

@end

NS_ASSUME_NONNULL_END
