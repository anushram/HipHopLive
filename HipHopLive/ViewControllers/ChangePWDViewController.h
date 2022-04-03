//
//  ChangePWDViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 06/12/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangePWDViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwd_Txt;
@property (strong, nonatomic) IBOutlet UITextField *changePassword;


@end

NS_ASSUME_NONNULL_END
