//
//  WebViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 03/04/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_selectionType isEqualToString:@"TermsandConditions"]) {
        [self setNavigationBar:@"Terms and Conditions"];
        NSString *urlAddress = @"http://hiphoplive.sitecare.org/terms";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        _webview.delegate=self;
        [_webview loadRequest:requestObj];

    }else if ([_selectionType isEqualToString:@"PrivacyPolicy"]){
        [self setNavigationBar:@"Privacy Policy"];

        NSString *urlAddress = @"http://hiphoplive.sitecare.org/privacy";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        _webview.delegate=self;
        [_webview loadRequest:requestObj];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return true;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
