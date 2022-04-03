//
//  CountryDetail.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 01/11/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CountryDetail
@end
@interface CountryDetail : JSONModel
@property (assign, nonatomic) int countryID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* phonecode;
@property (strong, nonatomic) NSString* sortname;

@end

NS_ASSUME_NONNULL_END
