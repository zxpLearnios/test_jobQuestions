//
//  TestNewKl.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "TestNewKl.h"


@interface TestNewKl ()
@property (nonatomic, copy) NSString *copyedStr;
@property (nonatomic, strong) NSString *strongStr;

@end

@implementation TestNewKl

-(void)doTest{
    [self two];
}


/** 1. 字符串用copy、strong修饰时的区别
 * 当源字符串是NSString时，由于字符串是不可变的，所以，不管是strong还是copy属性的对象，都是指向源对象，copy操作只是做了次浅拷贝。
 
 当源字符串是NSMutableString时，strong属性只是增加了源字符串的引用计数，而copy属性则是对源字符串做了次深拷贝，产生一个新的对象，且copy属性对象指向这个新的对象。另外需要注意的是，这个copy属性对象的类型始终是NSString，而不是NSMutableString，因此其是不可变的。
 
 这里还有一个性能问题，即在源字符串是NSMutableString，strong是单纯的增加对象的引用计数，而copy操作是执行了一次深拷贝，所以性能上会有所差异。而如果源字符串是NSString时，则没有这个问题
 */
-(void)one{
    NSString *string = [NSString stringWithFormat:@"abc"];
    
//    NSMutableString *string = [NSMutableString stringWithFormat:@"abc"];
    self.copyedStr = string;
    self.strongStr = string;
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", self.strongStr, &_strongStr);
    NSLog(@"copy string: %p, %p", self.copyedStr, &_copyedStr);
    

    
}


/** 2. 可变集合类 和 不可变集合类的 copy 和 mutablecopy有什么区别？如果是集合是内容复制的话，集合里面的元素也是内容复制么？
 *
 */
-(void)two{
    
    NSSet *set = [NSSet setWithArray:@[@"1", @"2"]];
    NSSet *cSet = [set copy]; // 结果为NSSet
    
    NSMutableSet *mcSet = [set mutableCopy]; // 结果为NSMutableSet
    MyLog(@"不可变集合 %@, copy后为%@，mutableCopy后为%@，", set.debugDescription, cSet.debugDescription, mcSet.debugDescription);
    
    NSMutableSet *mSet = [NSMutableSet setWithArray:@[@"11", @"22"]];
    NSSet *cmSet = [set copy];
    NSSet *mcmSet = [set mutableCopy];
    MyLog(@"可变集合 %@, copy后为%@，mutableCopy后为%@，", mSet.debugDescription, cmSet.debugDescription, mcmSet.debugDescription);
    
    
}




-(void)three{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:3];
    [ary addObject:@""];
}

@end
