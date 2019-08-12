//
//  NSArray+extension1.m
//  test_jobQuestions
//
//  Created by Bavaria on 2019/8/12.
//  Copyright © 2019 Jingnan Zhang. All rights reserved.
//  分类\类目不要重写原类的方法，否则会导致原类的方法无法调用




#import "NSArray+extension1.h"

@implementation NSArray (extension1) // extension1




//---------------------- 分类重写原类方法  ------------------
-(BOOL)containsObject:(id)anObject {
    MyLog(@"打印了NSArray+extension1 的containsObject");
    return NO;
}



@end
