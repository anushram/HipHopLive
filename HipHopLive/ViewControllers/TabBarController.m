//
//  TabBarController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.barTintColor=[UIColor colorWithRed:197/255.0 green:36/255.0 blue:232/255.0 alpha:1.0];
    
    NSString *type = [[NSUserDefaults standardUserDefaults]objectForKey:@"notification_type"];
    if (![type isEqualToString:@""]){
        if ([type isEqualToString:@"invite"] || [type isEqualToString:@"accept"]) {
            [self.tabBarController setSelectedIndex:3];
            self.selectedIndex = 3;

        }else{
            [self.tabBarController setSelectedIndex:4];
            self.selectedIndex = 4;
        }
    }

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
