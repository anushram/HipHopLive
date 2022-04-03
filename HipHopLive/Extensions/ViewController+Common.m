//
//  ViewController+Common.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 29/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ViewController+Common.h"


@implementation UIViewController (Common)

- (void) showNoHandlerAlertWithTitle:(NSString *)title andMessage:(NSString*)message {
    // Insert code here
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message  buttonTitles:(NSArray<NSString *>*)titles andHandler:(void (^)(UIAlertAction * action))handler {
    // Insert code here
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *btnTitle in titles){
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:btnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             handler(action);
                                                         }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void)setNavigationBar:(NSString*)title {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.title = title;


    //backImg
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backImg"];
//    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
//    [[UINavigationBar appearance] setBarTintColor:[[Singletons sharedManager] navBckcolor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor grayColor]];
//
//
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(0, 1);
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_btn.png"]];
    
}
-(void)goback{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(BOOL)internetCheck{
    
   
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//                return false;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                return true;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                return true;
//            case AFNetworkReachabilityStatusUnknown:
//            default:
//                return false;
//        }

    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return true;
}
//MARK: date comparition
-(NSString*)startTime:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger years;
    NSInteger months;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSInteger seconds;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate: startDate toDate: endDate options: 0];
    years = [components year];
    months = [components month];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    seconds = [components second];
    
    if(years>0)
    {
        if(years>1)
            durationString=[NSString stringWithFormat:@"%ld years",(long)years];
        else
            durationString=[NSString stringWithFormat:@"%ld year",(long)years];
        return durationString;
    }
    if(months>0)
    {
        if(months>1)
            durationString=[NSString stringWithFormat:@"%ld months",(long)months];
        else
            durationString=[NSString stringWithFormat:@"%ld month",(long)months];
        return durationString;
    }
    if(days>0)
    {
        if(days>1)
            durationString=[NSString stringWithFormat:@"%ld days",(long)days];
        else
            durationString=[NSString stringWithFormat:@"%ld day",(long)days];
        return durationString;
    }
    if(hour>0)
    {
        if(hour>1)
            durationString=[NSString stringWithFormat:@"%ld hours",(long)hour];
        else
            durationString=[NSString stringWithFormat:@"%ld hour",(long)hour];
        return durationString;
    }
    if(minutes>0)
    {
        if(minutes>1)
            durationString = [NSString stringWithFormat:@"%ld minutes",(long)minutes];
        else
            durationString = [NSString stringWithFormat:@"%ld minute",(long)minutes];
        
        return durationString;
    }
    
    if(seconds>0)
    {
        if(seconds>10)
            durationString = [NSString stringWithFormat:@"%ld seconds",(long)seconds];
        else
            durationString = [NSString stringWithFormat:@"just now"];
        
        return durationString;
    }
    return @"";
}
//MARK: email validation
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
