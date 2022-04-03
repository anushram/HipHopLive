//
//  ProfileViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 08/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLSessionDelegate>
{
    NSMutableArray <StateDetail>*stateArr;
    NSMutableArray <CountryDetail> *countryArr;
}
@property(strong,nonatomic)NSArray *buttonTitleArry;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIButton *titleButtonSelected;
@property(strong,nonatomic)UIView *titlebtnBottomView;

@property(strong,nonatomic)NSArray *tableTitleArr;
@property(strong,nonatomic)NSMutableArray *tableValueArr;


//UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UIView *buttonTitleView;
@property (weak, nonatomic) IBOutlet UIButton *followers;
@property (weak, nonatomic) IBOutlet UIButton *following;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


//new scroll
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;

-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

@property (nonatomic, retain) IBOutlet UITextField *actifText;

@end

NS_ASSUME_NONNULL_END
