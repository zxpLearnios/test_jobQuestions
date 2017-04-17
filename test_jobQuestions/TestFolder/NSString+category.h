//
//  NSString+category.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/6.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

+(NSString *)deleAllBlank:(NSString *)str; // 分类的方法可以不实现，但扩展里的方法必须实现

/* 1. 类扩展(extension）是category的一个特例，有时候也被称为匿名分类。他的作用是为一个类添加一些私有的成员变量和方法
 2. 类扩展可以定义在.m文件中，这种扩展方式中定义的变量都是私有的，也可以定义在.h文件中，这样定义的代码就是共有的，类扩展在.m文件中声明私有方法是非常好的方式。类扩展中添加的新方法，一定要实现
 
 */
@end
