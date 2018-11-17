//
//  BLNetworkManager.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/7.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "BLNetworkManager.h"
#import "BLNetworkDefine.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <YYCache/YYCache.h>


@implementation BLNetworkManager

+ (instancetype)shareManager {
    
    static BLNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    
    return manager;
}


/**
 创建manager, 同时设置requestSerializer 和 responseSerializer

 @param url 基础url
 @return self
 */
- (instancetype)initWithBaseURL:(NSURL *)url{
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        
        NSAssert(nil, @"n请设置baseurl");
        
        //TODO: 疑问点
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 设置请求的序列化器
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //设置网络超时时间
        self.requestSerializer.timeoutInterval = 15.0;
        
        // 设置缓存策略 (忽略本地缓存,直接从服务器读取数据)
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        // 设置响应的序列化器
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
//        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer = responseSerializer;
        
        // 请求头里面的信息
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // 设置可接受的类型
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    }
    
    return self;
}

- (void)requestWithHTTPRequestType:(BLHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccess:(requestSuccessCompletion)success withFail:(requestFailCompletion)fail withProgress:(downloadProgress)progress {
    
    switch (type) {
        case BLHttpRequestTypeGet:
        {
            [[BLNetworkManager shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (fail) {
                    fail(error);
                }
            }];
        }
            break;
        case BLHttpRequestTypePost:
        {
            [[BLNetworkManager shareManager] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) {
                    progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (fail) {
                    fail(error);
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 多图上传

/**
 多图上传

 @param operations 操作
 @param imageArray 图片列表
 @param width g宽度
 @param urlString url
 @param successBlock 成功block
 @param failureBlock 失败block
 @param progressBlock 进度
 */
- (void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat)width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccessCompletion)successBlock withFailurBlock:(requestFailCompletion)failureBlock withUpLoadProgress:(uploadProgress)progressBlock {
    
    
    [[BLNetworkManager shareManager] uploadImageWithOperations:operations withImageArray:imageArray withtargetWidth:width withUrlString:urlString withSuccessBlock:^(NSDictionary * _Nonnull responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } withFailurBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } withUpLoadProgress:^(float progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }];
}

+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccessCompletion)successBlock withFailureBlock:(requestFailCompletion)failureBlock withDownLoadProgress:(downloadProgress)progress
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [[BLNetworkManager shareManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failureBlock(error);
        }
    }];
}

#pragma mark -  取消所有的网络请求
/**
 *  取消所有的网络请求
 */

+(void)cancelAllRequest{
    
    [[BLNetworkManager shareManager].operationQueue cancelAllOperations];
}



#pragma mark -   取消指定的url请求
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
*/
+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string {
    
    NSError *error;
    
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString *urlToCacel = [[[[BLNetworkManager shareManager].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [BLNetworkManager shareManager].operationQueue.operations) {
        
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            NSURLSessionTask *task = (NSURLSessionTask *)operation;
            
            BOOL isCancelRequestType = [[task currentRequest].HTTPMethod isEqualToString:requestType];
            
            BOOL isCancelRequestURL = [[task currentRequest].URL.path isEqualToString:urlToCacel];
            
            if (isCancelRequestURL && isCancelRequestType) {
                [operation cancel];
            }
        }
    }
}

+ (NSString *)cacheFilePathWithURL:(NSString *)URL {
    
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"bcwYYCache"];
    
    [self checkDirectory:path];//check路径
    
    //文件名
    NSString *cacheFileNameString = [NSString stringWithFormat:@"URL:%@ AppVersion:%@",URL,[self appVersionString]];
    NSString *cacheFileName = [self md5StringFromString:cacheFileNameString];
    path = [path stringByAppendingPathComponent:cacheFileName];
    
    //   DNSLog(@"缓存 path = %@",path);
    
    return path;
}

+(void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        
        [self addDoNotBackupAttribute:path];
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    
//    if(string == nil || [string length] == 0)  return nil;
//
//    const char *value = [string UTF8String];
//
//    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
//
//    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
//        [outputString appendFormat:@"%02x",outputBuffer[count]];
//    }
    
//    return outputString;
    
    return nil;
}

+ (NSString *)appVersionString {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
