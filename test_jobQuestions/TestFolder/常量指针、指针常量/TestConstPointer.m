//
//  TestConstPointer.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/12/10.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//

#import "TestConstPointer.h"




@implementation TestConstPointer


-(void)doTest {
    int a = 11;
    // const 在谁前面谁就不可以改
    int * const p = &a;
    // *p 是一个整体
    (*p) ++;
//    p ++; // error
    
//    int const *p = &a;
//    *p = 22; // error
//    p ++;
    
    // 此时p *p 都不可改变了
//    const int * const p = &a;
}

@end
