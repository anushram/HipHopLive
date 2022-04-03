//
//  UIButton+Common.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 30/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Common)
+(void)setCornerRadius:(UIButton*)button radius:(int)radius;
+(void)setBottomLineForButton:(UIButton*)button setColor:(CGColorRef)color borderWidth:(CGFloat)Width;

@end

NS_ASSUME_NONNULL_END
