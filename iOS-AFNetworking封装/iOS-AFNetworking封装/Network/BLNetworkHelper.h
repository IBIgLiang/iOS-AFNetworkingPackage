//
//  BLNetworkHelper.h
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/15.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "BLNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BLHTTPMethod) {
    BLHTTPMethod_GET,
    BLHTTPMethod_POST,
    BLHTTPMethod_PUT,
};

typedef void (^successCompletion) (id response);
typedef void (^failCompletion) (NSError *error);

@interface BLNetworkHelper : NSObject



@end

NS_ASSUME_NONNULL_END
