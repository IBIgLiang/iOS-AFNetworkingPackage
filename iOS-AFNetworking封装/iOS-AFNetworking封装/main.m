//
//  main.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/6.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "demo.h"

int main(int argc, char * argv[]) {
    [[[demo alloc]init] test];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
