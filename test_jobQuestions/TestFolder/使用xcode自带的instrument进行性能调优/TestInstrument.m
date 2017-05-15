//
//  TestInstrument.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/15.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*  Instruments 进行性能测试与优化
 
 在开发中我一般是使用Xcode自带的instrument工具就够用了，它的快捷键是(commend+i),是自带的一个可以用来分析应用程序的性能，
 有三个功能在开发中经常用到，
 1、Leaks就可以检测内存泄漏,利用它可以看到全局的一个内存使用情况，也可以查看是否存在内存泄漏，是否存在野指针；
 2、是可以使用 Core Animation + Time Profiler 来评估图形性能，可以很直观的看到界面的性能是否良好。
 3、Time Profiler在应用程序开始运行后.我们可以看到不同的线程以及方法调用占用的时间，从而可以评估出 CPU 性能的瓶颈和找到优化方向。
 但在使用Xcode这个工具的时候有2个注意点：
 1.需要使用真机。因为手机的CPU,GPU和模拟器是有区别的，mac的Cpu是比手机快的，而模拟器要用CPU来模拟手机的GPU，这点模拟器是比不上手机的。
 2.应用程序运行一定要发布配置 而不是调试配置.，因为打包的时候，编译器会自动进行优化，比如去除调试符号或者移除并重新组织代码，还会引入"Watch Dog"[看门狗]机制，不同的场景下，“看门狗”会监测应用的性能，但在xcode的配置设置下，watch Dog会被禁用。
 
 */

#import "TestInstrument.h"

@implementation TestInstrument

@end
