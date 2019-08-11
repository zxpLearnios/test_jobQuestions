//
//  Test12.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/10.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseTest.h"

@interface Test12 : NSObject
/**获取对象的所有成员变量，包含所有的属性.获取的私有变量的名和定义的名一模一样。获取的属性的名前面都添加了下划线*/
+(NSArray *)getIvarListFromClass:(Class)cl;
/** 获取对象的所有成员属性，获取的属性名和你代码写的一样,获取出来的属性名不自动添加下划线*/
+(NSArray *)getPropertyListFromClass:(Class)cl;

/**获取类名*/
+(NSString *)getClassName:(Class)cl;
/**获取类的实例方法*/
+(NSArray *)getInstanceMethodListFromClass:(Class)cl;
/**获取类的类方法*/
+(NSArray *)getClassMethodListFromClass:(Class)cl;
/**为类添加新的属性*/
+(BOOL)addNewPropertyForClass:(Class)cl;
+(void)noUse;
@end


@interface Student : NSObject{
    @private NSString *idNo; // 不会被2获取到
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;


-(NSString *)getStudentName;
-(NSString *)getStudentAge;

+(instancetype)initWithType;
@end

/// 为Student扩展
@interface Student (TestDynomic)
@property (nonatomic, strong) NSString *dynamicname;
@end

