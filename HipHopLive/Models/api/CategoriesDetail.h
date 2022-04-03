//
//  CategoriesDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 14/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CategoriesDetail
@end
@interface CategoriesDetail : JSONModel
//@property (nonatomic) NSInteger category_id;
@property (nonatomic) NSString<Optional> *created_at;
@property (nonatomic) int id;
@property (nonatomic) NSString *name_category;
@property (nonatomic) NSString<Optional> *status;
@property (nonatomic) NSString<Optional> *updated_at;
@end

NS_ASSUME_NONNULL_END
