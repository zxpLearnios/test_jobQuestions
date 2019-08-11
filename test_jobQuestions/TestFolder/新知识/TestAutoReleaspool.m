//
//  TestAutoReleaspool.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/27.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "TestAutoReleaspool.h"



@implementation TestAutoReleaspool

-(void)doTest{
    [self nilUseMemory];
//    [self releaseArray];
}

// 创建新对象时，首先调用`alloc`为对象分配内存空间，再调用`init`初始化对象，如`[[NSObject alloc] init]`；而`new`方法先给新对象分配空间然后初始化对象，因此`[NSObject new]`等同于`[[NSObject alloc] init]`；关于`allocWithZone`方法，官方文档解释该方法的参数是被忽略的，正确的做法是传nil或者NULL参数给它。
-(void)nilUseMemory{
    NSDictionary *dic = [NSDictionary copy];// 此句也可以ok // [[NSDictionary alloc] init]; // nil 此时由于未调用alloc故不会触发allocWithZone，从而不会分配内存   // p  dic
    
}


-(void)releaseArray{
    NSMutableArray *mAry = [NSMutableArray array];
    for (int i=0; i<80000000; i++) { 
       
        @autoreleasepool {
             NSString *str = @"000--";
            [mAry addObject:str];
        }
        
    }
}




@end
