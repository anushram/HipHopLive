//
//  SettingsViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 13/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar:@"Settings"];
    NSArray *notificationArr = [NSArray arrayWithObjects:@"Notification Allow",@"Location Allow", nil];
    NSArray *privacyArr = [NSArray arrayWithObjects:@"Blocked Users", nil];
    NSArray *supportArr = [NSArray arrayWithObjects:@"Help", nil];
    NSArray *aboutArr = [NSArray arrayWithObjects:@"Terms and Conditions",@"Privacy Policy",@"Contact Us", nil];
    
    _tableDic = [[NSMutableDictionary alloc]init];
    [_tableDic setObject:notificationArr forKey:@"Notification"];
    [_tableDic setObject:privacyArr forKey:@"Privacy"];
    [_tableDic setObject:supportArr forKey:@"Support"];
    [_tableDic setObject:aboutArr forKey:@"About HipHopLive"];
    
}


 //MARK : Tableview datasource and delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableDic allKeys].count;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [_tableDic objectForKey:[[_tableDic allKeys] objectAtIndex:section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = (SettingsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    UILabel *lbldescription = (UILabel *)[cell viewWithTag:1];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSArray *arr = [_tableDic objectForKey:[[_tableDic allKeys] objectAtIndex:indexPath.section]];
    
    cell.title.text = [arr objectAtIndex:indexPath.row];
    if (indexPath.section == 3) {
        cell.switch_btn.on = false;
        cell.switch_btn.hidden = false;

    }else{
        cell.switch_btn.hidden = true;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 2 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"SegueSettingToFollowerFollowing" sender:@"blockuser"];
            
        });
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"SegueSettingsToWebview" sender:@"TermsandConditions"];
                
            });
        }else if (indexPath.row == 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"SegueSettingsToWebview" sender:@"PrivacyPolicy"];
                
            });
        }
    }
   
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
    if ( indexPath.section == 3 ) return nil;
    
    //    // first 3 rows in any section should not be selectable
    //    if ( indexPath.row <= 2 ) return nil;
    
    // By default, allow row to be selected
    return indexPath;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"TableviewCell_Header"];
//
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.backgroundColor=[UIColor whiteColor];
//
//    return cell;
//}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"title=%@",[[_tableDic allKeys] objectAtIndex:section]);
    return [[_tableDic allKeys] objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueSettingToFollowerFollowing"]) {
        
        FollowersFollowingViewController *nextVC  = segue.destinationViewController;
        nextVC.selectionType = sender;
        nextVC.userID = [Singletons sharedManager].userDetail.id;
    }else if ([segue.identifier isEqualToString:@"SegueSettingsToWebview"]) {
        
        WebViewController *nextVC  = segue.destinationViewController;
        nextVC.selectionType = sender;
    }
}


@end
