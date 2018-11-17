//
//  DelegateDownloadViewController.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/6.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "DelegateDownloadViewController.h"

@interface DelegateDownloadViewController ()<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDataTask * dataTask;

#pragma mark 用于接受请求数据的对象
@property (nonatomic, strong) NSMutableData * data;

@end

@implementation DelegateDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@""];
    self.dataTask = [self.session dataTaskWithURL:url];
}

- (NSURLSession *)session {
    
    if (_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    
    return _session;
}

- (IBAction)resume:(id)sender {
    
    if (self.dataTask.state == NSURLSessionTaskStateSuspended) {
        [self.dataTask resume];
    }
    
}


- (IBAction)pause:(id)sender {
    
    // 1. 判断 task 当前的状态，如果处于正在接受数据的状态，则暂停
    if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask suspend];
    }
}


- (IBAction)cancel:(id)sender {
    
    // 1. 判断 task 当前的状态，如果处于正在接受数据的状态或暂停状态，则取消
    if (self.dataTask.state == NSURLSessionTaskStateRunning || self.dataTask.state == NSURLSessionTaskStateSuspended) {
        
        [self.dataTask cancel];
    }
}

/**
 1 typedef NS_ENUM(NSInteger, NSURLSessionResponseDisposition) {
 2     NSURLSessionResponseCancel = 0,        // 取消接受数据，之后的代理方法不会被执行，相当于 [task cancel];
 3     NSURLSessionResponseAllow = 1,         // 允许接受数据，之后的代理方法会被执行
 4     NSURLSessionResponseBecomeDownload = 2,// 使当前的 data task 变为 download task，当转换为 download task 时，会将数据下载到临时文件 tmp 中；此时，task 就变为 下载任务了，并且必须实现 URLSession:dataTask:didBecomeDownloadTask: 方法，并且在该方法中可以什么都不写，但必须被调用
 5     NSURLSessionResponseBecomeStream NS_ENUM_AVAILABLE(10_11, 9_0) = 3,// 使当前的 data task 变为 stream task
 6 } NS_ENUM_AVAILABLE(NSURLSESSION_AVAILABLE, 7_0);
 */

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 1. 初始化数据对象
    self.data = [[NSMutableData alloc] init];
    
    // 2. 允许接受数据，如果没有写这句，则后面代理的方法不会被执行
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.data appendData:data];
    
    NSLog(@"已经接收到%.2f", (float)(self.dataTask.countOfBytesReceived/self.dataTask.countOfBytesExpectedToReceive));
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"请求失败");
        return;
    }
    
    NSLog(@"请求完成");
}


@end
