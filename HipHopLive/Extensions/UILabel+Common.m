//
//  UILabel+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 15/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)
+(void)setCornerRadius:(UILabel*)label radius:(int)radius{
    label.layer.cornerRadius = radius;//half of the width
    label.clipsToBounds = YES;
}
@end
