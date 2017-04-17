//
//  TestSix.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  信号量---------> 实现GCD线程同步

/***
 1. 解释信号量：  信号量就是一个资源计数器，对信号量有两个操作来达到互斥，分别是P和V操作。 一般情况是这样进行临界访问或互斥访问的： 设信号量值为1， 当一个进程1运行是，使用资源，进行P操作，即对信号量值减1，也就是资源数少了1个。这是信号量值为0。系统中规定当信号量值为0时，必须等待，直到信号量值不为零才能继续操作。 这时如果进程2想要运行，那么也必须进行P操作，但是此时信号量为0，所以无法减1，即不能P操作，也就阻塞。这样就到到了进程1 排他访问。 当进程1运行结束后，释放资源，进行V操作。资源数重新加1，这时信号量的值变为1. 这时进程2发现资源数不为0，信号量能进行P操作了，立即执行P操作。信号量值又变为0.此时进程2占有资源，排他访问资源。 这就是信号量来控制互斥的原理.  pv是荷兰语好像，p是表示通过 ，v表示阻塞，p对信号进行减一操作
 
 2. 简单来讲 信号量为0则阻塞当前线程，大于0则不会阻塞。则我们通过改变信号量的值，来控制是否阻塞当前线程，从而达到线程同步。
 3. 当然在NSoperation下可以直接设置并发数，就没有这么麻烦了
 
 4. GCD的时候如何让线程同步：线程同步即多个线程在一条线上上顺序执行
         1.dispatch_group
         2.dispatch_barrier
         3.dispatch_semaphore
 
 5.
 
 */




#import "TestSix.h"

@implementation TestSix

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)doTest{
//    [self smaphoreTask];
    NSLog(@"%@", [self smaphoreTaskOne].debugDescription); // 可能刚开始获取的数组为空，是因为数组里加数据时是异步操作
    
}


-(void)smaphoreTask{
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建信号量，并且设置值为10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 10; i++)
    {   // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);             // 每次发送信号则semaphore会+1，
            dispatch_semaphore_signal(semaphore);
        });
    }
}

/**可能刚开始获取的数组为空，是因为数组里加数据时是异步操作*/
-(nullable NSArray *)smaphoreTaskOne{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:0];
    // 创建一个信号
    dispatch_semaphore_t semaphore =  dispatch_semaphore_create(0);
    
        
    // 并行异步添加数据
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
        
        for (int i=0; i<10; i++) {
            [ary addObject:@(i)];
        }
        
    });
    
    // 发送一个信号，使信号的总量+1
    dispatch_semaphore_signal(semaphore);
    
    // 若信号的总量为0 ，则会阻塞当前线程使之一直等待下去，知道信号的总量>=1，才会返回一个完整的数组
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return ary;
}




-(void)smaphoreTask1{
//    __block BOOL isok = NO;
//    __weak TestSix *wSelf = self;
//    typeof(TestSix) *ws = self;
    
    [UIView animateWithDuration:1 animations:^{
        
    }];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
//    Engine *engine = [[Engine alloc] init];
//    [engine queryCompletion:^(BOOL isOpen) {
//        isok = isOpen;
//        dispatch_semaphore_signal(sema);
//    } onError:^(int errorCode, NSString *errorMessage) {
//        isok = NO;
//        dispatch_semaphore_signal(sema);
//    }];
    
    // 等待信号触发： 若信号sema的总量不为0则会执行这句代码后面的代码，否则，就会一直等待。这里，刚开始新浪sema的总量为0，故到这里后，就会阻塞当前线程不会执行下面打代码；只有当网络请求返回成功或失败时，才会发送一个信号使sema的总量+1，才会执行这句后面的代码
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    // 根据网络请求的结果来进行需要的处理
    MyLog(@"网络请求有返回了！");
    
    
}

@end


