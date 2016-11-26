//
//  ViewController.m
//  GCD
//
//  Created by Tesiro on 16/11/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"
#import "GCD.h"

@interface ViewController ()
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self intconcurrent];
    
    //初始化imageview
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
   
    
    
    [GCDQueue executeInGlobalQueue:^{
        //处理业务逻辑
        
        NSString *netURLString = @"";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:netURLString]];
        //发起一个同步请求,会阻塞主线程
        NSData *picdata = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:nil
                                                            error:nil];
        self.image = [UIImage imageWithData:picdata];
        
        [GCDQueue executeInMainQueue:^{
            //更新ui
            self.imageView.image = self.image;
        }];
    }];
}

//并发队列
-(void)intconcurrent{
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
    
    //执行队列
    [queue execute:^{
        NSLog(@"1");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"2");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"3");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"4");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"5");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"6");
    }];
}


//串行队列
-(void)serailqueue{
    GCDQueue *queue = [[GCDQueue alloc] initSerial];
    
    //执行队列
    [queue execute:^{
        NSLog(@"1");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"2");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"3");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"4");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"5");
    }];
    //执行队列
    [queue execute:^{
        NSLog(@"6");
    }];
}
@end
