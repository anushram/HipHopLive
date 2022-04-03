//
//  UIColor+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)
+(void)setBottomLineForTextField:(UITextField*)textField setColor:(CGColorRef)color borderWidth:(CGFloat)Width{
    CALayer *border = [CALayer layer];
    //    CGFloat borderWidth = 2;
    //    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.borderColor = color;
    border.frame = CGRectMake(0, textField.frame.size.height - Width, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = Width;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}
@end
