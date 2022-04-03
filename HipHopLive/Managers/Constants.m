//
//  Constants.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//NSString *Base_URL = @"http://snsdev7:8109/api/v1";
//NSString *Base_URL = @"http://192.168.1.179:8109/api/v1";
NSString *Base_URL = @"http://hiphoplive.sitecare.org/api/v1";


NSString *Get = @"GET";
NSString *Post = @"POST";
NSString *deviceType = @"iPhone";


//commom color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@end
