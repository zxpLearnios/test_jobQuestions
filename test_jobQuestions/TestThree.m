//
//  TestThree.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/30.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  多线程


//  1. dispatch_group_notify(group, queue, ^(block)). 将代码块dispatch_block_t block放入队列dispatch_queue_t queue中执行；并和调度组dispatch_group_t group相互关联；如果dispatch_queue_t queue中所有的block执行完毕会调用dispatch_group_notify并且dispatch_group_wait会停止等待；
// 2. dispatch_group_enter(group) dispatch_group_leave(group).  和内存管理的引用计数类似，我们可以认为group也持有一个整形变量(只是假设)，当调用enter时计数加1，调用leave时计数减1，当计数为0时会调用dispatch_group_notify并且dispatch_group_wait会停止等待；
// 3. void dispatch_group_notify(dispatch_group_t group,dispatch_queue_t queue, dispatch_block_t block); 当队列dispatch_queue_t queue上的所有任务执行完毕时会执行dispatch_group_notify里的dispatch_block_t block的代码
// 4、dispatch_group_wait:  long dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);  和dispatch_group_notify功能类似(多了一个dispatch_time_t参数可以设置超时时间)，在group上任务完成前，dispatch_group_wait会阻塞当前线程(所以不能放在主线程调用)一直等待；当group上任务完成，或者等待时间超过设置的超时时间会结束等待；



#import "TestThree.h"

@implementation TestThree

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)doTest{
//    [self testOperateGroup];
    [self testGcdGroupCrashAndOther];
}

/**
 *  测试。 打印结果为 hahahahahahaha--1--2--0--group里的一句执行完毕！
 */
-(void)testOperateGroup{
    // 全局队列是并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"-------0");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"-------1");
    });
    
    
    // 等待group关联的block执行完毕，也可以设置超时参数，如果dispatch_group_wait函数的返回值不为零，说明group内处理未结束，否则为零
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"-------2");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"group里的一句执行完毕！");}
    );
    NSLog(@"hahahahahahaha");
    
}

/**
 *  测试GCD的组group 以及执行顺序
 */
-(void)testGcdGroupCrashAndOther{
    // 并行队列
    MyLog(@"--------1");
    
    NSDate *data = [NSDate date];
    NSString *dataStr = [data description];
    const char *queueName = [dataStr UTF8String];
    
    
    // 并行队列
    dispatch_queue_t queue =  dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();

    // 0. 第零组： 会立即crash掉。信号量的数值溢出，从而进入了Crash分支。因为进入组和离开组必须成对出现, 否则会造成死锁
//    dispatch_group_leave(group);
    
//    // 1. 第一组情况  打印结果为 ---1---2---3
//    dispatch_group_async(group, queue, ^{
//        // 执行请求1... （这里的代码需要时同步执行才能达到效果）
//    });
//    dispatch_group_async(group, queue, ^{
//        // 执行请求2...
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"全部请求执行完毕!");
//    });
   // 当dispatch_group_async的block里面执行的是异步任务，如果还是使用上面的方法你会发现异步任务还没跑完就已经进入到了dispatch_group_notify方法里面了，这时用到dispatch_group_enter和dispatch_group_leave就可以解决这个问题：
    
    // 1. 第二组情况:  结果为: --1--2--3 进入组和离开组必须成对出现, 否则会造成死锁。
//    dispatch_group_notify(group, queue, ^{ // 当group里的所有操作执行完毕时，再进入queue里执行当前的block里的操作。这句代码的放置顺序会直接影响到最终的打印结果
//        MyLog(@"---------2");
//    });
//    
//    dispatch_group_enter(group);
//    
//    dispatch_async(queue, ^{
//        MyLog(@"----------3");
//    });
//    
//    dispatch_group_leave(group);

    // 2. 第三组情况：
    dispatch_group_enter(group);
    
    // 若这里用这句而注释掉下面那句，则会由于此是异步操作，故其即可能会在主线程死锁前还没背执行完毕
    dispatch_group_async(group, queue, ^{ // 打印 --1--2--3, 因为有延迟，哪怕是一点点的延迟
        // 执行异步任务, 用延迟来模拟
        [self virtual];
    });
//        dispatch_async(queue, ^{ // 打印 --1--3--2
//            MyLog(@"----------3");
//        });
    
    dispatch_group_leave(group);
    // 使用dispatch_group_notify,增加监听，当group内的block全部执行完时，再执行该函数指定的block
    dispatch_group_notify(group, queue, ^{
        MyLog(@"---------2");
    });
    
    
    // 3. 这里会立即造成死锁，故 --4--5不会被打印
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        MyLog(@"----------4");
//    });
//    MyLog(@"----------5");
}

-(void)virtual{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        MyLog(@"用延迟模拟异步执行完毕！------3")
    });
    
}


@end
