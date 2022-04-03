//
//  CustomizeViewController.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 18/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "CustomizeViewController.h"

@interface CustomizeViewController ()

@end

@implementation CustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar:@"Customize"];

//    self.allCatogoryList_Arr = [[NSArray alloc]initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
    self.headerTitle_Arr = [[NSArray alloc]initWithObjects:@"Customize Categories",@"All Categories",nil];
//    self.customCatogoryList_Arr = [[NSArray alloc]initWithObjects:@"Friday",@"Saturday",@"Sunday",nil];
    

    _selectedCatID_Arr = [[NSMutableArray alloc]init];

    [self getCategoryList];
}

//# MARK: uitableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerTitle_Arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.selected_CatogoryList_Arr.count;
    }else{
        return self.allCatogoryList_Arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"customCell";
    
    NSLog(@"section= %ld",(long)indexPath.section);
    if (indexPath.section == 0) {
        CustomizeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        CategoriesDetail *value = [self.selected_CatogoryList_Arr objectAtIndex:indexPath.row];
        [cell.checkBox_Btn setImage:[UIImage imageNamed:@"minusBox"] forState:UIControlStateNormal];
        cell.catogary_Lbl.text = value.name_category;
        cell.checkBox_Btn.tag = indexPath.row;
//        cell.checkBox_Btn.userInteractionEnabled = true;
//        [cell.checkBox_Btn addTarget:self action:@selector(minusBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
    }else{
        CustomizeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        CategoriesDetail *value = [self.allCatogoryList_Arr objectAtIndex:indexPath.row];
        if (![self.selectedCatID_Arr containsObject:[NSNumber numberWithInt:value.id]]) {
            [cell.checkBox_Btn setImage:[UIImage imageNamed:@"emptyBox"] forState:UIControlStateNormal];
//            cell.checkBox_Btn.userInteractionEnabled = true;
            

        }else{
            [cell.checkBox_Btn setImage:[UIImage imageNamed:@"tickBox"] forState:UIControlStateNormal];
//            cell.checkBox_Btn.userInteractionEnabled = false;
//            cell.userInteractionEnabled = NO;

        }
        
        cell.catogary_Lbl.text = value.name_category;
        cell.checkBox_Btn.tag = indexPath.row;
//        [cell.checkBox_Btn addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


        return cell;

    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, tableView.frame.size.width, 22)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    NSString *string =[self.headerTitle_Arr objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor lightGrayColor]]; //your background color...
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        CategoriesDetail *value = [self.selected_CatogoryList_Arr objectAtIndex:indexPath.row];
        [self.selectedCatID_Arr removeObject:[NSNumber numberWithInteger:value.id]];
        [self addCategoryList];
    }else{
        CategoriesDetail *value = [self.allCatogoryList_Arr objectAtIndex:indexPath.row];
        if (![self.selectedCatID_Arr containsObject:[NSNumber numberWithInt:value.id]]) {
            
            [self.selectedCatID_Arr addObject:[NSNumber numberWithInteger:value.id]];
            [self addCategoryList];
        }

    }
}

-(void)getCategoryList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getcategories",Base_URL]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/customizecategory",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            
            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        // NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"customizecategory response = %@",str);
                        
                        NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            
                            JSONModelError *jsonModelError = nil;
                            CustomizeCategoryResponse *object = [[CustomizeCategoryResponse alloc]initWithData:data error:&jsonModelError];

                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"customizecategory Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                
                                
                                self->_allCatogoryList_Arr = [object.all_category mutableCopy];
                                self->_selected_CatogoryList_Arr = [object.selected_category mutableCopy];
                                [self.selectedCatID_Arr removeAllObjects];
                                for (CategoriesDetail *obj in self->_selected_CatogoryList_Arr) {
                                    [self.selectedCatID_Arr addObject:[NSNumber numberWithInteger:obj.id]];
                                }
                                
                                [self.tableView reloadData];
                                //                        [self createScrollMenu];
                                
                            }
                            
                        }else{
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                        }
                        
                        
                    }
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    [self showNoHandlerAlertWithTitle:@"Alert" andMessage:str];
                    
                }
            }
            
        } withError:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = false;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)checkBoxButtonPressed:(UIButton*)button{
    CategoriesDetail *value = [self.allCatogoryList_Arr objectAtIndex:button.tag];
    [self.selectedCatID_Arr addObject:[NSNumber numberWithInteger:value.id]];
    [self addCategoryList];
}

-(void)minusBoxButtonPressed:(UIButton*)button{
    CategoriesDetail *value = [self.selected_CatogoryList_Arr objectAtIndex:button.tag];
    [self.selectedCatID_Arr removeObject:[NSNumber numberWithInteger:value.id]];
    [self addCategoryList];
    
    
}

-(void)addCategoryList{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status)  isEqual: @"Not Reachable"]){
            [self showNoHandlerAlertWithTitle:@"Network Error" andMessage:@"Please Check Your Internet"];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.tabBarController.tabBar.userInteractionEnabled = false;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/addcustomcategories",Base_URL]];
        
        //        NSString *post = nil;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        [paramDic setObject:self->_selectedCatID_Arr forKey:@"category_id"];
        
        [ApiManager callAPI:url parameters:paramDic method:@"POST" withCompletionHandler:^(NSInteger statusCode, NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tabBarController.tabBar.userInteractionEnabled = true;
            
            if (error != nil) {
                [self showNoHandlerAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            }else{
                if (statusCode == 200) {
                    // Check if any data returned.
                    
                    if (data != nil) {
                        
                        // Convert the returned data into a dictionary.
                        //                            NSError *error;
                        
                        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"addcustomcategories response = %@",str);
                        
                        NSDictionary *
                        returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        
                        if ([[returnedDict objectForKey:@"response"] isEqualToString:@"success"]){
                            JSONModelError *jsonModelError = nil;
                            CustomizeCategoryResponse *object = [[CustomizeCategoryResponse alloc]initWithData:data error:&jsonModelError];
                            if (object == nil) {
                                [self showNoHandlerAlertWithTitle:@"addcustomcategories Parse Error" andMessage:[jsonModelError localizedDescription]];
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    self->_allCatogoryList_Arr = [object.all_category mutableCopy];
                                    self->_selected_CatogoryList_Arr = [object.selected_category mutableCopy];
                                    [self.selectedCatID_Arr removeAllObjects];
                                    for (CategoriesDetail *obj in self->_selected_CatogoryList_Arr) {
                                        [self.selectedCatID_Arr addObject:[NSNumber numberWithInteger:obj.id]];
                                    }
                                    
                                    [self.tableView reloadData];
                                    
                                });
                            }
                        }else{
                            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[NSString stringWithFormat:@"%@",[returnedDict objectForKey:@"message"]]];
                            
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
            self.tabBarController.tabBar.userInteractionEnabled = true;
            
            [self showNoHandlerAlertWithTitle:@"Alert" andMessage:[error localizedDescription]];
            
        }];
        
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
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
