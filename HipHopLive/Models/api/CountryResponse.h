//
//  CountryResponse.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 31/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"
#import "CountryDetail.h"

NS_ASSUME_NONNULL_BEGIN
@interface CountryResponse : JSONModel
@property (strong, nonatomic) NSArray<CountryDetail, Optional>* countriesRes;
@end

NS_ASSUME_NONNULL_END
