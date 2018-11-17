//
//  demo.m
//  iOS-AFNetworking封装
//
//  Created by zhangzhiliang on 2018/11/9.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "demo.h"

@implementation demo

- (void)test {
    NSMutableArray* ary = [[NSMutableArray array] retain];
    
    NSString *str = [NSString stringWithFormat:@"test"];
    
    [str retain];
    [ary addObject:str];
    
    NSLog(@"%@ %tu",str,[str retainCount]);
    
    [str retain];
    
    [str release];
    
    [str release];
    
    NSLog(@"%@ %tu",str,[str retainCount]);
    
    [ary removeAllObjects];
    
    NSLog(@"%@ %tu",str,[str retainCount]);
    
//    NSMutableArray* ary = [[NSMutableArray array] retain];
//
//    NSString *str = [NSString stringWithFormat:@"test"];
//
//    [str retain];
//
//    [aryaddObject:str];
//
//    NSLog(@"%@%d",str,[str retainCount]);
//
//    [str retain];
//
//    [str release];
//
//    [str release];
//
//    NSLog(@"%@%d",str,[str retainCount]);
//
//    [aryremoveAllObjects];
//
//    NSLog(@"%@%d",str,[str retainCount]);
}

@end
