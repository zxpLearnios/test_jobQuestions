//
//  TestLocks.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/8.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  参考： http://www.jianshu.com/p/8b8a01dd6356
/**
 1. usleep() 与sleep()类似，用于延迟挂起进程。进程被挂起放到reday queue。
     是一般情况下，延迟时间数量级是秒的时候，尽可能使用sleep()函数。
     如果延迟时间为几十毫秒（1ms = 1000us），或者更小，尽可能使用usleep()函数。这样才能最佳的利用CPU时间
 2.
 
 */

#import "TestLocks.h"
#import <PushKit/PushKit.h>

@implementation TestLocks

-(void)doTest{
    
    usleep(1);
    
}


@end
