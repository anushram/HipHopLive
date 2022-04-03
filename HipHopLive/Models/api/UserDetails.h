//
//  UserDetails.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UserDetails
@end
@interface UserDetails : JSONModel
@property (nonatomic) NSString* firstname;
@property (nonatomic) NSString* lastname;
@property (nonatomic) NSString* email;
@property (nonatomic) NSString<Optional> *phone;
@property (nonatomic) NSString* city;
@property (nonatomic) NSInteger stateID;
@property (nonatomic) NSInteger countryID;
@property (nonatomic) NSString* roleID;
@property (nonatomic) NSString* updated_at;
@property (nonatomic) NSString* created_at;
@property (nonatomic) int id;
@property (nonatomic) NSString* role;
@property (nonatomic) NSString* countryName;
@property (nonatomic) NSString* stateName;
@property (nonatomic) int following;
@property (nonatomic) int followers;
@property (nonatomic) NSString <Optional> *imagename;
@property (nonatomic) NSString <Optional> *display_name;
@property (nonatomic) NSString <Optional> *personal_message;
@property (nonatomic) NSString* username;
@end

NS_ASSUME_NONNULL_END
