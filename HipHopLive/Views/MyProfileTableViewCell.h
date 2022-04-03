//
//  MyProfileTableViewCell.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *displayName_Txt;
@property (weak, nonatomic) IBOutlet UITextField *message_Txt;
@property (weak, nonatomic) IBOutlet UITextField *first_Txt;
@property (weak, nonatomic) IBOutlet UITextField *lastName_Txt;
@property (weak, nonatomic) IBOutlet UITextField *email_Txt;
@property (weak, nonatomic) IBOutlet UITextField *userName_Txt;
@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;
@property (weak, nonatomic) IBOutlet UITextField *country_Txt;
@property (weak, nonatomic) IBOutlet UITextField *state_Txt;
@property (weak, nonatomic) IBOutlet UITextField *city_Txt;
@property (weak, nonatomic) IBOutlet UIButton *changePwd_Btn;
@property (weak, nonatomic) IBOutlet UIButton *Edit_Btn;

//new
@property (weak, nonatomic) IBOutlet UILabel *title_Lbl;
@property (weak, nonatomic) IBOutlet UITextField *value_Txt;

@end

NS_ASSUME_NONNULL_END
