//
//  TestBlockReference.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  block的循环引用问题， 引用计数
/*
    1. 在arc中默认会将block从栈复制到堆上，而在非arc中，则需要手动copy.
 
 */

#import "TestBlockReference.h"

@interface TestBlockReference ()
@property (nonatomic, strong) NSString *type;
@end

@implementation TestBlockReference

-(void)doTest{
    
    
    // 0. 局部自动变量，在Block中只读。Block定义时copy变量的值，在Block中作为常量使用，所以即使变量的值在Block外改变，也不影响他在Block中的值。
//    int base = 100;
//    long (^sum)(int, int) = ^ long (int a, int b) {
//        return base + a + b;
//    };
//    base = 0;
//    NSLog(@"%ld\n", sum(1, 2));   // 这里输出是103，而不是3, 因为块内base为拷贝的常量 100
    
    
    
    TestBlockObject *bo = [[TestBlockObject alloc] init];
    bo.name = @"srgrgg"; // 访问对象的属性（包括block类型的属性），都不会造成引用计数+1
    
    // 1. 系统会自动提示，此时会造成循环引用
//    bo.voidBlock = ^(){
////        bo.name = @""; // 1. 只写此句 也会循环引用的
//        NSLog(@"%@", bo.name); // 2.
//        NSLog(@"TestBlockObject的引用计数为 %ld", CFGetRetainCount((__bridge CFTypeRef)(bo))); // 3.
//        // 只有bo的block里强引用了bo的（n个）属性，则执行完block后，bo的引用计数为3
//    };

    // 2. 此时是OK的
//    __block __weak typeof(bo) weakBo = bo; //(__block: 此对象可以在block内被修改，__weak：弱引用  typeof返回对象的类的类型)
//    bo.voidBlock = ^(){
//        weakBo.name = @"sssss";
//        NSLog(@"%@", weakBo.name);
//        NSLog(@"TestBlockObject的引用计数为 %ld", CFGetRetainCount((__bridge CFTypeRef)(weakBo))); // 用bo，执行完block后，bo的引用计数为2；用weakBo时，执行完block后，bo的引用计数为3
//    };

    // 3. 只有__weak 此时即在 延迟的情况下就会 有问题. 因为如果仅仅使用__weak去修饰变量，当别处把变量释放后，block中该变量也会被释放掉
//    __block __weak typeof(bo) weakBo = bo; //(__block: 此对象可以在block内被修改，__weak：弱引用  typeof返回对象的类的类型)
//    bo.voidBlock = ^(){
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            NSLog(@"%@", weakBo.name); // 打印null，而非 “srgrgg”，因为bo释放了
//        });
//    };
    
    // 4. __strong加__weak 解决在延迟的情况下的数据访问问题，保证所访问的数据始终有值. 将外部对bo对象的弱引用 weakBo在block内再进行强引用。 block执行完毕后bo会自动释放
//    __block __weak typeof(bo) weakBo = bo; //(__block: 此对象可以在block内被修改，__weak：弱引用  typeof返回对象的类的类型)
//    bo.voidBlock = ^(){
//        __strong typeof(bo) strongBo = weakBo;
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            NSLog(@"%@", strongBo.name); // 此时打印“srgrgg”，而非 null，因为block内部对bo强引用，bo不会被释放
//        });
//    };
    
    
    // 执行block
    if (bo.voidBlock != nil) {
        bo.voidBlock();
    }
    
}

-(void)dealloc{
    NSLog(@"TestBlockReference释放了");
}

@end

@implementation TestBlockObject
-(void)dealloc{
    NSLog(@"TestBlockObject释放了");
}

@end

