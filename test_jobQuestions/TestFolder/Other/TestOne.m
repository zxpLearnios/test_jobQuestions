//
//  TestOne.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试数组的一些修饰符下的使用情况、 引用计数

#import "TestOne.h"

@interface TestOne ()

@property (atomic, copy) NSMutableArray *mAry; // 测试crash与解决
@property (nonatomic, strong) TestOne *tOne;



@end

@implementation TestOne


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}




-(void)doTest{
    NSArray *ary = [NSArray array];
    
    [self updateNoMutableObject];
//    [self operateArray];
//    [self selfRetainCount];
}

/**测试修改不可变的字典、数组*/
-(void)updateNoMutableObject{
    NSDictionary *dic = @{@"name": @"name"};
    [dic setValue:@"newName" forKey:@"name"];
}

/** 1. 测试对数组一些操作肯出现的问题 */
-(void)operateArray{
    // 用(nonatomic, copy)或(atomic, copy)，在运行时mAry的类型已变成NSArray了，而NSArray是没有addObject方法的，故在运行时就会crash
    
    // 1. 下面这句会立即crash。 原因是，通过copy修饰的property，若通过self.someArray ＝来赋值初始化，则是通过系统合成setter方法实现，由于设置copy修饰词，则返回实际上是不可变数组（NSArray）,当调用addObject 方法会报错。应改为_mAry = [NSMutableArray array];
    
    
    // 2.  _someArray是实例变量 参考TestFour，而此实例变量并没有 copy 修饰，指向的仍是定义的 NSMutableArray 类型。所以即使后面通过 self.someArray 使用 addObject 方法仍然可行，因为初始化赋值阶段获取的是NSMutableArray类型对象
//    self.mAry = [NSMutableArray array]; // 会crash
    _mAry = [NSMutableArray array]; // 因为NSArray遵循NSCopying协议
    
    [self.mAry addObject:@"1"];
    
    
    
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
    MyLog(@"TestOne释放了！----TestOne的引用计数为： %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end
