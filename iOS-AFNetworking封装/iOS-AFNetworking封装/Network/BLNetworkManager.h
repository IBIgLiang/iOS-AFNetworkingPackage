//
//  BLNetworkManager.h
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/7.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

/**
 本人只考虑了GET/POST方式,所以在HttpRequestType的枚举中只有GET和POST(作为练习)
 1 manager 考虑用单例 shareManager
    在创建单例的时候可以考虑把baseURL放入,这样在调用的时候,只需要开发者加入service path
    我们可以考虑单独建立一个类来管理我们的URL 
 */

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,BLHttpRequestType){
    
    BLHttpRequestTypeGet = 0,
    BLHttpRequestTypePost = 1
};

/**
 成功
 */
typedef void (^requestSuccessCompletion)(NSDictionary *responseObject);

/**
 失败
 */
typedef void (^requestFailCompletion)(NSError *error);

/**
 上传进度
 */
typedef void(^uploadProgress)(float progress);

/**
 下载进度
 */
typedef void(^downloadProgress)(float progress);



@interface BLNetworkManager : AFHTTPSessionManager



/**
 *  单利方法
 *
 *  @return 实例对象
 */
+(instancetype)shareManager;

- (void)requestWithHTTPRequestType:(BLHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccess:(requestSuccessCompletion)success withFail:(requestFailCompletion)fail withProgress:(downloadProgress)progress;


@end

NS_ASSUME_NONNULL_END
