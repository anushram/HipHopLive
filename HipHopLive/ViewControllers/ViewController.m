//
//  ViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 22/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self showNoHandlerAlertWithTitle:@"alert" andMessage:@""];
//    [self showAlertWithTitle:@"Wow" andMessage:@"" buttonTitles:@[@"Ok",@"Cancel"] andHandler:^(UIAlertAction * _Nonnull action) {
//
//        if ([action.title isEqualToString:@"Ok"]){
//
//        }else if ([action.title isEqualToString:@"Cancel"]){
//
//        }
//
//    }];
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//    }];
//
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//
//    NSString *URLString = @"http://example.com";
//    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
//
//    [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
//
//
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://carzillaapp.com/CarzillaApp_ver2.1/public/showroom/all-count-car/"]];
//
//    NSString *post =[[NSString alloc] initWithFormat:@"count=%ld",(long)30];
//
//    // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//
//    [ApiManager callAPI:url parameters:post method:@"GET" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
//
//        if (error != nil) {
//
//        }else{
//            if (statusCode == 200) {
//                // Check if any data returned.
//
//                if (data != nil) {
//
//                    // Convert the returned data into a dictionary.
//
//                    NSError *error;
//
//                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//                    NSLog(@"response = %@",str);
//
//                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                    NSLog(@"%@",returnedDict);
//                    LoginResponse *object = [[LoginResponse alloc]initWithString:str error:&error];
//
//
//
//            }else{
//
//            }
//        }
//    }
//
//    } withError:^(NSError * _Nonnull error) {
//        NSString *str = [error localizedDescription];
//    }];
    
}
-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

    [self getCountryList];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"] != nil){
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
        if (isLogin){
            [self getUserDetail];
        }else{
            [UIView transitionWithView:self.view
                              duration:0.5
                               options:UIViewAnimationOptionShowHideTransitionViews
                            animations:^{
                                LandingViewController *landingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"landingViewController"]; //or the homeController
                                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingViewController];
                                self.view.window.rootViewController = navController;
                                
//                                TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
//                                //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
//                                self.view.window.rootViewController = tabBarController;
                            }
                            completion:nil];
        }
        
    }else{
        
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionShowHideTransitionViews
                        animations:^{
                            LandingViewController *landingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"landingViewController"]; //or the homeController
                            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingViewController];
                            self.view.window.rootViewController = navController;
                        }
                        completion:nil];
    
    }
    
//    if (false) {
//        TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
//        //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
//        self.view.window.rootViewController = tabBarController;
//    }else{
//        LandingViewController *landingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"landingViewController"]; //or the homeController
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingViewController];
//        self.view.window.rootViewController = navController;
//        
//    }
}

- (void)getUserDetail{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getuserinfo",Base_URL]];
        //old
//        NSString *post =[[NSString alloc] initWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
//        post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        //new
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        NSLog(@"token = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]  isEqual: @"(null)"]){
            [paramDic setObject:@"" forKey:@"token"];

        }else{
            [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        }
        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"getuserinfo response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            UserDetails *object = [[UserDetails alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"UserDetails Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                [Singletons sharedManager].userDetail  = object;
                                
                                TabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"]; //or the homeController
                                //    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
                                self.view.window.rootViewController = tabBarController;
                            }
                            
                            
                        }else{
                            NSDictionary *errorDic = [returnedDict objectForKey:@"error"];
                            
                            [self showNoHandlerAlertWithTitle:@"getuserinfo failed 👎" andMessage:[[errorDic objectForKey:[[errorDic allKeys] objectAtIndex:0]] objectAtIndex:0]];
                        }
                        
                        
                    }else{
                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                        
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)getCountryList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcountry",Base_URL]];
        
        //        NSString *post = nil;
        
        // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        [ApiManager callAPI:url parameters:nil method:@"GET" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        
                        //                        NSError *error;
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"response = %@",str);
                        
                        //                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        JSONModelError *jsonModelError = nil;
                        CountryResponse *object = [[CountryResponse alloc]initWithData:data error:&jsonModelError];
                        if (object == nil) {
                            [self showNoHandlerAlertWithTitle:@"CountryResponse Parse Error" andMessage:[jsonModelError localizedDescription]];
                        }else{
                            [Singletons sharedManager].countryList  = [object.countriesRes mutableCopy];
                        }
                        

                        
                    }else{
                        [self showNoHandlerAlertWithTitle:@"Backend Error" andMessage:[NSString stringWithFormat:@"%@",response]];
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                    
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
