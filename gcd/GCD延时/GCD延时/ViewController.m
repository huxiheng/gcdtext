//
//  ViewController.m
//  GCD延时
//
//  Created by Tesiro on 16/11/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"
#import "GCD.h"

@interface ViewController ()
@property (nonatomic, strong)GCDTimer    *gcdTimer;
@property (nonatomic, strong)NSTimer     *normaltimer;

@property (nonatomic, strong)UIImageView *view1;
@property (nonatomic, strong)UIImageView *view2;
@property (nonatomic, strong)UIImageView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view1 = [self creatImageViewWithFrame:CGRectMake(0, 0, 100, 100)];
    self.view2 = [self creatImageViewWithFrame:CGRectMake(0, 100, 100, 100)];
    self.view3 = [self creatImageViewWithFrame:CGRectMake(0, 200, 100, 100)];
    
    NSString *net1 = @"";
    NSString *net2 = @"";
    NSString *net3 = @"";
    
    //初始化信号量
    GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
    
    
    [GCDQueue executeInGlobalQueue:^{
        //获取图片
        UIImage *image1 = [self accessdatabynetstring:net1];
        
        [GCDQueue executeInMainQueue:^{
            [UIView animateWithDuration:2.f animations:^{
                self.view1.image = image1;
                self.view1.alpha = 1.0;
            } completion:^(BOOL finished) {
                //发送信号
                [semaphore signal];
            }];
        }];
    }];
    
    [GCDQueue executeInGlobalQueue:^{
        //获取图片
        UIImage *image2 = [self accessdatabynetstring:net2];
        
        //阻塞
        [semaphore wait];
        
        [GCDQueue executeInMainQueue:^{
            [UIView animateWithDuration:2.f animations:^{
                self.view2.image = image2;
                self.view2.alpha = 1.0;
            } completion:^(BOOL finished) {
                //发送信号
                [semaphore signal];
            }];
        }];
    }];
    
    [GCDQueue executeInGlobalQueue:^{
        //阻塞
        [semaphore wait];
        
        //获取图片
        UIImage *image3 = [self accessdatabynetstring:net3];
        
        [GCDQueue executeInMainQueue:^{
            [UIView animateWithDuration:2.f animations:^{
                self.view3.image = image3;
                self.view3.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

//创建view
-(UIImageView *)creatImageViewWithFrame:(CGRect)frame{
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:frame];
    iamgeView.alpha = 0.f;
    [self.view addSubview:iamgeView];
    return iamgeView;
}

//获取图片
-(UIImage *)accessdatabynetstring:(NSString *)string{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [UIImage imageWithData:data];
}

//创建信号量
-(void)gcdxinhaoliang{
    GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
    
    //线程1 － 异步
    [GCDQueue executeInGlobalQueue:^{
        NSLog(@"线程1");
        //发送信号
        [semaphore signal];
        
    }];
    
    //线程2 － 异步
    [GCDQueue executeInGlobalQueue:^{
        NSLog(@"线程2");
        //等待信号
        [semaphore wait];
        
    }];
}

//运行gcdtimer
-(void)runGCDTimer{
    //初始化定时器
    self.gcdTimer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    
    //指定时间间隔以及要执行的事件
    [self.gcdTimer event:^{
        NSLog(@"gcd定时器");
    } timeInterval:NSEC_PER_SEC];
    
    //运行gcd定时器
    [self.gcdTimer start];
    
}

//运行nstimer定时器
-(void)runnstimer{
    self.normaltimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                        target:self
                                                      selector:@selector(timeevent)
                                                      userInfo:nil
                                                       repeats:YES];
}

-(void)timeevent{
    NSLog(@"nstimer定时器");
}


//gcd线程组
-(void)gcdxianchengzu{
    //初始化一个线程组合
    GCDGroup *group = [[GCDGroup alloc] init];
    
    //创建一个线程队列
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
    
    //让线程在group中执行（线程1）
    [queue execute:^{
        sleep(1);
        NSLog(@"线程1执行完毕");
    } inGroup:group];
    
    //让线程在group中执行（线程2）
    [queue execute:^{
        sleep(3);
        NSLog(@"线程2执行完毕");
    } inGroup:group];
    
    //监听线程组是否执行结束，然后执行线程3
    [queue notify:^{
        NSLog(@"线程3执行完毕");
    } inGroup:group];
}

//gcd延时
-(void)gcdyanshi{
    NSLog(@"启动");
    //nsthread方式的延时执行操作
    [self performSelector:@selector(threadevent:)
               withObject:self
               afterDelay:2.f];
    //取消延时操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [GCDQueue executeInMainQueue:^{
        NSLog(@"gcd线程事件");
    }
                  afterDelaySecs:2.f];
}
-(void)threadevent:(id)sender{
    NSLog(@"nsthread线程事件");
}


@end
