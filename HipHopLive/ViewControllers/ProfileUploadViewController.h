//
//  ProfileUploadViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 16/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileUploadViewController : UIViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (nonatomic) BOOL isSignUp;
@end

NS_ASSUME_NONNULL_END
