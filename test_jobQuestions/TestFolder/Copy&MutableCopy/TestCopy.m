//
//  TestCopy.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/24.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试对可变对象 不可变对象的copy mutableCopy操作
/**
    1. copy：对所有对象（即使是可变对象）copy后，都是不可变对象
    2. mutableCopy：对所有对象（即使是不可变对象）mutableCopy后，都是可变对象。当然，若此时用不可变对象接收，则也可以
 */

#import "TestCopy.h"

@implementation TestCopy

-(void)doTest{
    
    // 1. 对NSArray的 copy&mutableCopy
//    NSArray *ary = [NSArray arrayWithObjects:@(0), @(1), @(2), nil];
//    NSArray *newAry = [ary copy]; // copy后仍是NSArray, 不可用NSMutableArray接收
//    NSMutableArray *newAry1 = [ary mutableCopy]; // copy后是NSMutableArray
//    [newAry1 addObject:@"sdgdfgdfg"];
    
    // 2.  对NSMutableArray的 copy&mutableCopy
    NSMutableArray *mAry = [NSMutableArray arrayWithObjects:@(0), @(1), @(2), nil];
    NSArray *newmAry = [mAry copy]; // copy后仍是NSArray, 不可用NSMutableArray接收
    NSMutableArray *newmAry1 = [mAry mutableCopy]; // copy后是NSMutableArray
    [newmAry1 addObject:@"sdgdfgdfg"];
    
}




@end

