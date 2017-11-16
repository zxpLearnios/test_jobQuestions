//
//  TestCopy.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/24.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试对可变对象 不可变对象的copy mutableCopy操作
/**  深拷贝、浅拷贝
    1. copy：对所有对象（即使是可变对象）copy后，都是不可变对象
    2. mutableCopy：对所有对象（即使是不可变对象）mutableCopy后，都是可变对象。当然，若此时用不可变对象接收，则也可以
    3. copyWithZone: 这种拷贝方式只能够提供一层内存拷贝(one-level-deep copy)，而非真正的深复制
 
 */

#import "TestCopy.h"

@implementation TestCopy


/** 深拷贝、浅拷贝的定义
 * 1、对不可变的非集合对象，copy是指针拷贝，mutablecopy是内容拷贝(NSString)
 2、对于可变的非集合对象，copy，mutablecopy都是内容拷贝(NSMutabelString)
 
 3、对不可变的数组、字典、集合等集合类对象，copy是指针拷贝，mutablecopy是内容拷贝
 4、对于可变的数组、字典、集合等集合类对象，copy，mutablecopy都是内容拷贝
 
 */

/**
 最后说个题外的东西，在搜集资料的过程中，发现一个有可能犯错的点
 1.NSString*str=@"string";
 2.str=@"newString";
 上面这段代码，在执行第二行代码后，内存地址发生了变化。乍一看，有点意外。按照C语言的经验，初始化一个字符串之后，字符串的首地址就被确定下来，不管之后如何修改字符串内容，这个地址都不会改变。但此处第二行并不是对str指向的内存地址重新赋值，因为赋值操作符左边的str是一个指针，也就是说此处修改的是内存地址。
 
 所以第二行应该这样理解：将@"newStirng"当做一个新的对象，将这段对象的内存地址赋值给str。
 */

//  深拷贝、浅拷贝操作后，所得的对象的类型
-(void)doTest{
    
    // 1. 对NSArray的 copy&mutableCopy
//    NSArray *ary = [NSArray arrayWithObjects:@(0), @(1), @(2), nil]; // 0x7fe5abd23390
//    NSArray *newAry = [ary copy]; // copy后仍是NSArray  0x7fe5abd23390, 不可用NSMutableArray接收
//    NSMutableArray *newAry1 = [ary mutableCopy]; // copy后是NSMutableArray  0x7fe5abd87de0
//    [newAry1 addObject:@"sdgdfgdfg"];
//    
//    // 2.  对NSMutableArray的 copy&mutableCopy
//    NSMutableArray *mAry = [NSMutableArray arrayWithObjects:@(0), @(1), @(2), nil]; // 0x7ffc9a422590
//    NSArray *newmAry = [mAry copy]; // copy后仍是NSArray 0x7ffc9a437f70, 不可用NSMutableArray接收
//    NSMutableArray *newmAry1 = [mAry mutableCopy]; // copy后是NSMutableArray  0x7ffc9a423530
//    [newmAry1 addObject:@"sdgdfgdfg"];
//    
//    NSMutableString *str = @"string"; // 换成NSString的话，给执行再次赋值会直接crash；若为NSMutableString，则不会，且再次赋值后，str 指针所指的对象的地址也会改变
//    str = @"newString";
    
    
    // 3. 集合元素进行深浅拷贝时，集合内部的元素是否也进行了深浅拷贝
    NSString *obj = @"000-";
    
    // 3.1 此时 不可变\可变 数组进行copy、mutableCopy，它里面的元素只进行浅拷贝
//    NSArray *objs = @[obj];
//    NSArray *cObjs = [objs copy];
//    NSMutableArray *mcObjs = [objs mutableCopy];
    
    NSMutableArray *objs = [NSMutableArray arrayWithObject:obj];
    NSArray *cObjs = [objs copy];
    NSMutableArray *mcObjs = [objs mutableCopy];
    
    
    // 3.2 此时 不可变\可变 数组进行copy、mutableCopy，它里面的元素只进行浅拷贝
//    NSArray *objs = [NSArray arrayWithObjects:obj, nil];
//    NSArray *cObjs = [objs copy];
//    NSMutableArray *mcObjs = [objs mutableCopy];
    
    //    NSMutableArray *objs = [NSMutableArray arrayWithObject:obj];
    //    NSArray *cObjs = [objs copy];
    //    NSMutableArray *mcObjs = [objs mutableCopy];
    
    
    // 3.3 对不可变数组进行归档，然后解档查看里面的元素.发现读取到的数组里面的元素的地址和原数组里面元素的地址不同，即此时进行了深拷贝\内容拷贝
    // 即对集合里面的元素实现深拷贝的方法有二钟： 归档、
    NSString *path = [[Const documentPath] stringByAppendingString:@"testCopy.plist"];
    [NSKeyedArchiver archiveRootObject:objs toFile:path];
    NSArray *unArchiveObjs =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSDictionary *dic = @{@"key": obj, @"key1": @"0"};
    NSDictionary *newDict = [[NSDictionary alloc] initWithDictionary:dic copyItems:YES];
    
    
    
    
    
    MyLog(@"原数组为：%@，copy后的数组为%@，mutableCopy后的数组为%@", objs.debugDescription, cObjs.debugDescription, mcObjs.debugDescription)
    
}




@end

