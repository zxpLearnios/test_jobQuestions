//
//  TestBlock.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/12/24.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//  Block不允许修改外部变量的值，这里所说的外部变量的值，指的是栈中指针的内存地址,

#import "TestBlock.h"

@implementation TestBlock


/*
 “定义后”和“block内部”两者的内存地址是一样的，我们都知道 block 内部的变量会被 copy 到堆区，“block内部”打印的是堆地址，因而也就可以知道，“定义后”打印的也是堆的地址。
 那么如何证明“block内部”打印的是堆地址？
 把三个16进制的内存地址转成10进制就是：
 定义后前：6171559672
 block内部：5732708296
 定义后后：5732708296
 中间相差438851376个字节，也就是 418.5M 的空间，因为堆地址要小于栈地址，又因为iOS中一个进程的栈区内存只有1M，Mac也只有8M，显然a已经是在堆区了。
 这也证实了：a 在定义前是栈区，但只要进入了 block 区域，就变成了堆区。这才是 __block 关键字的真正作用。
 __block 关键字修饰后，int类型也从4字节变成了32字节，这是 Foundation 框架 malloc 出来的。这也同样能证实上面的结论。（PS：居然比 NSObject alloc 出来的 16 字节要多一倍）*/
-(void)doTest {
    __block NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
    NSLog(@"\n 定以前：------------------------------------\n\
          a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
    void (^foo)(void) = ^{
        a.string = @"Jerry";
        NSLog(@"\n block内部：------------------------------------\n\
              a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
        //        a = [NSMutableString stringWithString:@"William"];
    };
    foo();
    NSLog(@"\n 定以后：------------------------------------\n\
          a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
    
}

@end
