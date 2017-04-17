//
//  NSMutableArray+category.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/10.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  分类\类目不要重写原类的方法，否则会导致原类的方法无法调用

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSMutableArray (category)

-(void)logAddObject:(id)aObject;
@end
