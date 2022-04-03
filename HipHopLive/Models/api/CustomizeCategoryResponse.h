//
//  CustomizeCategoryResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 19/01/19.
//  Copyright © 2019 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "CategoriesDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeCategoryResponse : JSONModel
@property (nonatomic) NSArray <CategoriesDetail, Optional> *all_category;
@property (nonatomic) NSArray <CategoriesDetail, Optional> *selected_category;
@property (nonatomic) NSString *response;
@property (nonatomic) NSString *message;

@end

NS_ASSUME_NONNULL_END
