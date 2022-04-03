//
//  SignUpViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryDetail.h"
#import "StateDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSMutableArray <StateDetail>*stateArr;
    NSMutableArray <CountryDetail> *countryArr;
}
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNo;

@property (weak, nonatomic) IBOutlet UITableView *stateTableView;
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *stateVisible_Btn;
@property (weak, nonatomic) IBOutlet UIButton *countryVisible_Btn;

@property (weak, nonatomic) IBOutlet UIButton *passwordVisible_Btn;

@end

NS_ASSUME_NONNULL_END
