//
//  TestSix.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  信号量---------> 实现GCD线程同步

/***
 
// 0.  NSOperationqueue加dispatch_semaphore_t 就可以实现（不同优先级队列的执行，以及各个队列进行网络请求时返回结果的先后顺序不一定与队列的优先级顺序一样，故须用二者结合来实现）
 
 1. 解释信号量：  信号量就是一个资源计数器，对信号量有两个操作来达到互斥，分别是P和V操作。 一般情况是这样进行临界访问或互斥访问的： 设信号量值为1， 当一个进程1运行是，使用资源，进行P操作，即对信号量值减1，也就是资源数少了1个。这是信号量值为0。系统中规定当信号量值为0时，必须等待，直到信号量值不为零才能继续操作。 这时如果进程2想要运行，那么也必须进行P操作，但是此时信号量为0，所以无法减1，即不能P操作，也就阻塞。这样就到到了进程1 排他访问。 当进程1运行结束后，释放资源，进行V操作。资源数重新加1，这时信号量的值变为1. 这时进程2发现资源数不为0，信号量能进行P操作了，立即执行P操作。信号量值又变为0.此时进程2占有资源，排他访问资源。 这就是信号量来控制互斥的原理.  pv是荷兰语好像，p是表示通过 ，v表示阻塞，p对信号进行减一操作
 
 2. 简单来讲 信号量为0则阻塞当前线程，大于0则不会阻塞。则我们通过改变信号量的值，来控制是否阻塞当前线程，从而达到线程同步。
 3. 当然在NSoperation下可以直接设置并发数，就没有这么麻烦了
 
 4. GCD的时候如何让线程同步：线程同步即多个线程在一条线上上顺序执行
         1.dispatch_group
         2.dispatch_barrier
         3.dispatch_semaphore
 
 5.  NSOperation和GCD如何选择
 经过以上分析，我们大概对 NSOperation 和 GCD 都有了比较详细的了解，同时在亲自运用这两者的过程中有了自己的理解。
 
 GCD以 block 为单位，代码简洁。同时 GCD 中的队列、组、信号量、source、barriers 都是组成并行编程的基本原语。对于一次性的计算，或是仅仅为了加快现有方法的运行速度，选择轻量化的 GCD 就更加方便。
 
 而 NSOperation 可以用来规划一组任务之间的依赖关系，设置它们的优先级，任务能被取消。队列可以暂停、恢复。NSOperation 还可以被子类化。这些都是 GCD 所不具备的。
 
 所以我们要记住的是：
 NSOperation 和 GCD 并不是互斥的，有效地结合两者可以开发出更棒的应用
 
 GCD进阶
 NSOperation 有自己独特的优势，GCD 也有一些强大的特性。接下来我们由浅入深，讨论以下几个部分：
 
 dispatch_suspend 和 dispatch_resume
 dispathc_once
 dispatch_barrier_async
 dispatch_semaphore
 dispatch_suspend和dispatch_resume
 我们知道NSOperationQueue有暂停(suspend)和恢复(resume)。其实GCD中的队列也有类似的功能。用法也非常简单：
 dispatch_suspend(queue) //暂停某个队列
 dispatch_resume(queue)  //恢复某个队列
 这些函数不会影响到队列中已经执行的任务，队列暂停后，已经添加到队列中但还没有执行的任务不会执行，直到队列被恢复。
 
 dispathc_once
 首先我们来看一下最简单的 dispathc_once 函数，这在单例模式中被广泛使用。
 
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
    [self smaphoreTask];
//    [self smaphoreTask1]; // smaphoreTask2
//    NSLog(@"%@", [self smaphoreTaskOne].debugDescription); // 可能刚开始获取的数组为空，是因为数组里加数据时是异步操作
    
}


-(void)smaphoreTask{
    // 1.
    // 创建队列组
////     创建信号量，并且设置值为10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1); // 17.9.1测试时发现 信号量 >= 循环次数时，都会crash
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 这个时
//    for (int i = 0; i < 10; i++)
//    {   // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
////        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 这个时间参数。好像是
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%i",i);
//            sleep(2);             // 每次发送信号则semaphore会+1，
////            dispatch_semaphore_signal(semaphore);
//        });
//    }
    
    // 2.
//    int data = 3;
//    __block int mainData = 0;
//    __block dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
//    
//    dispatch_async(queue, ^(void) {
//        
//        int sum = 0;
//        
//        for(int i = 0; i < 5; i++){
//            sum += data;
//            NSLog(@" >> Sum: %d", sum);
//        }
//        dispatch_semaphore_signal(sem);
//    });
//    
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    for(int j=0;j<5;j++){
//        mainData++;
//        NSLog(@">> Main Data: %d",mainData);
//    }
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
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
//    Engine *engine = [[Engine alloc] init];
//    [engine queryCompletion:^(BOOL isOpen) {
//        isok = isOpen;
//        dispatch_semaphore_signal(sema);
//    } onError:^(int errorCode, NSString *errorMessage) {
//        isok = NO;
//        dispatch_semaphore_signal(sema);
//    }];
    
    // 等待信号触发： 若信号sema的总量不为0则会执行这句代码后面的代码，否则，就会一直等待。这里，刚开始新浪sema的总量为0，故到这里后，就会阻塞当前线程不会执行下面打代码；只有当网络请求返回成功或失败时，才会发送一个信号使sema的总量+1，才会执行这句后面的代码
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER); // DISPATCH_TIME_FOREVER
    
    // 根据网络请求的结果来进行需要的处理
    MyLog(@"网络请求有返回了！");
    dispatch_semaphore_signal(sema);
    
    
}


-(void)smaphoreTask2{
    dispatch_semaphore_t signal = dispatch_semaphore_create(0); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后，会执行其后的语句
    // 若信号创建时位0，延迟3s，则3s后会重新发送信号，使信号量+1；时间参数有用
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);  // DISPATCH_TIME_FOREVER
    
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        // dispatch_semaphore_wait这个函数会使传入的信号量的值减1
        dispatch_semaphore_wait(signal, overTime); //signal 值-1
        NSLog(@"线程1");
        
        // dispatch_semaphore_signal这个函数会使传入的信号量的值+1；
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });

}

@end


