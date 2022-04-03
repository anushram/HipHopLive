//
//  UIImageview+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 16/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "UIImageview+Common.h"

@implementation UIImageView (Common)
+(void)setCornerRadius:(UIImageView*)imageView radius:(int)radius{
    imageView.layer.cornerRadius = radius;//half of the width
    imageView.clipsToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
