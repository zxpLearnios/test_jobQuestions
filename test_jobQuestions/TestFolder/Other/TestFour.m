//
//  TestFor.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/30.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试atomic原子性访问修饰属性时，重写setter、getter方法

#import "TestFour.h"

@interface TestFour ()

@property (atomic, copy) NSString *string; // 测试重写setter、getter
@end

@implementation TestFour
@synthesize string = _string; // 用它来定义属性的实例变量名

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)doTest{
    
}


// 3.@synthesize @dynamic 。关键字的作用说明:@property 预编译命令（关键字）作用是声明属性的 getter和setter方法， @synthesize 生成属性访问器即 getter和setter方法。 @dynamic 禁止编译器生成 getter／setter，通过自定义或者在运行时动态创建绑定：主要使用在Core Data中。   atomic 是操作原子性，作为属性修饰词，则编译器生产的 getter／setter方法中存在 @synchronized(self)或者lock锁机制只允许原子性访问。 若只自定义一个属性访问器（setter／getter中一个），会出现warning：writable atomic property ‘name’ cannot pair a synthesized getter with … 若两个都定义，则需要 @synthesize name = _name; 两个都自定义的情况下，系统不会合成属性访问器，则此时需要显示调用 @synthesize来定义属性的实例变量名，以便使用属性的实例变量
//  4.  @synchronized(self) { 需要锁定的代码}。 锁定一份代码只需一个锁，再多也无用

-(NSString *)string{
    if (_string) {
        return _string;
    }
    return nil;
}

-(void)setString:(NSString *)string{
    
    @synchronized(self) { // 加互斥锁
        if (![_string isEqualToString:string]) {
            _string = string;
        }
    }
}



@end
