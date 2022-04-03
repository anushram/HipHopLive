//
//  LikeEmojiViews.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 08/01/20.
//  Copyright © 2020 Securenext. All rights reserved.
//

#import "LikeEmojiViews.h"

@implementation LikeEmojiViews

@synthesize likeBaseView;


+(LikeEmojiViews *)instanceFromNib{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LikeEmojiViews" owner:self options:nil];
    LikeEmojiViews *view = [nib objectAtIndex:0];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
