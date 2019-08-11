//
//  TestOne.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试数组的一些修饰符下的使用情况、 引用计数
//  atomic nonatomic

#import "TestOne.h"


@interface TestOne ()
/// atomic只是gettet、setter方法加锁，其他操作会有线程安全问题
@property (atomic, copy) NSMutableArray *mAry; // 测试crash与解决
@property (atomic, assign) int number;
@property (nonatomic, strong) TestOne *tOne;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TestOne


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}




-(void)doTest{
    NSArray *ary = [NSArray array];
    
    [self testAtomicProperty];
//    [self updateNoMutableObject];
//    [self operateArray];
//    [self selfRetainCount];
}

/// 此时开2个子线程，分别执行+操作，由于atomic在运行时保证 set,get方法的原子性。 但由于self.number += 1;并不是原子操作，即会出现其中之一为2000或二者结果都不是2000的情况
// 所以仅仅使用atomic并不能保证线程安全。这里应该在forin里执行[self.lock lock]; self.number +=1;[self.lock unlock]
// 一个线程在连续多次读取某属性值的过程中有别的线程在同时改写该值，那么即便将属性声明为 atomic，也还是会读到不同的属性值
-(void)testAtomicProperty {
    
    int max = 5;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < max;i ++){
            self.number += 1;
            NSLog(@"线程1 ：%@, number : %d", [NSThread currentThread], self.number);
        }
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < max;i ++){
            self.number += 1;
            
            NSLog(@"线程2 ：%@, number : %d", [NSThread currentThread], self.number);
        }
//        NSLog(@"number : %d", self.number);
    });
    
}

-(void)testAtomicOther {
   // 0,
//    for (int i;i<999;i++) {
//        NSLog(@"----");
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
////            self.name = [[NSString alloc]init];
//            self.name = @"23";
//        });
//    }
    
    // 1. NSLock
//    NSLock *lock = [[NSLock alloc] init];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [lock lock];
////        NSLog(@"线程1");
//        self.name = @"111";
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [lock unlock];
//        });
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [lock lock];
//        self.name = @"222";
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [lock unlock];
//        });
//
//    });
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"1s 时那马=%@", self.name);
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"2s 时那马=%@", self.name);
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"3s 时那马=%@", self.name);
//    });

    // 2. dispatch_semaphore_t
//    dispatch_semaphore_t dsema = dispatch_semaphore_create(2);
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
//        self.name = @"a";
//        NSLog(@"1-----:%@", self.name);
//        dispatch_semaphore_signal(dsema);
//    });
//
//    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
//    self.name = @"b";
//    NSLog(@"2---:%@", self.name);
    // 会永远卡死
//    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
//    self.name = @"c";
//    NSLog(@"3---:%@", self.name);
    
    // 3. 定时器
//        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    // 必须用NSEC_PER_SEC，否则为纳秒
//    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0);
//
//    __weak TestOne *weakSelf = self;
//    dispatch_source_set_event_handler(self.timer, ^{
//        NSLog(@"获取到的name= %@", weakSelf.name);
//    });
//
////    dispatch_source_cancel(self.timer);
//    dispatch_resume(self.timer);
    
    // 4. 栅栏函数：dispatch_barrier_async, 保证和他同一个[并行队列]里且位于其前面的所有操作全部执行完毕后，才会执行其后面的操作
    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_SERIAL); // DISPATCH_QUEUE_CONCURRENT
    
    dispatch_async(queue, ^{
        NSLog(@"----1");
    });
    dispatch_async(queue, ^{
        NSLog(@"----2");
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"----barrier");
    });
    dispatch_async(queue, ^{
        NSLog(@"----3");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----a");
    });
    
}

/**测试修改不可变的字典、数组. 会crash*/
-(void)updateNoMutableObject{
    NSDictionary *dic = @{@"name": @"name"};
    [dic setValue:@"newName" forKey:@"name"];
}

/** 1. 测试对数组一些操作肯出现的问题 */
-(void)operateArray{
    // 用(nonatomic, copy)或(atomic, copy)，在运行时mAry的类型已变成NSArray了，而NSArray是没有addObject方法的，故在运行时就会crash
    
    // 1. 下面这句会立即crash。 原因是，通过copy修饰的property，若通过self.someArray ＝来赋值初始化，则是通过系统合成setter方法实现，由于设置copy修饰词，则返回实际上是不可变数组（NSArray）,当调用addObject 方法会报错。应改为_mAry = [NSMutableArray array];
    
    
    // 2.  _someArray是实例变量 参考TestFour，而此实例变量并没有 copy 修饰，指向的仍是定义的 NSMutableArray 类型。所以即使后面通过 self.someArray 使用 addObject 方法仍然可行，因为初始化赋值阶段获取的是NSMutableArray类型对象
//    self.mAry = [NSMutableArray array]; // 会crash
    _mAry = [NSMutableArray array]; // 因为NSArray遵循NSCopying协议
    
    [self.mAry addObject:@"1"];
    
    
    
}


/** 2. 测试引用计数*/
-(void)selfRetainCount{
//    self.tOne = self; // 此时self的引用计数会+1
//    self.tOne = [self copy]; // 此时会crash，因为自定义对象必须遵守NSCopying\NSMutableCopying协议，实现copyWithZone mutableCopyWithZone方法后，才可以copy
    self.tOne = [[TestOne alloc] init]; // 此时self的引用计数不会变，仍为1
    MyLog(@"TestOne的引用计数为： %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}


/**
 *  dealloc方法是在另一个线程中执行的，所以并不知道什么时候释放。故会造成打印的时候自己引用计数仍还不是0
 */
-(void)dealloc{
    MyLog(@"TestOne释放了！----TestOne的引用计数为： %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end


