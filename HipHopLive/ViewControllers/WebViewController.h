//
//  WebViewController.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 03/04/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic)NSString *selectionType;

@end

NS_ASSUME_NONNULL_END
