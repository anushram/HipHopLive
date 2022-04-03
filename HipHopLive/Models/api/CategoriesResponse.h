//
//  CategoriesResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 14/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "CategoriesDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoriesResponse : JSONModel
@property (nonatomic) NSArray <CategoriesDetail, Optional> *categories;

@end

NS_ASSUME_NONNULL_END
