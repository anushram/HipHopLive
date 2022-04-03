//
//  UIButton+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 30/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)
+(void)setCornerRadius:(UIButton*)button radius:(int)radius{
    button.layer.cornerRadius = radius;//half of the width
    button.clipsToBounds = YES;
}
+(void)setBottomLineForButton:(UIButton*)button setColor:(CGColorRef)color borderWidth:(CGFloat)Width{
    CALayer *border = [CALayer layer];
    //    CGFloat borderWidth = 2;
    //    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.borderColor = color;
    border.frame = CGRectMake(0, button.frame.size.height - Width, button.frame.size.width, button.frame.size.height);
    border.borderWidth = Width;
    [button.layer addSublayer:border];
    button.layer.masksToBounds = YES;
}
@end
