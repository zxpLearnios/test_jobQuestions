//
//  TestOne.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试数组的一些修饰符下的使用情况、 引用计数

#import "TestOne.h"

@interface TestOne ()

@property (atomic, copy) NSMutableArray *mAry;
@property (nonatomic, strong) TestOne *tOne;

@end

@implementation TestOne

-(instancetype)init{
    self = [super init];
    if (self) {
        self.mAry = [NSMutableArray array];
    }
    return self;
}


-(void)doTest{
    
    //        [self operateArray];
    [self selfRetainCount];
}

/** 1. 测试对数组一些操作肯出现的问题 */
-(void)operateArray{
    // 用(nonatomic, copy)或(atomic, copy)，在运行时mAry的类型已变成NSArray了，而NSArray是没有addObject方法的，故在运行时就会crash
//    [self.mAry addObject:@"1"];
    
//    [self.mAry removeObjectAtIndex:0];
}

/** 2. 测试引用计数*/
-(void)selfRetainCount{
//    self.tOne = self; // 此时self的引用计数会+1
//    self.tOne = [self copy]; // 此时会crash，因为自定义对象必须遵守NSCopying\NSMutableCopying协议，实现copyWithZone mutableCopyWithZone方法后，才可以copy
    self.tOne = [[TestOne alloc] init]; // 此时self的引用计数不会变，仍为1
    MyLog(@"TestOne的引用计数为： %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}


/**
 *  dealloc方法是在另一个线程中执行的，所以并不知道什么时候释放。故会造成打印的时候自己引用计数仍还不是0
 */
-(void)dealloc{
    MyLog(@"TestOne释放了！");
    MyLog(@"TestOne的引用计数为： %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end
