//
//  TestThreeTypeBlock.m
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/14.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
/**
 我们对这个生成在栈上的block执行了copy操作，Block和__block变量均从栈复制到堆上。上面的代码，有跟没有copy，在非ARC和ARC下一个是stack一个是Malloc。这是因为ARC下默认为Malloc（即使如此，ARC下还是有一些例外，下面会讲）。
 block在ARC和非ARC下有巨大差别。多数情况下，ARC下会默认把栈block被会直接拷贝生成到堆上。那么，什么时候栈上的Block会复制到堆上呢？
 1.
 调用Block的copy实例方法时
 Block作为函数返回值返回时
 将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
 将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时
 2.
 block在ARC和非ARC下的巨大差别
 在 ARC 中，捕获外部了变量的 block 的类会是 NSMallocBlock 或者 NSStackBlock，如果 block 被赋值给了某个变量，在这个过程中会执行 _Block_copy 将原有的 NSStackBlock 变成 NSMallocBlock；但是如果 block 没有被赋值给某个变量，那它的类型就是 NSStackBlock；没有捕获外部变量的 block 的类会是 NSGlobalBlock 即不在堆上，也不在栈上，它类似 C 语言函数一样会在代码段中。
 在非 ARC 中，捕获了外部变量的 block 的类会是 NSStackBlock，放置在栈上，没有捕获外部变量的 block 时与 ARC 环境下情况相同。
 3.
 Block的复制: 不管block配置在何处，用copy方法复制都不会引起任何问题。在ARC环境下，如果不确定是否要copy这个block，那尽管copy即可。
 在全局block调用copy什么也不做
 在栈上block调用copy那么复制到堆上
 在堆上block调用copy, block引用计数增加
 
 在 ARC 开启的情况下，除非上面的例外，默认只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock 类型的 block。
 */

#import "TestThreeTypeBlock.h"
#import "Global.h"


@interface TestThreeTypeBlock()
@property (nonatomic, copy) NSString *name;
@end

@implementation TestThreeTypeBlock


-(void)doTest {
    
    __weak typeof(TestThreeTypeBlock*) wself = self;
    
    //----- NSGlobalBlock(全局block) -----//
    // 1. 全局定义的block类型为NSGlobalBlock(全局block),可以看出此时的block永远为全局NSGlobalBlock
    // 1.0
//    TTTGlobalBlock(@"q124");
    // 1.1
//    NSString *str = @"aesfgt";
//    TTTGlobalBlock(str);
    // 1.2
//    self.name = @"asefg12";
//    TTTGlobalBlock(self.name);

    // 1.3
//    TTTGlobalBlock(staticString); 
    
    // 2. block为某类的属性，但是在block内部 不捕获传进来的参数，此时block类型仍为NSGlobalBlock
    // 2.0
//    self.blcok = ^NSString *(NSString *nouseParam) {
//        return @"全局block，不捕获传进来的参数";
//    };
    // 2.1
//    self.blcok = ^NSString *(NSString *nouseParam) {
//        return nouseParam;
//    };
//    self.blcok(@"直接传入");
    // 2.2
//    NSString *str = @"wesft";
//    self.blcok = ^NSString *(NSString *param) {
//        return param;
//    };
//    self.blcok(str);
    // 2.3
//    self.name = @"self-name";
//    self.blcok = ^NSString *(NSString *param) {
//        return param;
//    };
//    self.blcok(self.name);
    
    // 2.4. 局部声明的block，但是在block内部 不捕获 传进来的局部变量，此时block类型为NSGlobalBlock(全局block)
    //    NSString *str = @"0-sef";
    //    typedef void (^blk_t)(NSString *);
    //    blk_t block = ^(NSString *p){
    //        NSLog(@"blk0:%@", p);
    //    };
    //    block(str);
    
    
    //---- NSMallocBlock(堆block) ------//
    // 3. block为某类的属性，但是在block内部捕获传进来的变量，则此时block类型NSMallocBlock(堆block)
//    NSString *str = @"wesft";
//    self.blcok = ^NSString *(NSString *param) {
//        wself.name = param;
//        wself.name = globalstr;
//        return @"";
//    };
//    self.blcok(str);
    
    
    // 5. 局部声明的block，但是在block内部 捕获了传进来的变量，此时block类型为NSMallocBlock(堆block)
    NSString *str = @"0-sef";
    typedef void (^blk_t)(NSString *);
    blk_t block = ^(NSString *p){
//        wself.name = p;
        wself.name = globalStr;
    };

    block(str);
    blk_t cBlock = [block copy];
    cBlock(@"4");
    
}

@end



