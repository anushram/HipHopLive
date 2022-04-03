//
//  UIView+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
+(void)setCornerRadius:(UIView*)view radius:(int)radius{
    view.layer.cornerRadius = radius;//half of the width
    view.clipsToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
