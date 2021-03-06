//
//  GCDTimer.h
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDQueue;

@interface GCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initInQueue:(GCDQueue *)queue;

#pragma 用法
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)start;
- (void)destroy;


@end
