//
//  TestThree.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/30.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  多线程

// NSOperationqueue加dispatch_semaphore_t 就可以实现（不同优先级队列的执行，以及各个队列进行网络请求时返回结果的先后顺序不一定与队列的优先级顺序一样，故须用二者结合来实现）
/*  1.  dispatch_group_notify(group, queue, ^{ }) 解释：将任务加入到了队列queue中执行，然后队列和group关联当队列queue上任务执行完毕时group会进行同步;        当队列dispatch_queue_t queue上的所有任务执行完毕时会执行dispatch_group_notify里的dispatch_block_t block的代码。若queue里执行的是同步操作，则会在queue里的操作完成后来执行dispatch_group_notify里的block； 若queue里执行的为异步操作，则有时 会在queue里的异步操作完成前就调用dispatch_group_notify，并执行dispatch_group_notify里的block。 dispatch_group_notify(group, queue, ^{ }) 里的block的执行，与它的放置顺序【在【dispatch_group_enter  dispatch_group_leave】块外前、块中、块外后】无关，但为了规范最好还是别放在中间 --->具体请参看第二组情况:

// 2. dispatch_group_enter(group) dispatch_group_leave(group).  和内存管理的引用计数类似，我们可以认为group也持有一个整形变量(只是假设)，当调用enter时计数加1，调用leave时计数减1，当计数为0时会调用dispatch_group_notify并且dispatch_group_wait会停止等待；


// 4、dispatch_group_wait:  long dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);  和dispatch_group_notify功能类似(多了一个dispatch_time_t参数可以设置超时时间)，在group上任务完成前，dispatch_group_wait会阻塞当前线程(所以不能放在主线程调用)一直等待；当group上任务完成，或者等待时间超过设置的超时时间会结束等待；

//  5. dispatch_group_async ：  将一个block(代码块)加入到dispatch_queue_t queue中并和dispatch_group_t group相关联。 void dispatch_group_async(dispatch_group_t group,dispatch_queue_t queue,dispatch_block_t block); 将代码块dispatch_block_t block放入队列dispatch_queue_t queue中执行；并和调度组dispatch_group_t group相互关联；如果dispatch_queue_t queue中所有的block执行完毕会调用dispatch_group_notify并且dispatch_group_wait会停止等待；
// 参考： http://www.jianshu.com/p/228403206664


//  6. 全局队列时并行队列，和并行队列的属性完全一样，故执行异步操作时，需要看操作的复杂度，越复杂的越靠后完成

//  7. 在GCD中你可以使用dispatch_set_target_queue()函数为你自己创建的队列指定优先级，
//    dispatch_set_target_queue(<#dispatch_object_t  _Nonnull object#>, <#dispatch_queue_t  _Nullable queue#>), 不过还不如用NSOperationQueue呢
// 8. NSOperation是一个抽象的类，不具备封装操作的能力，必须使用其子类。 NSOperation默认是同步执行的。
 
// NSOperationqueue加dispatch_semaphore_t 就可以实现（不同优先级队列的执行，以及各个队列进行网络请求时返回结果的先后顺序不一定与队列的优先级顺序一样，故须用二者结合来实现）
// 9. 多线程编程技术的优缺点比较

NSThread (抽象层次：低)
优点：轻量级，简单易用，可以直接操作线程对象
缺点: 需要自己管理线程的生命周期，线程同步。线程同步对数据的加锁会有一定的系统开销。
Cocoa NSOperation (抽象层次：中)
优点：不需要关心线程管理，数据同步的事情，可以把精力放在学要执行的操作上。基于GCD，是对GCD 的封装，比GCD更加面向对象
缺点: NSOperation是个抽象类，使用它必须使用它的子类，可以实现它或者使用它定义好的两个子类NSInvocationOperation、NSBlockOperation.
GCD 全称Grand Center Dispatch (抽象层次：高)

优点：是 Apple 开发的一个多核编程的解决方法，简单易用，效率高，速度快，基于C语言，更底层更高效，并且不是Cocoa框架的一部分，自动管理线程生命周期（创建线程、调度任务、销毁线程）。
缺点: 使用GCD的场景如果很复杂，就有非常大的可能遇到死锁问题。

GCD抽象层次最高，使用也简单，因此，苹果也推荐使用GCD

*/



#import "TestThree.h"

// enum用来定义一系列宏定义常量区别用，相当于一系列的#define xx xx，当然它后面的标识符也可当作一个类型标识符。
//enum GlobalQueueFlags{
//    GlobalQueueFlagsHigh = 0,
//    GlobalQueueFlagsDefault,
//    GlobalQueueFlagsLow,
//    GlobalQueueFlagsBackground
//};

typedef enum : NSUInteger {
    GlobalQueueFlagsHigh = 0,
    GlobalQueueFlagsDefault,
    GlobalQueueFlagsLow,
    GlobalQueueFlagsBackground
} GlobalQueueFlags;

@implementation TestThree

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)doTest{
//    [self testOperateQueue];
//    [self testDelay];
//    [self testOperateGroup];
    [self testGcdGroupCrashAndOther];
}

-(void)testOperateQueue {
    
    dispatch_queue_t mainqueue =  dispatch_get_main_queue();
    
    MyLog(@"mainqueue--sync0");
    // 1. 直接卡死
//    dispatch_sync(mainqueue, ^{
//        MyLog(@"mainqueue--sync1");
//    });
//    dispatch_sync(mainqueue, ^{
//        MyLog(@"mainqueue--sync2");
//    });
    
    // 2. 串行队列--异步操作  会新开线程，各操作顺序执行
    dispatch_async(mainqueue, ^{
        MyLog(@"mainqueue--async3");
    });
    dispatch_async(mainqueue, ^{
        for (int i=0; i<199991; i++) {
            MyLog(@"mainqueue--async1");
        }
    });
    dispatch_async(mainqueue, ^{
        MyLog(@"mainqueue--async2");
    });
    
}

/**
 *  测试GCD里的2种延迟：dispatch_after 和 dispatch_walltime
 */
-(void)testDelay{
    
//   1. 在GCD中我们使用dispatch_after()获取的是当前设备的时间，如果设备休眠了（进入后台只是挂起了不叫休眠）那么它也就休眠了。来延迟执行队列中的任务，它不会阻塞当前任务。等到延迟时间到了就会执行延迟块中的任务。 NSEC_PER_SEC: 10亿纳秒即 1s = 10亿ns
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        MyLog(@"dispatch_after---dispatch_after---%@", [NSThread currentThread]);
//    });
//    
//    MyLog(@"测试dispatch_after延迟");
    
    // 2. dispatch_walltime 后者去的是挂钟的时间，也就是绝对时间，即使设备休眠了，它也不会被当前设备的状态而左右的。
    int64_t delayTime = (int)3 * (double)NSEC_PER_SEC; // 需要延迟的时间s
    double timeInterval = [NSDate date].timeIntervalSince1970;
    struct timespec ts;
    ts.tv_sec = timeInterval;
    ts.tv_nsec = 0 * NSEC_PER_SEC;
    dispatch_time_t time = dispatch_walltime(&ts, delayTime);
    dispatch_after(time, dispatch_get_main_queue(), ^{
            MyLog(@"dispatch_walltime----%@", [NSThread currentThread]);
    });
    MyLog(@"测试dispatch_walltime延迟");
    
    // 3.  在GCD中你可以使用dispatch_set_target_queue()函数为你自己创建的队列指定优先级，
//    dispatch_set_target_queue(<#dispatch_object_t  _Nonnull object#>, <#dispatch_queue_t  _Nullable queue#>)
    
    
}


/**
 *  着重测试wait。 注释掉wait后打印结果为 hahahahahahaha--1--2--0--group里的一句执行完毕！有wait时打印结果为 --1--0--hahahahahahaha--2---group里的一句执行完毕！多次更换外wait的位置，得知：wait的意思为，
 */
-(void)testOperateGroup{
    // 全局队列是并行队列，故它的同步、异步操作和并行队列一样，同步操作时不会造成死锁
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); // 而flag作为保留字段备用（一般为0）
    
    dispatch_group_t group = dispatch_group_create();
    
//    NSLog(@"queue= %@，queue1=%@", queue, queue1);
    
    // 1.
    dispatch_group_async(group, queue1, ^{ // 会 自动关联队列与任务组
        [NSThread sleepForTimeInterval:1];
        NSLog(@"----%@---0", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2]; // 相当于阻塞当前线程
        NSLog(@"----%@---1", [NSThread currentThread]);
    });
    
    // 1.1
    dispatch_sync(queue, ^{ // 会在hahahaha之前打印
        NSLog(@"----%@---2", [NSThread currentThread]);
    });
    
    // 等待dispatch_group_notify里的 block执行完毕，也可以设置超时参数，如果dispatch_group_wait函数的返回值不为零，说明group内处理未结束，否则为零
    // 2.
//    dispatch_group_async(group, queue1, ^{
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"----%@---2", [NSThread currentThread]);
//    });
    
    // 3. 和dispatch_group_notify功能类似(多了一个dispatch_time_t参数可以设置超时时间)，在group上任务完成前，dispatch_group_wait会阻塞当前线程(所以不能放在主线程调用)一直等待；当group上任务完成，或者等待时间超过设置的超时时间会结束等待。
    // 若用1.1 和3. 结果为--1---hahahaha---group里的一句执行完毕，说明不管group里有无操作，wait的作用都是先阻塞当前线程执行wait位置前面的操作，然后再执行dispatch_group_notify里的block
    // 若用1. 和3. 结果为： hahahah-----1-----0(除非wait里的时间为一个>=10几亿的数字或DISPATCH_TIME_FOREVER，否则的话，haha都有可能会被第一个被打印；若时间不是太大会出现先打印--2而后再打印hahahha 即顺序并无规律。 得知此种情况下，wait并不能很好的发挥作用)。 故若要使用wait最好将时间DISPATCH_TIME_FOREVER
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // DISPATCH_TIME_FOREVER， 时间必须得超大才可以达到阻塞的目的
    NSLog(@"在dispatch_group_wait之后的");
    
    // 将queue换成dispatch_get_main_queue 即可得知，dispatch_group_notify的作用是：当与group相关联的所有队列（不一定含有当前这个queue）里的操作都执行完毕，才会调用此函数，故会造成此参数不同（主队列、子队列）时打印内容不同.然后，在一个新的queue（不一定是这个传入的queue）里执行block.
//     当传入的queue ！= dispatch_get_main_queue时，结果不太符合期望
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ //
            NSLog(@"group里的一句执行完毕！, %@",  [NSThread currentThread]);
    });
    NSLog(@"hahahahahahaha");
    NSLog(@"99999");
    NSLog(@"22222222");
    
}

/**
 *  测试GCD的组group 以及执行顺序。手动关联队列与任务组用那个enter、leave
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

    // 0. 第零组： 会立即crash掉。信号量的数值溢出，从而进入了Crash分支。因为进入组和离开组必须成对出现, 否则会造成死锁.  病不能保证网络请求
//    dispatch_group_leave(group);
    
//    // 1. 第一组情况  打印结果为 ---1---2---3; 与第二组类似
//    dispatch_group_async(group, queue, ^{ // 提交一个block块到queue里执行，
//        // 执行请求1... （这里的代码需要时同步执行才100%的能达到预期效果，与第二组类似）
//        dispatch_sync(queue, ^{
//            MyLog(@"----------2");
//        });
//    });
//    dispatch_group_async(group, queue, ^{
//        // 执行请求2...
//        dispatch_async(queue, ^{
////            sleep(2);
//            MyLog(@"----------3");
//        });
//    });
//
//    // 这句放到前、中、后不影响结果
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        MyLog(@"全部请求执行完毕!");
//    });
   // 当dispatch_group_async的block里面执行的是异步任务，如果还是使用上面的方法你会发现 有时异步任务还没跑完就已经进入到了dispatch_group_notify方法里面了，类似于第二组的
    
    
    // 1. 第二组情况:  若queue执行的是同步操作则结果一定为--1--3--2；若queue里执行的是异步操作，则结果大部分为--1--3--2 有时为--1--2--3。由此得知，此种情况并不能100%的保证让queue的所有操作都执行完毕了，才会去执行dispatch_group_notify力的操作。
    // 进入组和离开组必须成对出现, 否则会造成死锁。 dispatch_group_notify放在【dispatch_group_enter  dispatch_group_leave】块外前、块中、块外后，结果都一样
   
    // dispatch_group_notify放在块外前、块中、块外后 结果都一样
    
//    dispatch_group_enter(group);
//
//    dispatch_group_notify(group, queue, ^{ // 这句代码的放置顺序 不会影响到最终的结果
//        MyLog(@"---------2");
//    });
//
//     //同步
//    dispatch_sync(queue, ^{
//        MyLog(@"----------4"); // -----4
//    });
//
//     // 异步
//    dispatch_async(queue, ^{
//        // 这里的延时，仍被看作立即执行成功了
////        [NSThread sleepForTimeInterval:2];
//        MyLog(@"---------3");
//    });
//
//    dispatch_group_async(group, queue, ^{ // block里若执行的是异步请求，有时可能达不到预期效果，即可能不等group里所有的任务都执行完毕就会调用dispatch_group_notify了，
//
//        // 这里的延时，是有效的
//        [NSThread sleepForTimeInterval:3];
//        MyLog(@"----------33");
//
//    });
//
//    dispatch_group_leave(group);
    
//    // 1.1  dispatch_group_leave 必须写在具体的操作执行完之后的地方
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:2];
//        MyLog(@"11111");
//        dispatch_group_leave(group);
//    });
//
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:1];
//        MyLog(@"22222");
//        dispatch_group_leave(group);
//    });
//
//
//    dispatch_group_notify(group, queue, ^{ // 这句代码的放置顺序 不会影响到最终的结果
//        MyLog(@"执行结束");
//    });
    
    // 1.2  多个queue加入同一个group
//    const char queue1Name = [@"queue1Name" UTF8String];
//    dispatch_queue_t queue1 =  dispatch_queue_create(queue1Name, DISPATCH_QUEUE_CONCURRENT);
//    
////    dispatch_group_enter(group);
////    dispatch_async(queue, ^{
////        [NSThread sleepForTimeInterval:2];
////        MyLog(@"queue----11111");
////        dispatch_group_leave(group);
////    });
////
////    dispatch_group_enter(group);
////    dispatch_async(queue, ^{
////        [NSThread sleepForTimeInterval:1];
////        MyLog(@"queue---22222");
////        dispatch_group_leave(group);
////    });
//    
//    
//    
//    dispatch_group_notify(group, queue, ^{ // 这句代码的放置顺序 不会影响到最终的结果
//        MyLog(@"执行结束");
//    });

    
    
//

    // 2. 第三组情况：【dispatch_group_enter  dispatch_group_leave】块里的dispatch_group_async和dispatch_async也可以和dispatch_group_notify一样放在块外前、块中、块外后，不影响结果
  
//    dispatch_group_enter(group);
//
//    dispatch_async(queue, ^{ // 打印 --1--3--2
//            MyLog(@"----------3");
//    });
//
//    dispatch_group_async(group, queue, ^{ // 打印 --1--2--3, 因为有延迟，哪怕是一点点的延迟
//        // 执行异步任务, 用延迟来模拟
////        MyLog(@"----------4");
//       dispatch_async(queue, ^{
////           [self virtual];
//
//           MyLog(@"----------44");
//       });
//    });
//
//    dispatch_group_leave(group);
//
//    // 若这里用这句而注释掉下面那句，则会由于此是异步操作，故其即可能会在主线程阻塞前还没被执行完就触发 dispatch_group_notify，
//    dispatch_group_async(group, queue, ^{ // 打印 --1--2--3, 因为有延迟，哪怕是一点点的延迟
//        // 执行异步任务, 用延迟来模拟
//        [self virtual];
//    });
//
//    // 使用dispatch_group_notify,增加监听，当group内的block全部执行完时，再执行该函数指定的block
//
//    dispatch_group_notify(group, queue, ^{ // dispatch_get_main_queue()  queue
//        MyLog(@"---------2");
//    });
//
//
//    // 3. 这里会立即造成死锁，故 --4--5不会被打印
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

//---------------------------- public ---------------------------//
/**
 * 创建串行队列，传入队列名字
 */
-(dispatch_queue_t)creatSerialQueue:(NSString *)name{

    const char *queueName = [name UTF8String];
     dispatch_queue_t queue =  dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    return queue;
}

/**
 * 创建并行队列，传入队列名字
 */
-(dispatch_queue_t)creatConcurrentQueue:(NSString *)name{
    const char *queueName = [name UTF8String];
    dispatch_queue_t queue =  dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    
    return queue;
}

/**
 * 创建全局队列，传入队列的优先级
 */
-(dispatch_queue_t)creatGlobalQueue:(GlobalQueueFlags)flag{
    long identify = 1010; // 标识
    
    dispatch_queue_t queue;
    int number = -1;
    switch (flag) {
        case GlobalQueueFlagsHigh:
            number = DISPATCH_QUEUE_PRIORITY_HIGH;
            break;
        case GlobalQueueFlagsDefault:
            number = DISPATCH_QUEUE_PRIORITY_DEFAULT;
            break;
            
        case GlobalQueueFlagsLow:
            number = DISPATCH_QUEUE_PRIORITY_LOW;
            break;
            
        default:
            number = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
            break;
    }
    
    queue =  dispatch_get_global_queue(identify, number);
    
    return queue;
}

@end
