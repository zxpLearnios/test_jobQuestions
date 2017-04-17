//
//  BaseTest.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTest : NSObject

/**交由子类去实现*/
-(void)doTest;
@end


// 1. 匿名类目 === 扩展, 此声明的变量都是对外可见的，
//  2. 在.h和.m里可以 同时都有此扩展，但最好不要这样写
@interface BaseTest ()
@property (nonatomic, assign) BOOL isNew;
-(void)startAnimate; // 一定要记着实现
@end
