//
//  Test13.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/17.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试ValueForKey& ValueForKeyPath的区别与联系
/*  0. KVC是Cocoa一个大招，非常牛逼。  利用KVC可以随意修改一个对象的属性或者成员变量(并且私有的也可以修改)
    1. KVC可以不通过getter／setter方法来访问对象的属性，如（TestKVCModel的height成员）成员变量
    2. valueForKey的方法根据key的值读取对象的属性，setValue:forKey:是根据key的值来写对象的属性。
     这里有几个要强调一下
         1. key的值必须正确，如果拼写错误，会直接崩溃
         2. 当key的值是没有定义的，valueForUndefinedKey:这个方法会被调用，如果你自己写了这个方法，key的值出错就会调用到这里来
         3. 因为类key反复嵌套，所以有个keyPath的概念，keyPath就是用.号来把一个一个key链接起来，这样就可以根据这个路径访问下去
         4. NSArray／NSSet等都支持KVC
    3. valueForKey与valueForKeyPath 
        forKeyPath中可以利用.运算符, 就可以一层一层往下查找对象的属性
        当然在一般的修改一个对象的属性的时候，forKey和forKeyPath,没什么区别
    
    4. 所以以后我们就用forKeyPath就行了。因为这个更强大。
 
 5. setValueForKey 若与可以对应的属性不是对象类型，则使用
 [kvcModel setValue:nil forKey:@"age"] 会直接crash。就会执行setNilValueForKey:方法,setNilValueForKey:方法的默认实现,是产生一个NSInvalidArgumentException的异常
    6. 
 
*/


#import "Test13.h"



@implementation Test13


-(void)doTest{
    
    TestKVCModel *kvcModel = [[TestKVCModel alloc] init];
    // 1.valueForKey
//    NSNumber *heightNumber = [kvcModel valueForKey:@"height"]; // 0
//    NSString *name = [kvcModel valueForKey:@"name"]; // nil
//    
    [kvcModel setValue:@(173) forKey:@"height"];
    NSNumber *heightNumber1 = [kvcModel valueForKey:@"height"]; // 173
//
//    [kvcModel setValue:@"周三" forKey:@"name"];
//    NSString *name1 = [kvcModel valueForKey:@"name"];
    
    // 2. valueForKeyPath
//    NSNumber *heightNumber = [kvcModel valueForKeyPath:@"height"]; // 0
//    NSString *name = [kvcModel valueForKeyPath:@"name"]; // nil
//    
//    [kvcModel setValue:@(173) forKeyPath:@"height"];
//    NSNumber *heightNumber1 = [kvcModel valueForKeyPath:@"height"]; // 173
//    
//    [kvcModel setValue:@"周三" forKeyPath:@"name"];
//    NSString *name1 = [kvcModel valueForKeyPath:@"name"];
    
    // 2.1 valueForKeyPath的.语法，获取对象深层次的属性
//    kvcModel.dog = [[DogModel alloc] init];
//    NSNumber *dogWeight = [kvcModel valueForKeyPath:@"dog.weight"]; // 0
//     [kvcModel setValue:@(22.5) forKeyPath:@"dog.weight"];
//    dogWeight = [kvcModel valueForKeyPath:@"dog.weight"]; // 22.5

    // 2.2  valueForKeyPath还有一个比较牛逼的 是取得一些特殊的值，如：avg、sum
//    DogModel *dog1 = [[DogModel alloc] init];
//    dog1.tag = @"dog1_tag";
//    dog1.age = 3;
//    
//    DogModel *dog2 = [[DogModel alloc] init];
//    dog2.tag = @"dog2_tag";
//    dog2.age = 4;
//    
//    kvcModel.dogs = @[dog1, dog2];
//    
//    NSNumber *dogAge =  [kvcModel valueForKeyPath:@"dogs.@avg.age"]; // age的平均数
//    NSNumber *sumAge = [kvcModel valueForKeyPath:@"dogs.@sum.age"]; // age的和
    
//    if (1 <= 2) {
//        [NSException exceptionWithName:@"异常" reason:@"测试异常" userInfo:@{}];
//    }
    
    // 3. 像height这样的外部不可直接访问的成员变量，若不setValue：forKey 的话，用valueForKey无法获取值的。但属性不setValue：forKey 的话，用valueForKey仍然可以获取值
    kvcModel.name = @"kvcModel----";
    NSString *name = [kvcModel valueForKey:@"name"];
}




@end



@implementation TestKVCModel


@end

@implementation DogModel


@end

