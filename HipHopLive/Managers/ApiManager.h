//
//  ApiManager.h
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import <Foundation/Foundation.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface ApiManager : NSObject

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

+(void)PostURL:(NSURL *)url SendData:(NSString *)data withCompletionHandler:(void(^)(NSData *data))completionHandler;

+(void)callAPI:(NSURL *)url parameters:(nullable NSMutableDictionary *)param method:(NSString *)method withCompletionHandler:(void(^)(NSInteger statusCode, NSData *data, NSURLResponse *response, NSError *error))completionHandler withError:(void(^)(NSError *error))errorHandler;

@end

NS_ASSUME_NONNULL_END
