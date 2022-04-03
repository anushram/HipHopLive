//
//  ViewController+Common.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Common)
- (void) showNoHandlerAlertWithTitle:(NSString *)title andMessage:     (NSString*)message;
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message  buttonTitles:(NSArray<NSString *>*)titles andHandler:(void (^)(UIAlertAction * action))handler;
- (void)setNavigationBar:(NSString*)title;
- (BOOL)internetCheck;
- (BOOL)validateEmailWithString:(NSString*)checkString;
-(NSString*)startTime:(NSDate*)startDate endDate:(NSDate*)endDate;
@end

NS_ASSUME_NONNULL_END
