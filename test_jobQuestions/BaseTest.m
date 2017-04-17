//
//  BaseTest.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "BaseTest.h"

// 3. 此时声明的变量、方法  都是私有的
@interface BaseTest ()

@property (nonatomic, assign) BOOL isOld;
-(void)stopAnimate; // 一定要记着实现
@end

@implementation BaseTest
/*交给子类实现*/
-(void)doTest{

}

-(void)startAnimate{

}

-(void)stopAnimate{

}

@end
