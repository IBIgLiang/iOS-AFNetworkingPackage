//
//  BLNetworkHelper.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/15.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "BLNetworkHelper.h"
#import "AFNetworkActivityIndicatorManager.h"

static AFHTTPSessionManager *_kHTTPSessionManager;

@implementation BLNetworkHelper

+ (void)initialize {
    
    _kHTTPSessionManager = [AFHTTPSessionManager manager];
    _kHTTPSessionManager.requestSerializer.timeoutInterval = 15.0;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    _kHTTPSessionManager.responseSerializer = responseSerializer;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URL
                   parameters:(id)parameters
                      success:(successCompletion)success
                      failure:(failCompletion)failure {
    
    NSURLSessionDataTask *dataTask = [_kHTTPSessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return dataTask;
    
}

+ (NSURLSessionDataTask *)POST:(NSString *)URL
                   parameters:(id)parameters
                      success:(successCompletion)success
                      failure:(failCompletion)failure {
    
    NSURLSessionDataTask *dataTask = [_kHTTPSessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return dataTask;
}

@end
