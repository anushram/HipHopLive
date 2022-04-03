//
//  ApiManager.m
//  HipHopLive
//
//  Created by K Saravana Kumar on 26/10/18.
//  Copyright © 2018 Securenext. All rights reserved.
//

#import "ApiManager.h"

@implementation ApiManager

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    
    // Instantiate a session configuration object.
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    
    configuration.timeoutIntervalForRequest = 20.0;
    
    //configuration.timeoutIntervalForResource = 40.0;
    
    
    
    // Instantiate a session object.
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    
    // Create a data task object to perform the data downloading.
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        if (error != nil) {
            
            // If any error occurs then just display its description on the console.
            
            NSLog(@"%@", [error localizedDescription]);
            
        }
        else
            
        {
            
            // If no error occurs, check the HTTP status code.
            
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            
            // If it's other than 200, then show it on the console.
            
            if (HTTPStatusCode != 200) {
                
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                
            }
            
            
            
            // Call the completion handler with the returned data on the main thread.
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                completionHandler(data);
                
            }];
            
        }
        
    }];
    
    
    
    // Resume the task.
    
    [task resume];
    
}



+(void)PostURL:(NSURL *)url SendData:(NSString *)dataRecive withCompletionHandler:(void(^)(NSData *data))completionHandler

{
    
    @try {
        
        
        
        //    NSError *error;
        
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        
        
        configuration.timeoutIntervalForRequest = 20.0;
        
        
        
        //    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        
        
        //NSURL *url = [NSURL URLWithString:@"[JSON SERVER"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        
        
        NSData *postData = [dataRecive dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        
        
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [request setHTTPBody:postData];
        
        
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            
            
            if (error != nil) {
                
                // If any error occurs then just display its description on the console.
                
                NSLog(@"%@", [error localizedDescription]);
                
            }
            
            else{
                
                @try {
                    
                    // If no error occurs, check the HTTP status code.
                    
                    NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                    
                    
                    
                    // If it's other than 200, then show it on the console.
                    
                    if (HTTPStatusCode != 200) {
                        
                        NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                        
                    }
                    
                    
                    
                    // Call the completion handler with the returned data on the main thread.
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        completionHandler(data);
                        
                    }];
                    
                    
                    
                } @catch (NSException *exception) {
                    
                    NSLog(@"exception error=%@",exception);
                    
                } @finally {
                    
                    
                    
                }
                
            }
            
            
            
        }];
        
        
        
        [postDataTask resume];
        
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"exception=%@",exception);
        
        
        
    } @finally {
        
        
        
    }
    
}



+(void)AlertviewTitle:(NSString *)title Message:(NSString *)messegerecived withCompletionHandler:(void(^)(UIAlertController *alert))completionHandler;

{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:messegerecived preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *bt=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:bt];
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            completionHandler(alert);
            
        }];
        
        
        
    });
    
}

+(void)callAPI:(NSURL *)url parameters:(nullable NSMutableDictionary *)param method:(NSString *)method withCompletionHandler:(void (^)(NSInteger statusCode, NSData * _Nonnull, NSURLResponse * _Nonnull, NSError * _Nonnull))completionHandler withError:(void(^)(NSError *error))errorHandler{
    
    @try {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 20.0;
        
        //    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        //NSURL *url = [NSURL URLWithString:@"[JSON SERVER"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        //new
        NSString *jsonString;
        NSError *error;
        NSData *jsonData;
        NSData *requestData;

        if (param != nil){
            jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
        }
               
        //old
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
//        NSData *postData = [param dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]];

        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:method];
        [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
        
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
                
                @try {
                    
                    // If no error occurs, check the HTTP status code.
                    
                    NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                    
                    // Call the completion handler with the returned data on the main thread.
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        completionHandler(HTTPStatusCode, data, response, error);
                        
                    }];
                    
                    
                    
                } @catch (NSException *exception) {
                    NSError *error = [NSError errorWithDomain:@"Somthing wrong" code:404 userInfo:nil];
                    NSLog(@"exception error=%@",exception);
                    errorHandler(error);
                    
                } @finally {
                    
                }
            
            
            
        }];
        
        [postDataTask resume];
        
        
        
    } @catch (NSException *exception) {
        
        NSError *error = [NSError errorWithDomain:@"Somthing wrong" code:404 userInfo:nil];
        NSLog(@"exception error=%@",exception);
        errorHandler(error);
        
    } @finally {
        
        
        
    }
}

@end
