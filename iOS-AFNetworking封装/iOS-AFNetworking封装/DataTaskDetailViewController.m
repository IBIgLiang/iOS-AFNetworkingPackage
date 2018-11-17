//
//  DataTaskDetailViewController.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/6.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "DataTaskDetailViewController.h"

#define Image_URL_Str @"https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=false&word=beautiful%20girl&step_word=&hs=0&pn=1&spn=0&di=52250&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=1604124522%2C2679313908&os=3695407249%2C11713138&simid=4151168429%2C684375564&adpicid=0&lpn=0&ln=3896&fr=&fmq=1541510660414_R&fm=result&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=girl&bdtype=0&oriquery=&objurl=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201512%2F24%2F20151224052307_y5Kve.png&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B17tpwg2_z%26e3Bv54AzdH3Fks52AzdH3F%3Ft1%3Dcadd0lbmb&gsm=0&rpstart=0&rpnum=0&islist=&querylist="

#define dataURL  @"http://api.hudong.com/iphonexml.do"

@interface DataTaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation DataTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewTitle;
    
    self.session = [NSURLSession sharedSession];
}

- (IBAction)getImageAction:(id)sender {
    
    self.task = [self.session dataTaskWithURL:[NSURL URLWithString:Image_URL_Str] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    }];
    
    [self.task resume];
}
- (IBAction)postImageAction:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataURL]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"type=focus-c" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 是否用cookie来处理创建的请求。默认为YES
    [request setHTTPShouldHandleCookies:YES];
    
    /**
     创建的请求在收到上个传输（transmission）响应之前是否继续发送数据。
     默认为NO(即等待上次传输完成后再请求)
     */
    [request setHTTPShouldUsePipelining:NO];
    
     self.task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [self.task resume];
}

@end
