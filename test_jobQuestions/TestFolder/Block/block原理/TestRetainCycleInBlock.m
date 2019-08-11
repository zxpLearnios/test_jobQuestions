//
//  TestRetainCycleInBlock.m
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/2.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
//  block里的循环引用

#import "TestRetainCycleInBlock.h"

@implementation TestRetainCycleInBlock

@end


@implementation TestRetainCycleInBlockA

-(void)doTest {
    self.name = @"测试block里的循环引用";
    __weak TestRetainCycleInBlockA *weakself = self;
    self.block = ^{
        MyLog(@"%@", weakself.name);
    };
    
}

-(void)dealloc {
    MyLog(@"TestRetainCycleInBlockA----dealloc");
}

@end
